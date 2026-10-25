const assert = require('assert');
const fs = require('fs');
const path = require('path');
const { selectReview, selectResponse } = require('./review_output_validator');

const root = path.join(__dirname, '..');
const workflow = fs.readFileSync(path.join(root, '.github/workflows/pull-request.yaml'), 'utf8');
const models = [...workflow.matchAll(/run: bash script\/run_review_model\.sh (opencode(?:-go)?\/[^\s]+)/g)]
  .map(match => match[1]);
assert.deepStrictEqual(models, [
  'opencode/big-pickle',
  'opencode/beam-free',
  'opencode-go/deepseek-v4.1-flash',
  'opencode-go/gpt-6-luna'
]);
assert.strictEqual((workflow.match(/^        timeout-minutes: 1$/gm) || []).length, 4);
assert(workflow.includes('timeout-minutes: 5'));
assert(workflow.includes('id: scope'));
assert(workflow.includes('Require one valid review decision'));
assert(workflow.includes("steps.scope.outputs.review_required == 'true'"));
assert(workflow.includes('Install OpenCode CLI'));

const runId = '123';
const sha = 'abc';
const body = report => `${JSON.stringify(report)}\n[github run](https://github.com/o/r/actions/runs/${runId})`;
const valid = { commit_sha: sha, analysis_complete: true, summary: 'OK', findings: [] };
const comments = [
  { id: 1, updated_at: '2026-10-25T10:00:00Z', user: { login: 'github-actions[bot]' }, body: body({}) },
  { id: 2, updated_at: '2026-10-25T10:01:00Z', user: { login: 'github-actions[bot]' }, body: body(valid) },
  { id: 3, updated_at: '2026-10-25T10:02:00Z', user: { login: 'someone-else' }, body: body(valid) }
];
const selected = selectReview(comments, runId, sha);
assert.strictEqual(selected.comment.id, 2);
assert.deepStrictEqual(selected.invalidCommentIds, [1]);
const absent = selectReview([{ ...comments[0], id: 4, updated_at: '2026-10-25T10:03:00Z' }], runId, sha);
assert.strictEqual(absent.comment, null);
assert.deepStrictEqual(absent.invalidCommentIds, [4]);
const response = selectResponse(JSON.stringify({ type: 'text', part: { text: JSON.stringify(valid) } }), sha);
assert.deepStrictEqual(response.report, valid);
assert.strictEqual(selectResponse('', sha).reason, 'no-response');
console.log('Fallback workflow configuration and structured-output validation passed.');
