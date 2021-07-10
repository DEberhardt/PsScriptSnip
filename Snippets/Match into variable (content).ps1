# content becomes (if matched) a Property of automatic variable $matches
if ($EffectiveTDP.EffectiveTenantDialPlanName -match '_(?<content>.*)_') {
  $UserVoiceRouting.EffectiveDialPlan = $matches.content
}