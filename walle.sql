-- -------------------------------------------------------------
-- TablePlus 4.6.2(410)
--
-- https://tableplus.com/
--
-- Database: walle
-- Generation Time: 2023-03-17 17:38:45.3380
-- -------------------------------------------------------------


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


CREATE TABLE `group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `project_id` int unsigned NOT NULL COMMENT '项目id',
  `user_id` int NOT NULL COMMENT '用户id',
  `type` smallint DEFAULT '0' COMMENT '用户在项目中的关系类型 0普通用户， 1管理员',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `migration` (
  `version` varchar(180) NOT NULL,
  `apply_time` int DEFAULT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `project` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL COMMENT '添加项目的用户id',
  `name` varchar(100) DEFAULT 'master' COMMENT '项目名字',
  `level` smallint NOT NULL COMMENT '项目环境1：测试，2：仿真，3：线上',
  `status` smallint NOT NULL DEFAULT '1' COMMENT '状态0：无效，1有效',
  `version` varchar(32) DEFAULT NULL COMMENT '线上当前版本，用于快速回滚',
  `repo_url` varchar(200) DEFAULT '' COMMENT 'git地址',
  `repo_username` varchar(50) DEFAULT '' COMMENT '版本管理系统的用户名，一般为svn的用户名',
  `repo_password` varchar(100) DEFAULT '' COMMENT '版本管理系统的密码，一般为svn的密码',
  `repo_mode` varchar(50) DEFAULT 'branch' COMMENT '上线方式：branch/tag',
  `repo_type` varchar(10) DEFAULT 'git' COMMENT '上线方式：git/svn',
  `deploy_from` varchar(200) NOT NULL COMMENT '宿主机存放clone出来的文件',
  `excludes` text COMMENT '要排除的文件',
  `release_user` varchar(50) NOT NULL COMMENT '目标机器用户',
  `release_to` varchar(200) NOT NULL COMMENT '目标机器的目录，相当于nginx的root，可直接web访问',
  `release_library` varchar(200) NOT NULL COMMENT '目标机器版本发布库',
  `hosts` text COMMENT '目标机器列表',
  `pre_deploy` text COMMENT '部署前置任务',
  `post_deploy` text COMMENT '同步之前任务',
  `pre_release` text COMMENT '同步之前目标机器执行的任务',
  `post_release` text COMMENT '同步之后目标机器执行的任务',
  `post_release_delay` int NOT NULL DEFAULT '0' COMMENT '每台目标机执行post_release任务间隔/延迟时间 单位:秒',
  `audit` smallint DEFAULT '0' COMMENT '是否需要审核任务0不需要，1需要',
  `ansible` smallint NOT NULL DEFAULT '0' COMMENT '是否启用Ansible 0关闭，1开启',
  `keep_version_num` int NOT NULL DEFAULT '20' COMMENT '线上版本保留数',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `record` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL COMMENT '用户id',
  `task_id` bigint NOT NULL COMMENT '任务id',
  `status` smallint NOT NULL DEFAULT '1' COMMENT '状态1：成功，0失败',
  `action` int unsigned DEFAULT '10' COMMENT '任务执行到的阶段',
  `command` text COMMENT '运行命令',
  `duration` int DEFAULT '0' COMMENT '耗时，单位ms',
  `memo` text COMMENT '日志/备注',
  `created_at` int DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `session` (
  `id` varchar(40) NOT NULL,
  `expire` int unsigned DEFAULT NULL,
  `data` blob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `task` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL COMMENT '用户id',
  `project_id` int NOT NULL DEFAULT '0' COMMENT '项目id',
  `action` smallint NOT NULL DEFAULT '0' COMMENT '0全新上线，2回滚',
  `status` smallint NOT NULL DEFAULT '0' COMMENT '状态0：新建提交，1审核通过，2审核拒绝，3上线完成，4上线失败',
  `title` varchar(100) DEFAULT '' COMMENT '上线的软链号',
  `link_id` varchar(20) DEFAULT '' COMMENT '上线的软链号',
  `ex_link_id` varchar(20) DEFAULT '' COMMENT '上一次上线的软链号',
  `commit_id` varchar(100) DEFAULT '' COMMENT 'git commit id',
  `branch` varchar(100) DEFAULT 'master' COMMENT '选择上线的分支',
  `file_transmission_mode` smallint NOT NULL DEFAULT '1' COMMENT '上线文件模式: 1.全量所有文件 2.指定文件列表',
  `file_list` text COMMENT '文件列表，svn上线方式可能会产生',
  `enable_rollback` int NOT NULL DEFAULT '1' COMMENT '能否回滚此版本:0no 1yes',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `is_email_verified` tinyint(1) NOT NULL DEFAULT '0',
  `auth_key` varchar(32) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `password_reset_token` varchar(255) DEFAULT NULL,
  `email_confirmation_token` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `avatar` varchar(100) DEFAULT 'default.jpg' COMMENT '头像图片地址',
  `role` smallint NOT NULL DEFAULT '1',
  `status` smallint NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `realname` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;

INSERT INTO `migration` (`version`, `apply_time`) VALUES
('m000000_000000_base', 1679045827),
('m140328_144900_init', 1679045832),
('m150926_151034_init_user', 1679045832),
('m150927_061454_alter_conf_to_mysql', 1679045833),
('m150929_004629_change_record_action', 1679045833),
('m150929_034627_session_to_mysql', 1679045833),
('m150929_115951_project_user_group', 1679045833),
('m151005_001053_alter_conf_2_project', 1679045833),
('m151010_050344_group_user_admin', 1679045833),
('m151011_054352_task_need_more_long', 1679045834),
('m151012_135612_task_add_branch', 1679045834),
('m151014_115546_add_pre_release_task', 1679045834),
('m151018_032238_support_svn', 1679045834),
('m151027_063246_keep_version_num', 1679045834),
('m160307_082032_ansible', 1679045834),
('m160402_173643_add_post_release_delay', 1679045834),
('m160418_035413_user_status_migrate', 1679045834),
('m160420_015223_add_file_transmission_mode', 1679045835);

INSERT INTO `user` (`id`, `username`, `is_email_verified`, `auth_key`, `password_hash`, `password_reset_token`, `email_confirmation_token`, `email`, `avatar`, `role`, `status`, `created_at`, `updated_at`, `realname`) VALUES
(1, 'admin', 1, 'cJIrTa_b2Hnjn6BZkrL8PJkYto2Ael3O', '$2y$13$PB5IFQ9IEvuvDmSnUsPErOKT3NZ.xEGNLg3aTTJRq0zycv/XO0wUW', NULL, 'UpToOIawm1L8GjN6pLO4r-1oj20nLT5f_1443280741', 'admin@xxx.com', 'default.jpg', 2, 2, '2015-09-26 21:20:32', '2015-09-26 21:20:32', '管理员'),
(2, 'demo', 1, 'RpFh1J9E0MrGY31e_Z7GIh3EkC6hS0aa', '$2y$13$YoqhrkWcr1ZXADOSkj4S..jUAWlIrXdfcP00STqEMpF1d1b85SU7a', NULL, 'YnR4Z6bfK3fle7QP_t6wcnB5zSP__nkz_1443280906', 'admin@xxx.com', 'default.jpg', 1, 1, '2015-09-26 21:20:32', '2015-09-26 21:20:32', 'demo');



/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;