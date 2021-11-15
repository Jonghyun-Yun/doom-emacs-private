(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(hl-todo-keyword-faces
   '(("TODO" . "#dc752f")
     ("NEXT" . "#dc752f")
     ("THEM" . "#2d9574")
     ("PROG" . "#4f97d7")
     ("OKAY" . "#4f97d7")
     ("DONT" . "#f2241f")
     ("FAIL" . "#f2241f")
     ("DONE" . "#86dc2f")
     ("NOTE" . "#b1951d")
     ("KLUDGE" . "#b1951d")
     ("HACK" . "#b1951d")
     ("TEMP" . "#b1951d")
     ("FIXME" . "#dc752f")
     ("XXX+" . "#dc752f")
     ("\\?\\?\\?+" . "#dc752f")))
 '(mathpix-app-id (password-store-get "mathpix/app-id") nil nil "Customized with use-package mathpix.el")
 '(mathpix-app-key (password-store-get "mathpix/app-key") nil nil "Customized with use-package mathpix.el")
 '(mathpix-screenshot-method "screencapture -i %s" nil nil "Customized with use-package mathpix.el")
 '(org-agenda-files
   '("/Users/yunj/Dropbox/MobileOrg/roam/20190917223400-mu4e.org" "/Users/yunj/Dropbox/MobileOrg/roam/2019_data_science_bowl_kaggle.org" "/Users/yunj/Dropbox/MobileOrg/roam/20200606102111-doom-binding.org" "/Users/yunj/Dropbox/MobileOrg/roam/20201203084446-dr_suyun_ham.org" "/Users/yunj/Dropbox/MobileOrg/roam/20201203090629-deep_learning.org" "/Users/yunj/Dropbox/MobileOrg/roam/20210305193748-osx.org" "/Users/yunj/Dropbox/MobileOrg/roam/20210305193751-emacs.org" "/Users/yunj/Dropbox/MobileOrg/roam/20210308095005-mcmc_samplers.org" "/Users/yunj/Dropbox/MobileOrg/roam/20210308172137-centOS7.org" "/Users/yunj/Dropbox/MobileOrg/roam/20210308172137-jeon_jin.org" "/Users/yunj/Dropbox/MobileOrg/roam/20210408180632-redhat.org" "/Users/yunj/Dropbox/MobileOrg/roam/20210424070218-latex.org" "/Users/yunj/Dropbox/MobileOrg/roam/20210424070855-m_x_r.org" "/Users/yunj/Dropbox/MobileOrg/roam/20210424071410-m_x_cpp_mode.org" "/Users/yunj/Dropbox/MobileOrg/roam/20210426110515-natural_language_processing_nlp.org" "/Users/yunj/Dropbox/MobileOrg/roam/20210428103148-org_to_word_export_backend.org" "/Users/yunj/Dropbox/MobileOrg/roam/20210429023135-binding_prefix_for_sparse_keymap.org" "/Users/yunj/Dropbox/MobileOrg/roam/20210525091523-maximum_marginal_likelihood_mml.org" "/Users/yunj/Dropbox/MobileOrg/roam/20210525201045-moderation_analysis.org" "/Users/yunj/Dropbox/MobileOrg/roam/20210629145423-lsp_for_rcpp_project.org" "/Users/yunj/Dropbox/MobileOrg/roam/20210806002917-gdb_on_mac_codesign.org" "/Users/yunj/Dropbox/MobileOrg/roam/a_winner_s_interview_with_limerobot.org" "/Users/yunj/Dropbox/MobileOrg/roam/abo_abo_lispy_short_and_sweet_lisp_editing.org" "/Users/yunj/Dropbox/MobileOrg/roam/adding_updating_github_access_token_on_mac.org" "/Users/yunj/Dropbox/MobileOrg/roam/adjusting_for_differences_between_treatment_and_control_groups_statistical_significance_and_multiple_testing_have_nothing_to_do_with_it_statistical_modeling_causal_inference_and_social_science.org" "/Users/yunj/Dropbox/MobileOrg/roam/altmann_permutation_2010.org" "/Users/yunj/Dropbox/MobileOrg/roam/apley_visualizing_2020.org" "/Users/yunj/Dropbox/MobileOrg/roam/bash_how_can_i_format_a_column_of_numbers_in_an_emacs_org_mode_table_stack_overflow.org" "/Users/yunj/Dropbox/MobileOrg/roam/bayesian_survival_analysis_using_the_rstanarm_r_package_2002_09633_pdf.org" "/Users/yunj/Dropbox/MobileOrg/roam/become_a_successful_game_developer_unity.org" "/Users/yunj/Dropbox/MobileOrg/roam/build_process_call_cmake_from_make_to_create_makefiles_stack_overflow.org" "/Users/yunj/Dropbox/MobileOrg/roam/cdominik_cdlatex_fast_input_methods_to_enter_latex_environments_and_math_with_gnu_emacs.org" "/Users/yunj/Dropbox/MobileOrg/roam/chryswoods_com_part_2_tbb_parallel_reduce.org" "/Users/yunj/Dropbox/MobileOrg/roam/classify_text_with_bert_tensorflow_core.org" "/Users/yunj/Dropbox/MobileOrg/roam/cohen_s_kappa_wikipedia.org" "/Users/yunj/Dropbox/MobileOrg/roam/competing_risks_survival_models_modeling_the_stan_forums.org" "/Users/yunj/Dropbox/MobileOrg/roam/connecting_to_other_packages.org" "/Users/yunj/Dropbox/MobileOrg/roam/copy_paste_evil_is_there_a_default_register_that_does_not_get_overwritten_by_later_yanks_to_explicit_registers_emacs_stack_exchange.org" "/Users/yunj/Dropbox/MobileOrg/roam/crowther_parametric_2017.org" "/Users/yunj/Dropbox/MobileOrg/roam/dap_mode.org" "/Users/yunj/Dropbox/MobileOrg/roam/debugging_with_gdb_variables.org" "/Users/yunj/Dropbox/MobileOrg/roam/deploying_hugo_to_github_pages_with_github_actions_t.org" "/Users/yunj/Dropbox/MobileOrg/roam/eigen_storage_orders.org" "/Users/yunj/Dropbox/MobileOrg/roam/emacs_key_bindings.org" "/Users/yunj/Dropbox/MobileOrg/roam/emacs_keyboard_setup_osx.org" "/Users/yunj/Dropbox/MobileOrg/roam/emacs_vs_vim_keybindings_for_emacs_emacs.org" "/Users/yunj/Dropbox/MobileOrg/roam/emacswiki_dynamic_binding_vs_lexical_binding.org" "/Users/yunj/Dropbox/MobileOrg/roam/ggplot2_cheatsheet_ggplot2_cheatsheet_pdf.org" "/Users/yunj/Dropbox/MobileOrg/roam/github_iyefrat_evil_tex_some_evil_oriented_additions_to_latex_document_editing_in_emacs.org" "/Users/yunj/Dropbox/MobileOrg/roam/global_variables_in_r_stack_overflow.org" "/Users/yunj/Dropbox/MobileOrg/roam/graph_plantuml_graphviz.org" "/Users/yunj/Dropbox/MobileOrg/roam/header_arguments_in_org_mode_properties_the_org_manual.org" "/Users/yunj/Dropbox/MobileOrg/roam/headers_and_footers_overleaf_online_latex_editor.org" "/Users/yunj/Dropbox/MobileOrg/roam/hlissner_doom_emacs_an_emacs_framework_for_the_stubborn_martian_hacker.org" "/Users/yunj/Dropbox/MobileOrg/roam/hlissner_emacs_doom_themes_an_opinionated_pack_of_modern_color_themes.org" "/Users/yunj/Dropbox/MobileOrg/roam/how_do_i_run_a_program_with_commandline_arguments_using_gdb_within_a_bash_script.org" "/Users/yunj/Dropbox/MobileOrg/roam/how_to_debug_using_gdb.org" "/Users/yunj/Dropbox/MobileOrg/roam/how_to_do_case_insensitive_search_in_vim_and_emacs_stack_overflow.org" "/Users/yunj/Dropbox/MobileOrg/roam/how_to_fix_failed_to_load_cairo_dll_in_r_stack_overflow.org" "/Users/yunj/Dropbox/MobileOrg/roam/how_to_think_about_identifiability_in_bayesian_inference_statistical_modeling_causal_inference_and_social_science.org" "/Users/yunj/Dropbox/MobileOrg/roam/how_to_use_the_conda_env_issue_7_emacs_lsp_lsp_pyright.org" "/Users/yunj/Dropbox/MobileOrg/roam/imagemagick_convert_edit_or_compose_digital_images.org" "/Users/yunj/Dropbox/MobileOrg/roam/interview_questions_to_assess_decision_making_skills.org" "/Users/yunj/Dropbox/MobileOrg/roam/introduction_into_semantic_modelling_for_natural_language_processing_by_aaron_radzinski_chatbots_life.org" "/Users/yunj/Dropbox/MobileOrg/roam/jackson_flexsurv_2016.org" "/Users/yunj/Dropbox/MobileOrg/roam/keep_file_in_a_git_repo_but_don_t_track_changes.org" "/Users/yunj/Dropbox/MobileOrg/roam/kraemer_how_2001.org" "/Users/yunj/Dropbox/MobileOrg/roam/languagetool_dev_languagetool_org.org" "/Users/yunj/Dropbox/MobileOrg/roam/lcomm_semicompstan_implementing_basic_semicompeting_risks_illness_death_models_in_stan.org" "/Users/yunj/Dropbox/MobileOrg/roam/limitations_of_interpretable_machine_learning_methods.org" "/Users/yunj/Dropbox/MobileOrg/roam/linuxing3_doom_emacs_private_doom_emacs_private_configuration.org" "/Users/yunj/Dropbox/MobileOrg/roam/macos_install_specific_version_of_r_via_homebrew_stack_overflow.org" "/Users/yunj/Dropbox/MobileOrg/roam/managing_arxiv_rss_feeds_in_emacs_chris_cundy.org" "/Users/yunj/Dropbox/MobileOrg/roam/nembrini_revival_2018.org" "/Users/yunj/Dropbox/MobileOrg/roam/noel_welsh_doom_emacs_workflows.org" "/Users/yunj/Dropbox/MobileOrg/roam/piaac_log_files_piaac_the_oecd_s_programme_of_assessment_and_analysis_of_adult_skills.org" "/Users/yunj/Dropbox/MobileOrg/roam/power_of_g_vim_tips_wiki_fandom.org" "/Users/yunj/Dropbox/MobileOrg/roam/primer_on_regular_expressions_inside_of_emacs_protesilaos_stavrou.org" "/Users/yunj/Dropbox/MobileOrg/roam/process_data_modeling.org" "/Users/yunj/Dropbox/MobileOrg/roam/putter_tutorial_2007.org" "/Users/yunj/Dropbox/MobileOrg/roam/ramsay_monotone_regression_splines_in_action.org" "/Users/yunj/Dropbox/MobileOrg/roam/rcpp_for_everyone.org" "/Users/yunj/Dropbox/MobileOrg/roam/rcppnumerical_rcpp_integration_for_numerical_computing_libraries.org" "/Users/yunj/Dropbox/MobileOrg/roam/rougier_nano_emacs_gnu_emacs_n_λ_n_o.org" "/Users/yunj/Dropbox/MobileOrg/roam/rpubs_bida_in_stan_piecewise_constant_hazard_cox.org" "/Users/yunj/Dropbox/MobileOrg/roam/rpubs_rstanarm_feature_survival_branch.org" "/Users/yunj/Dropbox/MobileOrg/roam/sharkdp_fd_a_simple_fast_and_user_friendly_alternative_to_find.org" "/Users/yunj/Dropbox/MobileOrg/roam/shellcheck_shell_script_analysis_tool.org" "/Users/yunj/Dropbox/MobileOrg/roam/some_r_packages_for_roc_curves_r_views.org" "/Users/yunj/Dropbox/MobileOrg/roam/stan_for_survival_models_modeling_the_stan_forums.org" "/Users/yunj/Dropbox/MobileOrg/roam/stan_user_s_guide.org" "/Users/yunj/Dropbox/MobileOrg/roam/su_testing_2020.org" "/Users/yunj/Dropbox/MobileOrg/roam/survival_models_in_rstanarm_developers_the_stan_forums.org" "/Users/yunj/Dropbox/MobileOrg/roam/tar_command_examples_in_linux.org" "/Users/yunj/Dropbox/MobileOrg/roam/the_capture_protocol_the_org_manual.org" "/Users/yunj/Dropbox/MobileOrg/roam/the_community_m_x_research.org" "/Users/yunj/Dropbox/MobileOrg/roam/the_spacefn_layout_trying_to_end_keyboard_inflation.org" "/Users/yunj/Dropbox/MobileOrg/roam/the_unofficial_google_data_science_blog.org" "/Users/yunj/Dropbox/MobileOrg/roam/this_month_in_org_mode.org" "/Users/yunj/Dropbox/MobileOrg/roam/top_challenges_from_the_first_practical_online_controlled_experiments_summit_facebook_research.org" "/Users/yunj/Dropbox/MobileOrg/roam/using_the_stan_math_c_library.org" "/Users/yunj/Dropbox/MobileOrg/roam/van_den_hout_bayesian_2015.org" "/Users/yunj/Dropbox/MobileOrg/roam/which_opentype_math_fonts_are_available_tex_latex_stack_exchange.org" "/Users/yunj/Dropbox/MobileOrg/roam/word2vec_skip_grams_tensorflow_core.org" "/Users/yunj/Dropbox/MobileOrg/roam/wrong_diagnostics_on_macos_w_clang10_issue_622_maskray_ccls.org" "/Users/yunj/org/inbox.org" "/Users/yunj/org/todo.org" "/Users/yunj/org/gcal.org" "/Users/yunj/org/projects.org" "/Users/yunj/org/tickler.org" "/Users/yunj/org/routines.org" "/Users/yunj/org/journal.org" "/Users/yunj/org/notes.org"))
 '(safe-local-variable-values
   '((TeX-engine . default)
     (org-babel-default-header-args:R
      (:session . "*R-COR*")
      (:export . "both")
      (:results . "output replace")
      (:width . 700)
      (:height . 700))
     (reftex-default-bibliography "/Users/yunj/Zotero/myref.bib")
     (org-babel-default-header-args:R
      (:session . "*R-COR*")
      (:export . "both")
      (:results . "output replace"))
     (flyspell-mode . -1)
     (org-babel-default-header-args:R
      (:session . "*R-Org*")
      (:export . "both")
      (:results . "output replace"))
     (org-babel-default-header-args:R
      (:session . "*R-PIACC*")
      (:export . "both")
      (:results . "output replace"))
     (TeX-engine . xetex))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:foreground "white" :background "red" :weight bold :height 2.5 :box (:line-width 10 :color "red")))))
 '(org-document-title ((t (:height 1.2))))
 '(outline-1 ((t (:weight semi-bold :height 1.25))))
 '(outline-2 ((t (:weight semi-bold :height 1.15))))
 '(outline-3 ((t (:weight semi-bold :height 1.12))))
 '(outline-4 ((t (:weight semi-bold :height 1.09))))
 '(outline-5 ((t (:weight semi-bold :height 1.06))))
 '(outline-6 ((t (:weight semi-bold :height 1.03))))
 '(outline-8 ((t (:weight semi-bold))))
 '(outline-9 ((t (:weight semi-bold)))))
(put 'narrow-to-region 'disabled nil)
