import type { OpenClawConfig } from "../../../config/config.js";
import type { RuntimeEnv } from "../../../runtime.js";
import type { OnboardOptions } from "../../onboard-types.js";

export function applyNonInteractiveSkillsConfig(params: {
  nextConfig: OpenClawConfig;
  opts: OnboardOptions;
  runtime: RuntimeEnv;
}): OpenClawConfig {
  const { nextConfig, opts } = params;

  // If skipSkills is true, return config as-is
  if (opts.skipSkills) {
    return nextConfig;
  }

  // Skills configuration is handled elsewhere in the onboarding flow
  // For non-interactive mode, we just pass through the config
  // The actual skills setup happens in the onboard-skills.ts module

  return nextConfig;
}
