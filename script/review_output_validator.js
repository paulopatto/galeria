function parseComment(comment) {
  return parseText(comment.body.split(/\n+\[github run\]\(/)[0]);
}

function parseText(text) {
  return JSON.parse(text.trim().replace(/^```(?:json)?\s*/i, '').replace(/\s*```$/, ''));
}

function validFinding(finding) {
  return finding && ['critical', 'high', 'medium', 'low'].includes(finding.severity) &&
    ['title', 'file', 'impact', 'correction'].every(key =>
      typeof finding[key] === 'string' && finding[key].trim().length > 0) &&
    Number.isInteger(finding.line) && finding.line > 0;
}

function validReport(report, expectedSha) {
  return report && report.commit_sha === expectedSha &&
    typeof report.analysis_complete === 'boolean' &&
    typeof report.summary === 'string' && report.summary.trim().length > 0 &&
    Array.isArray(report.findings) && report.findings.every(validFinding);
}

function selectReview(comments, runId, expectedSha) {
  const marker = `/actions/runs/${runId}`;
  const candidates = comments.filter(comment =>
    comment.user?.login === 'github-actions[bot]' && comment.body?.includes(marker + ')'))
    .sort((left, right) => right.updated_at.localeCompare(left.updated_at) || right.id - left.id);
  let reason = candidates.length ? 'invalid-json' : 'no-comment';
  const invalidCommentIds = [];
  let selected = null;
  for (const comment of candidates) {
    try {
      const report = parseComment(comment);
      if (validReport(report, expectedSha) && !selected) {
        selected = { comment, report };
        reason = 'valid-decision';
        continue;
      }
      reason = 'invalid-schema';
    } catch (_) {
      reason = 'invalid-json';
    }
    invalidCommentIds.push(comment.id);
  }
  return { comment: selected?.comment || null, report: selected?.report || null, invalidCommentIds,
    reason: selected ? 'valid-decision' : reason };
}

function selectResponse(output, expectedSha) {
  const lines = output.split('\n').filter(Boolean);
  let reason = lines.length ? 'invalid-json' : 'no-response';
  for (const line of lines) {
    try {
      const event = JSON.parse(line);
      if (event.type !== 'text') continue;
      const report = parseText(event.part?.text || event.text || '');
      if (validReport(report, expectedSha)) return { comment: null, report, invalidCommentIds: [], reason: 'valid-decision' };
      reason = 'invalid-schema';
    } catch (_) {
      reason = 'invalid-json';
    }
  }
  return { comment: null, report: null, invalidCommentIds: [], reason };
}

module.exports = { selectReview, selectResponse, validReport };
