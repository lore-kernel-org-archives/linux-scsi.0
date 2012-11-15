From: kbuild test robot <fengguang.wu@intel.com>
Subject: [scsi:misc 36/36] drivers/scsi/csiostor/csio_attr.c:92:41:
 sparse: incorrect type in assignment (different base types)
Date: Fri, 16 Nov 2012 02:29:44 +0800
Message-ID: <50a53498.V1y2+GrYc8qRSL1F%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15675 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1768466Ab2KOSaD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Nov 2012 13:30:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Naresh Kumar Inna <naresh@chelsio.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <JBottomley@Parallels.com>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git misc
head:   0779fa137a73170b6c796fdb476f1455ba67b9aa
commit: 0779fa137a73170b6c796fdb476f1455ba67b9aa [36/36] [SCSI] csiostor: Chelsio FCoE offload driver


sparse warnings:

+ drivers/scsi/csiostor/csio_attr.c:92:41: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_attr.c:92:41:    expected unsigned int [unsigned] [usertype] maxframe_size
drivers/scsi/csiostor/csio_attr.c:92:41:    got restricted __be16 [usertype] sp_bb_data
drivers/scsi/csiostor/csio_attr.c:195:38: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_attr.c:195:38:    expected unsigned int [unsigned] [usertype] maxframe_size
drivers/scsi/csiostor/csio_attr.c:195:38:    got restricted __be16 [usertype] sp_bb_data
+ drivers/scsi/csiostor/csio_attr.c:328:44: sparse: restricted __be64 degrades to integer
drivers/scsi/csiostor/csio_attr.c:329:48: sparse: restricted __be64 degrades to integer
drivers/scsi/csiostor/csio_attr.c:330:48: sparse: restricted __be64 degrades to integer
drivers/scsi/csiostor/csio_attr.c:331:48: sparse: restricted __be64 degrades to integer
drivers/scsi/csiostor/csio_attr.c:332:43: sparse: restricted __be64 degrades to integer
drivers/scsi/csiostor/csio_attr.c:333:43: sparse: restricted __be64 degrades to integer
drivers/scsi/csiostor/csio_attr.c:334:43: sparse: restricted __be64 degrades to integer
drivers/scsi/csiostor/csio_attr.c:335:43: sparse: restricted __be64 degrades to integer
drivers/scsi/csiostor/csio_attr.c:337:43: sparse: restricted __be64 degrades to integer
drivers/scsi/csiostor/csio_attr.c:338:48: sparse: restricted __be64 degrades to integer
drivers/scsi/csiostor/csio_attr.c:339:48: sparse: restricted __be64 degrades to integer
drivers/scsi/csiostor/csio_attr.c:340:42: sparse: restricted __be64 degrades to integer
drivers/scsi/csiostor/csio_attr.c:341:48: sparse: restricted __be64 degrades to integer
drivers/scsi/csiostor/csio_attr.c:342:48: sparse: restricted __be64 degrades to integer
+ drivers/scsi/csiostor/csio_attr.c:344:27: sparse: invalid assignment: +=
drivers/scsi/csiostor/csio_attr.c:344:27:    left side has type unsigned long long
drivers/scsi/csiostor/csio_attr.c:344:27:    right side has type restricted __be64
--
+ drivers/scsi/csiostor/csio_hw.c:192:25: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_hw.c:192:25:    expected unsigned int [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_hw.c:192:25:    got restricted __be32 [usertype] <noident>
drivers/scsi/csiostor/csio_hw.c:233:25: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_hw.c:233:25:    expected unsigned int [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_hw.c:233:25:    got restricted __be32 [usertype] <noident>
drivers/scsi/csiostor/csio_hw.c:269:33: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_hw.c:269:33:    expected restricted __be32 [usertype] <noident>
drivers/scsi/csiostor/csio_hw.c:269:33:    got unsigned int
+ drivers/scsi/csiostor/csio_hw.c:271:25: sparse: incorrect type in argument 1 (different base types)
drivers/scsi/csiostor/csio_hw.c:271:25:    expected unsigned int [unsigned] val
drivers/scsi/csiostor/csio_hw.c:271:25:    got restricted __be32 [usertype] <noident>
drivers/scsi/csiostor/csio_hw.c:350:48: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_hw.c:350:48:    expected restricted __be32 [usertype] <noident>
drivers/scsi/csiostor/csio_hw.c:350:48:    got unsigned int [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_hw.c:371:40: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_hw.c:371:40:    expected unsigned int [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_hw.c:371:40:    got restricted __be32 [usertype] <noident>
drivers/scsi/csiostor/csio_hw.c:384:53: sparse: incorrect type in argument 5 (different base types)
drivers/scsi/csiostor/csio_hw.c:384:53:    expected unsigned int [usertype] *[assigned] buf
drivers/scsi/csiostor/csio_hw.c:384:53:    got restricted __be32 [usertype] *buf
+ drivers/scsi/csiostor/csio_hw.c:431:17: sparse: cast to restricted __le32
drivers/scsi/csiostor/csio_hw.c:711:31: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_hw.c:711:31:    expected unsigned int [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_hw.c:711:31:    got restricted __be32 [usertype] <noident>
+ drivers/scsi/csiostor/csio_hw.c:960:25: sparse: cast to restricted __be32
+ drivers/scsi/csiostor/csio_hw.c:960:25: sparse: cast to restricted __be32
+ drivers/scsi/csiostor/csio_hw.c:960:25: sparse: cast to restricted __be32
+ drivers/scsi/csiostor/csio_hw.c:960:25: sparse: cast to restricted __be32
+ drivers/scsi/csiostor/csio_hw.c:960:25: sparse: cast to restricted __be32
+ drivers/scsi/csiostor/csio_hw.c:960:25: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_hw.c:2146:58: sparse: incorrect type in argument 5 (different base types)
drivers/scsi/csiostor/csio_hw.c:2146:58:    expected restricted __be32 [usertype] *buf
drivers/scsi/csiostor/csio_hw.c:2146:58:    got unsigned int [usertype] *[assigned] cfg_data
--
+ drivers/scsi/csiostor/csio_init.c:91:56: sparse: incorrect type in argument 3 (different base types)
drivers/scsi/csiostor/csio_init.c:91:56:    expected unsigned int [usertype] *<noident>
drivers/scsi/csiostor/csio_init.c:91:56:    got restricted __be32 *<noident>
drivers/scsi/csiostor/csio_init.c:93:62: sparse: incorrect type in argument 4 (different base types)
drivers/scsi/csiostor/csio_init.c:93:62:    expected unsigned int [usertype] *<noident>
drivers/scsi/csiostor/csio_init.c:93:62:    got restricted __be32 *<noident>
--
+ drivers/scsi/csiostor/csio_lnode.c:217:21: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_lnode.c:217:21:    expected restricted __be16 [usertype] ct_cmd
drivers/scsi/csiostor/csio_lnode.c:217:21:    got unsigned short [unsigned] [usertype] op
+ drivers/scsi/csiostor/csio_lnode.c:314:60: sparse: incorrect type in argument 4 (different base types)
drivers/scsi/csiostor/csio_lnode.c:314:60:    expected unsigned short [unsigned] [usertype] op
drivers/scsi/csiostor/csio_lnode.c:314:60:    got restricted __be16 [usertype] <noident>
+ drivers/scsi/csiostor/csio_lnode.c:334:29: sparse: incompatible types for operation (++)
drivers/scsi/csiostor/csio_lnode.c:334:29:    argument has type restricted __be32 [usertype] numattrs
drivers/scsi/csiostor/csio_lnode.c:339:29: sparse: incompatible types for operation (++)
drivers/scsi/csiostor/csio_lnode.c:339:29:    argument has type restricted __be32 [usertype] numattrs
drivers/scsi/csiostor/csio_lnode.c:350:29: sparse: incompatible types for operation (++)
drivers/scsi/csiostor/csio_lnode.c:350:29:    argument has type restricted __be32 [usertype] numattrs
drivers/scsi/csiostor/csio_lnode.c:355:29: sparse: incompatible types for operation (++)
drivers/scsi/csiostor/csio_lnode.c:355:29:    argument has type restricted __be32 [usertype] numattrs
drivers/scsi/csiostor/csio_lnode.c:360:29: sparse: incompatible types for operation (++)
drivers/scsi/csiostor/csio_lnode.c:360:29:    argument has type restricted __be32 [usertype] numattrs
drivers/scsi/csiostor/csio_lnode.c:365:37: sparse: incompatible types for operation (++)
drivers/scsi/csiostor/csio_lnode.c:365:37:    argument has type restricted __be32 [usertype] numattrs
drivers/scsi/csiostor/csio_lnode.c:439:29: sparse: incompatible types for operation (++)
drivers/scsi/csiostor/csio_lnode.c:439:29:    argument has type restricted __be32 [usertype] numattrs
drivers/scsi/csiostor/csio_lnode.c:446:29: sparse: incompatible types for operation (++)
drivers/scsi/csiostor/csio_lnode.c:446:29:    argument has type restricted __be32 [usertype] numattrs
drivers/scsi/csiostor/csio_lnode.c:449:29: sparse: incompatible types for operation (++)
drivers/scsi/csiostor/csio_lnode.c:449:29:    argument has type restricted __be32 [usertype] numattrs
drivers/scsi/csiostor/csio_lnode.c:452:29: sparse: incompatible types for operation (++)
drivers/scsi/csiostor/csio_lnode.c:452:29:    argument has type restricted __be32 [usertype] numattrs
drivers/scsi/csiostor/csio_lnode.c:455:29: sparse: incompatible types for operation (++)
drivers/scsi/csiostor/csio_lnode.c:455:29:    argument has type restricted __be32 [usertype] numattrs
drivers/scsi/csiostor/csio_lnode.c:458:29: sparse: incompatible types for operation (++)
drivers/scsi/csiostor/csio_lnode.c:458:29:    argument has type restricted __be32 [usertype] numattrs
drivers/scsi/csiostor/csio_lnode.c:461:29: sparse: incompatible types for operation (++)
drivers/scsi/csiostor/csio_lnode.c:461:29:    argument has type restricted __be32 [usertype] numattrs
drivers/scsi/csiostor/csio_lnode.c:466:37: sparse: incompatible types for operation (++)
drivers/scsi/csiostor/csio_lnode.c:466:37:    argument has type restricted __be32 [usertype] numattrs
drivers/scsi/csiostor/csio_lnode.c:473:29: sparse: incompatible types for operation (++)
drivers/scsi/csiostor/csio_lnode.c:473:29:    argument has type restricted __be32 [usertype] numattrs
--
+ drivers/scsi/csiostor/csio_mb.c:1145:57: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_mb.c:1145:57:    expected restricted __be64 [usertype] tx_bcast_bytes
drivers/scsi/csiostor/csio_mb.c:1145:57:    got unsigned long long
drivers/scsi/csiostor/csio_mb.c:1147:57: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_mb.c:1147:57:    expected restricted __be64 [usertype] tx_bcast_frames
drivers/scsi/csiostor/csio_mb.c:1147:57:    got unsigned long long
drivers/scsi/csiostor/csio_mb.c:1149:57: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_mb.c:1149:57:    expected restricted __be64 [usertype] tx_mcast_bytes
drivers/scsi/csiostor/csio_mb.c:1149:57:    got unsigned long long
drivers/scsi/csiostor/csio_mb.c:1151:57: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_mb.c:1151:57:    expected restricted __be64 [usertype] tx_mcast_frames
drivers/scsi/csiostor/csio_mb.c:1151:57:    got unsigned long long
drivers/scsi/csiostor/csio_mb.c:1153:57: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_mb.c:1153:57:    expected restricted __be64 [usertype] tx_ucast_bytes
drivers/scsi/csiostor/csio_mb.c:1153:57:    got unsigned long long
drivers/scsi/csiostor/csio_mb.c:1155:57: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_mb.c:1155:57:    expected restricted __be64 [usertype] tx_ucast_frames
drivers/scsi/csiostor/csio_mb.c:1155:57:    got unsigned long long
drivers/scsi/csiostor/csio_mb.c:1160:57: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_mb.c:1160:57:    expected restricted __be64 [usertype] tx_drop_frames
drivers/scsi/csiostor/csio_mb.c:1160:57:    got unsigned long long
drivers/scsi/csiostor/csio_mb.c:1162:57: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_mb.c:1162:57:    expected restricted __be64 [usertype] tx_offload_bytes
drivers/scsi/csiostor/csio_mb.c:1162:57:    got unsigned long long
drivers/scsi/csiostor/csio_mb.c:1164:57: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_mb.c:1164:57:    expected restricted __be64 [usertype] tx_offload_frames
drivers/scsi/csiostor/csio_mb.c:1164:57:    got unsigned long long
drivers/scsi/csiostor/csio_mb.c:1172:57: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_mb.c:1172:57:    expected restricted __be64 [usertype] rx_bcast_bytes
drivers/scsi/csiostor/csio_mb.c:1172:57:    got unsigned long long
drivers/scsi/csiostor/csio_mb.c:1174:57: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_mb.c:1174:57:    expected restricted __be64 [usertype] rx_bcast_frames
drivers/scsi/csiostor/csio_mb.c:1174:57:    got unsigned long long
drivers/scsi/csiostor/csio_mb.c:1176:57: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_mb.c:1176:57:    expected restricted __be64 [usertype] rx_mcast_bytes
drivers/scsi/csiostor/csio_mb.c:1176:57:    got unsigned long long
drivers/scsi/csiostor/csio_mb.c:1181:57: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_mb.c:1181:57:    expected restricted __be64 [usertype] rx_mcast_frames
drivers/scsi/csiostor/csio_mb.c:1181:57:    got unsigned long long
drivers/scsi/csiostor/csio_mb.c:1183:57: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_mb.c:1183:57:    expected restricted __be64 [usertype] rx_ucast_bytes
drivers/scsi/csiostor/csio_mb.c:1183:57:    got unsigned long long
drivers/scsi/csiostor/csio_mb.c:1185:57: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_mb.c:1185:57:    expected restricted __be64 [usertype] rx_ucast_frames
drivers/scsi/csiostor/csio_mb.c:1185:57:    got unsigned long long
drivers/scsi/csiostor/csio_mb.c:1187:57: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_mb.c:1187:57:    expected restricted __be64 [usertype] rx_err_frames
drivers/scsi/csiostor/csio_mb.c:1187:57:    got unsigned long long
+ drivers/scsi/csiostor/csio_mb.c:1417:29: sparse: restricted __be64 degrades to integer
--
+ drivers/scsi/csiostor/csio_rnode.c:341:41: sparse: cast to restricted __be32
+ drivers/scsi/csiostor/csio_rnode.c:341:41: sparse: cast to restricted __be32
+ drivers/scsi/csiostor/csio_rnode.c:341:41: sparse: cast to restricted __be32
+ drivers/scsi/csiostor/csio_rnode.c:341:41: sparse: cast to restricted __be32
+ drivers/scsi/csiostor/csio_rnode.c:341:41: sparse: cast to restricted __be32
+ drivers/scsi/csiostor/csio_rnode.c:341:41: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:450:23: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:450:23: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:450:23: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:450:23: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:450:23: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:450:23: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:463:23: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:463:23: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:463:23: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:463:23: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:463:23: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:463:23: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:509:25: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:509:25: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:509:25: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:509:25: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:509:25: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:509:25: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:518:25: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:518:25: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:518:25: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:518:25: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:518:25: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:518:25: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:529:25: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:529:25: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:529:25: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:529:25: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:529:25: sparse: cast to restricted __be32
drivers/scsi/csiostor/csio_rnode.c:529:25: sparse: cast to restricted __be32
+ drivers/scsi/csiostor/csio_rnode.c:532:37: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_rnode.c:532:37:    expected restricted __be16 [usertype] sp_bb_data
drivers/scsi/csiostor/csio_rnode.c:532:37:    got int
--
+ drivers/scsi/csiostor/csio_scsi.c:451:20: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:451:20:    expected restricted __be64 [usertype] cookie
drivers/scsi/csiostor/csio_scsi.c:451:20:    got unsigned long [unsigned] [usertype] <noident>
+ drivers/scsi/csiostor/csio_scsi.c:452:21: sparse: cast from restricted __be16
drivers/scsi/csiostor/csio_scsi.c:452:18: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:452:18:    expected restricted __be16 [usertype] iqid
drivers/scsi/csiostor/csio_scsi.c:452:18:    got unsigned short [unsigned] [usertype] <noident>
+ drivers/scsi/csiostor/csio_scsi.c:451:20: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:451:20:    expected restricted __be64 [usertype] cookie
drivers/scsi/csiostor/csio_scsi.c:451:20:    got unsigned long [unsigned] [usertype] <noident>
+ drivers/scsi/csiostor/csio_scsi.c:452:21: sparse: cast from restricted __be16
drivers/scsi/csiostor/csio_scsi.c:452:18: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:452:18:    expected restricted __be16 [usertype] iqid
drivers/scsi/csiostor/csio_scsi.c:452:18:    got unsigned short [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:398:20: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:398:20:    expected restricted __be64 [usertype] cookie
drivers/scsi/csiostor/csio_scsi.c:398:20:    got unsigned long [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:399:21: sparse: cast from restricted __be16
drivers/scsi/csiostor/csio_scsi.c:399:18: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:399:18:    expected restricted __be16 [usertype] iqid
drivers/scsi/csiostor/csio_scsi.c:399:18:    got unsigned short [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:398:20: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:398:20:    expected restricted __be64 [usertype] cookie
drivers/scsi/csiostor/csio_scsi.c:398:20:    got unsigned long [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:399:21: sparse: cast from restricted __be16
drivers/scsi/csiostor/csio_scsi.c:399:18: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:399:18:    expected restricted __be16 [usertype] iqid
drivers/scsi/csiostor/csio_scsi.c:399:18:    got unsigned short [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:398:20: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:398:20:    expected restricted __be64 [usertype] cookie
drivers/scsi/csiostor/csio_scsi.c:398:20:    got unsigned long [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:399:21: sparse: cast from restricted __be16
drivers/scsi/csiostor/csio_scsi.c:399:18: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:399:18:    expected restricted __be16 [usertype] iqid
drivers/scsi/csiostor/csio_scsi.c:399:18:    got unsigned short [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:398:20: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:398:20:    expected restricted __be64 [usertype] cookie
drivers/scsi/csiostor/csio_scsi.c:398:20:    got unsigned long [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:399:21: sparse: cast from restricted __be16
drivers/scsi/csiostor/csio_scsi.c:399:18: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:399:18:    expected restricted __be16 [usertype] iqid
drivers/scsi/csiostor/csio_scsi.c:399:18:    got unsigned short [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:239:20: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:239:20:    expected restricted __be64 [usertype] cookie
drivers/scsi/csiostor/csio_scsi.c:239:20:    got unsigned long [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:240:21: sparse: cast from restricted __be16
drivers/scsi/csiostor/csio_scsi.c:240:18: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:240:18:    expected restricted __be16 [usertype] iqid
drivers/scsi/csiostor/csio_scsi.c:240:18:    got unsigned short [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:239:20: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:239:20:    expected restricted __be64 [usertype] cookie
drivers/scsi/csiostor/csio_scsi.c:239:20:    got unsigned long [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:240:21: sparse: cast from restricted __be16
drivers/scsi/csiostor/csio_scsi.c:240:18: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:240:18:    expected restricted __be16 [usertype] iqid
drivers/scsi/csiostor/csio_scsi.c:240:18:    got unsigned short [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:239:20: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:239:20:    expected restricted __be64 [usertype] cookie
drivers/scsi/csiostor/csio_scsi.c:239:20:    got unsigned long [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:240:21: sparse: cast from restricted __be16
drivers/scsi/csiostor/csio_scsi.c:240:18: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:240:18:    expected restricted __be16 [usertype] iqid
drivers/scsi/csiostor/csio_scsi.c:240:18:    got unsigned short [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:239:20: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:239:20:    expected restricted __be64 [usertype] cookie
drivers/scsi/csiostor/csio_scsi.c:239:20:    got unsigned long [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:240:21: sparse: cast from restricted __be16
drivers/scsi/csiostor/csio_scsi.c:240:18: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:240:18:    expected restricted __be16 [usertype] iqid
drivers/scsi/csiostor/csio_scsi.c:240:18:    got unsigned short [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:682:20: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:682:20:    expected restricted __be64 [usertype] cookie
drivers/scsi/csiostor/csio_scsi.c:682:20:    got unsigned long [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:683:21: sparse: cast from restricted __be16
drivers/scsi/csiostor/csio_scsi.c:683:18: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:683:18:    expected restricted __be16 [usertype] iqid
drivers/scsi/csiostor/csio_scsi.c:683:18:    got unsigned short [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:694:22: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:694:22:    expected restricted __be64 [usertype] t_cookie
drivers/scsi/csiostor/csio_scsi.c:694:22:    got unsigned long [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:682:20: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:682:20:    expected restricted __be64 [usertype] cookie
drivers/scsi/csiostor/csio_scsi.c:682:20:    got unsigned long [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:683:21: sparse: cast from restricted __be16
drivers/scsi/csiostor/csio_scsi.c:683:18: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:683:18:    expected restricted __be16 [usertype] iqid
drivers/scsi/csiostor/csio_scsi.c:683:18:    got unsigned short [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:694:22: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:694:22:    expected restricted __be64 [usertype] t_cookie
drivers/scsi/csiostor/csio_scsi.c:694:22:    got unsigned long [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:682:20: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:682:20:    expected restricted __be64 [usertype] cookie
drivers/scsi/csiostor/csio_scsi.c:682:20:    got unsigned long [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:683:21: sparse: cast from restricted __be16
drivers/scsi/csiostor/csio_scsi.c:683:18: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:683:18:    expected restricted __be16 [usertype] iqid
drivers/scsi/csiostor/csio_scsi.c:683:18:    got unsigned short [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:694:22: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:694:22:    expected restricted __be64 [usertype] t_cookie
drivers/scsi/csiostor/csio_scsi.c:694:22:    got unsigned long [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:682:20: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:682:20:    expected restricted __be64 [usertype] cookie
drivers/scsi/csiostor/csio_scsi.c:682:20:    got unsigned long [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:683:21: sparse: cast from restricted __be16
drivers/scsi/csiostor/csio_scsi.c:683:18: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:683:18:    expected restricted __be16 [usertype] iqid
drivers/scsi/csiostor/csio_scsi.c:683:18:    got unsigned short [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:694:22: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:694:22:    expected restricted __be64 [usertype] t_cookie
drivers/scsi/csiostor/csio_scsi.c:694:22:    got unsigned long [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:682:20: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:682:20:    expected restricted __be64 [usertype] cookie
drivers/scsi/csiostor/csio_scsi.c:682:20:    got unsigned long [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:683:21: sparse: cast from restricted __be16
drivers/scsi/csiostor/csio_scsi.c:683:18: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:683:18:    expected restricted __be16 [usertype] iqid
drivers/scsi/csiostor/csio_scsi.c:683:18:    got unsigned short [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:694:22: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:694:22:    expected restricted __be64 [usertype] t_cookie
drivers/scsi/csiostor/csio_scsi.c:694:22:    got unsigned long [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:682:20: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:682:20:    expected restricted __be64 [usertype] cookie
drivers/scsi/csiostor/csio_scsi.c:682:20:    got unsigned long [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:683:21: sparse: cast from restricted __be16
drivers/scsi/csiostor/csio_scsi.c:683:18: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:683:18:    expected restricted __be16 [usertype] iqid
drivers/scsi/csiostor/csio_scsi.c:683:18:    got unsigned short [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:694:22: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:694:22:    expected restricted __be64 [usertype] t_cookie
drivers/scsi/csiostor/csio_scsi.c:694:22:    got unsigned long [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:682:20: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:682:20:    expected restricted __be64 [usertype] cookie
drivers/scsi/csiostor/csio_scsi.c:682:20:    got unsigned long [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:683:21: sparse: cast from restricted __be16
drivers/scsi/csiostor/csio_scsi.c:683:18: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:683:18:    expected restricted __be16 [usertype] iqid
drivers/scsi/csiostor/csio_scsi.c:683:18:    got unsigned short [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:694:22: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:694:22:    expected restricted __be64 [usertype] t_cookie
drivers/scsi/csiostor/csio_scsi.c:694:22:    got unsigned long [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:682:20: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:682:20:    expected restricted __be64 [usertype] cookie
drivers/scsi/csiostor/csio_scsi.c:682:20:    got unsigned long [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:683:21: sparse: cast from restricted __be16
drivers/scsi/csiostor/csio_scsi.c:683:18: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:683:18:    expected restricted __be16 [usertype] iqid
drivers/scsi/csiostor/csio_scsi.c:683:18:    got unsigned short [unsigned] [usertype] <noident>
drivers/scsi/csiostor/csio_scsi.c:694:22: sparse: incorrect type in assignment (different base types)
drivers/scsi/csiostor/csio_scsi.c:694:22:    expected restricted __be64 [usertype] t_cookie
drivers/scsi/csiostor/csio_scsi.c:694:22:    got unsigned long [unsigned] [usertype] <noident>
+ drivers/scsi/csiostor/csio_scsi.c:1152:48: sparse: cast from restricted __be64
drivers/scsi/csiostor/csio_scsi.c:1162:48: sparse: cast from restricted __be64
+ drivers/scsi/csiostor/csio_scsi.c:1192:17: sparse: context imbalance in 'csio_scsi_cleanup_io_q' - unexpected unlock

vim +92 drivers/scsi/csiostor/csio_attr.c

0779fa13 Naresh Kumar Inna 2012-11-15   86  	rport = rn->rport;
0779fa13 Naresh Kumar Inna 2012-11-15   87  	spin_lock_irq(shost->host_lock);
0779fa13 Naresh Kumar Inna 2012-11-15   88  	*((struct csio_rnode **)rport->dd_data) = rn;
0779fa13 Naresh Kumar Inna 2012-11-15   89  	spin_unlock_irq(shost->host_lock);
0779fa13 Naresh Kumar Inna 2012-11-15   90  
0779fa13 Naresh Kumar Inna 2012-11-15   91  	sp = &rn->rn_sparm;
0779fa13 Naresh Kumar Inna 2012-11-15  @92  	rport->maxframe_size		= sp->csp.sp_bb_data;
0779fa13 Naresh Kumar Inna 2012-11-15   93  	if (ntohs(sp->clsp[2].cp_class) & FC_CPC_VALID)
0779fa13 Naresh Kumar Inna 2012-11-15   94  		rport->supported_classes = FC_COS_CLASS3;
0779fa13 Naresh Kumar Inna 2012-11-15   95  	else
0779fa13 Naresh Kumar Inna 2012-11-15   96  		rport->supported_classes = FC_COS_UNSPECIFIED;
0779fa13 Naresh Kumar Inna 2012-11-15   97  update_role:
0779fa13 Naresh Kumar Inna 2012-11-15   98  	if (rn->role & CSIO_RNFR_INITIATOR)
0779fa13 Naresh Kumar Inna 2012-11-15   99  		ids.roles |= FC_RPORT_ROLE_FCP_INITIATOR;
0779fa13 Naresh Kumar Inna 2012-11-15  100  	if (rn->role & CSIO_RNFR_TARGET)
0779fa13 Naresh Kumar Inna 2012-11-15  101  		ids.roles |= FC_RPORT_ROLE_FCP_TARGET;
0779fa13 Naresh Kumar Inna 2012-11-15  102  
0779fa13 Naresh Kumar Inna 2012-11-15  103  	if (ids.roles != FC_RPORT_ROLE_UNKNOWN)
0779fa13 Naresh Kumar Inna 2012-11-15  104  		fc_remote_port_rolechg(rport, ids.roles);
0779fa13 Naresh Kumar Inna 2012-11-15  105  
0779fa13 Naresh Kumar Inna 2012-11-15  106  	rn->scsi_id = rport->scsi_target_id;
0779fa13 Naresh Kumar Inna 2012-11-15  107  
0779fa13 Naresh Kumar Inna 2012-11-15  108  	csio_ln_dbg(ln, "Remote port x%x role 0x%x registered\n",
0779fa13 Naresh Kumar Inna 2012-11-15  109  		rn->nport_id, ids.roles);
0779fa13 Naresh Kumar Inna 2012-11-15  110  }
0779fa13 Naresh Kumar Inna 2012-11-15  111  
0779fa13 Naresh Kumar Inna 2012-11-15  112  /*
0779fa13 Naresh Kumar Inna 2012-11-15  113   * csio_unreg_rnode - Unregister a remote port with FC transport.
0779fa13 Naresh Kumar Inna 2012-11-15  114   * @rn: Rnode representing remote port.
0779fa13 Naresh Kumar Inna 2012-11-15  115   *
0779fa13 Naresh Kumar Inna 2012-11-15  116   * Call fc_remote_port_delete() to unregister this remote port with FC
0779fa13 Naresh Kumar Inna 2012-11-15  117   * transport.
0779fa13 Naresh Kumar Inna 2012-11-15  118   *
0779fa13 Naresh Kumar Inna 2012-11-15  119   */
0779fa13 Naresh Kumar Inna 2012-11-15  120  void
0779fa13 Naresh Kumar Inna 2012-11-15  121  csio_unreg_rnode(struct csio_rnode *rn)
0779fa13 Naresh Kumar Inna 2012-11-15  122  {
0779fa13 Naresh Kumar Inna 2012-11-15  123  	struct csio_lnode *ln = csio_rnode_to_lnode(rn);
0779fa13 Naresh Kumar Inna 2012-11-15  124  	struct fc_rport *rport = rn->rport;
0779fa13 Naresh Kumar Inna 2012-11-15  125  
0779fa13 Naresh Kumar Inna 2012-11-15  126  	rn->role &= ~(CSIO_RNFR_INITIATOR | CSIO_RNFR_TARGET);
0779fa13 Naresh Kumar Inna 2012-11-15  127  	fc_remote_port_delete(rport);
0779fa13 Naresh Kumar Inna 2012-11-15  128  	ln->num_reg_rnodes--;
0779fa13 Naresh Kumar Inna 2012-11-15  129  
0779fa13 Naresh Kumar Inna 2012-11-15  130  	csio_ln_dbg(ln, "Remote port x%x un-registered\n", rn->nport_id);
0779fa13 Naresh Kumar Inna 2012-11-15  131  }
0779fa13 Naresh Kumar Inna 2012-11-15  132  
0779fa13 Naresh Kumar Inna 2012-11-15  133  /*
0779fa13 Naresh Kumar Inna 2012-11-15  134   * csio_lnode_async_event - Async events from local port.
0779fa13 Naresh Kumar Inna 2012-11-15  135   * @ln: lnode representing local port.
0779fa13 Naresh Kumar Inna 2012-11-15  136   *
0779fa13 Naresh Kumar Inna 2012-11-15  137   * Async events from local node that FC transport/SCSI ML
0779fa13 Naresh Kumar Inna 2012-11-15  138   * should be made aware of (Eg: RSCN).
0779fa13 Naresh Kumar Inna 2012-11-15  139   */
0779fa13 Naresh Kumar Inna 2012-11-15  140  void
0779fa13 Naresh Kumar Inna 2012-11-15  141  csio_lnode_async_event(struct csio_lnode *ln, enum csio_ln_fc_evt fc_evt)
0779fa13 Naresh Kumar Inna 2012-11-15  142  {
0779fa13 Naresh Kumar Inna 2012-11-15  143  	switch (fc_evt) {
0779fa13 Naresh Kumar Inna 2012-11-15  144  	case CSIO_LN_FC_RSCN:
0779fa13 Naresh Kumar Inna 2012-11-15  145  		/* Get payload of rscn from ln */
0779fa13 Naresh Kumar Inna 2012-11-15  146  		/* For each RSCN entry */
0779fa13 Naresh Kumar Inna 2012-11-15  147  			/*
0779fa13 Naresh Kumar Inna 2012-11-15  148  			 * fc_host_post_event(shost,
0779fa13 Naresh Kumar Inna 2012-11-15  149  			 *		      fc_get_event_number(),
0779fa13 Naresh Kumar Inna 2012-11-15  150  			 *		      FCH_EVT_RSCN,
0779fa13 Naresh Kumar Inna 2012-11-15  151  			 *		      rscn_entry);
0779fa13 Naresh Kumar Inna 2012-11-15  152  			 */
0779fa13 Naresh Kumar Inna 2012-11-15  153  		break;
0779fa13 Naresh Kumar Inna 2012-11-15  154  	case CSIO_LN_FC_LINKUP:
0779fa13 Naresh Kumar Inna 2012-11-15  155  		/* send fc_host_post_event */
0779fa13 Naresh Kumar Inna 2012-11-15  156  		/* set vport state */
0779fa13 Naresh Kumar Inna 2012-11-15  157  		if (csio_is_npiv_ln(ln))
0779fa13 Naresh Kumar Inna 2012-11-15  158  			csio_vport_set_state(ln);
0779fa13 Naresh Kumar Inna 2012-11-15  159  
0779fa13 Naresh Kumar Inna 2012-11-15  160  		break;
0779fa13 Naresh Kumar Inna 2012-11-15  161  	case CSIO_LN_FC_LINKDOWN:
0779fa13 Naresh Kumar Inna 2012-11-15  162  		/* send fc_host_post_event */
0779fa13 Naresh Kumar Inna 2012-11-15  163  		/* set vport state */
0779fa13 Naresh Kumar Inna 2012-11-15  164  		if (csio_is_npiv_ln(ln))
0779fa13 Naresh Kumar Inna 2012-11-15  165  			csio_vport_set_state(ln);
0779fa13 Naresh Kumar Inna 2012-11-15  166  
0779fa13 Naresh Kumar Inna 2012-11-15  167  		break;
0779fa13 Naresh Kumar Inna 2012-11-15  168  	case CSIO_LN_FC_ATTRIB_UPDATE:
0779fa13 Naresh Kumar Inna 2012-11-15  169  		csio_fchost_attr_init(ln);
0779fa13 Naresh Kumar Inna 2012-11-15  170  		break;
0779fa13 Naresh Kumar Inna 2012-11-15  171  	default:
0779fa13 Naresh Kumar Inna 2012-11-15  172  		break;
0779fa13 Naresh Kumar Inna 2012-11-15  173  	}
0779fa13 Naresh Kumar Inna 2012-11-15  174  }
0779fa13 Naresh Kumar Inna 2012-11-15  175  
0779fa13 Naresh Kumar Inna 2012-11-15  176  /*
0779fa13 Naresh Kumar Inna 2012-11-15  177   * csio_fchost_attr_init - Initialize FC transport attributes
0779fa13 Naresh Kumar Inna 2012-11-15  178   * @ln: Lnode.
0779fa13 Naresh Kumar Inna 2012-11-15  179   *
0779fa13 Naresh Kumar Inna 2012-11-15  180   */
0779fa13 Naresh Kumar Inna 2012-11-15  181  void
0779fa13 Naresh Kumar Inna 2012-11-15  182  csio_fchost_attr_init(struct csio_lnode *ln)
0779fa13 Naresh Kumar Inna 2012-11-15  183  {
0779fa13 Naresh Kumar Inna 2012-11-15  184  	struct Scsi_Host  *shost = csio_ln_to_shost(ln);
0779fa13 Naresh Kumar Inna 2012-11-15  185  
0779fa13 Naresh Kumar Inna 2012-11-15  186  	fc_host_node_name(shost) = wwn_to_u64(csio_ln_wwnn(ln));
0779fa13 Naresh Kumar Inna 2012-11-15  187  	fc_host_port_name(shost) = wwn_to_u64(csio_ln_wwpn(ln));
0779fa13 Naresh Kumar Inna 2012-11-15  188  
0779fa13 Naresh Kumar Inna 2012-11-15  189  	fc_host_supported_classes(shost) = FC_COS_CLASS3;
0779fa13 Naresh Kumar Inna 2012-11-15  190  	fc_host_max_npiv_vports(shost) =
0779fa13 Naresh Kumar Inna 2012-11-15  191  			(csio_lnode_to_hw(ln))->fres_info.max_vnps;
0779fa13 Naresh Kumar Inna 2012-11-15  192  	fc_host_supported_speeds(shost) = FC_PORTSPEED_10GBIT |
0779fa13 Naresh Kumar Inna 2012-11-15  193  		FC_PORTSPEED_1GBIT;
0779fa13 Naresh Kumar Inna 2012-11-15  194  
0779fa13 Naresh Kumar Inna 2012-11-15 @195  	fc_host_maxframe_size(shost) = ln->ln_sparm.csp.sp_bb_data;
0779fa13 Naresh Kumar Inna 2012-11-15  196  	memset(fc_host_supported_fc4s(shost), 0,
0779fa13 Naresh Kumar Inna 2012-11-15  197  		sizeof(fc_host_supported_fc4s(shost)));
0779fa13 Naresh Kumar Inna 2012-11-15  198  	fc_host_supported_fc4s(shost)[7] = 1;

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
