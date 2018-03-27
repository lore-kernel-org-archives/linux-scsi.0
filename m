From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH net-next] qed*: Utilize FW 8.33.11.0
Date: Tue, 27 Mar 2018 12:48:14 +0800
Message-ID: <201803271123.xOuWWgrH%fengguang.wu@intel.com>
References: <1522083732-26560-1-git-send-email-Michal.Kalderon@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1522083732-26560-1-git-send-email-Michal.Kalderon@cavium.com>
Sender: netdev-owner@vger.kernel.org
To: Michal Kalderon <Michal.Kalderon@cavium.com>
Cc: kbuild-all@01.org, michal.kalderon@cavium.com, davem@davemloft.net, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, Tomer Tayar <Tomer.Tayar@cavium.com>, Manish Rangankar <Manish.Rangankar@cavium.com>, Ariel Elior <Ariel.Elior@cavium.com>
List-Id: linux-scsi@vger.kernel.org

Hi Michal,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Michal-Kalderon/qed-Utilize-FW-8-33-11-0/20180327-070630
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/net/ethernet/qlogic/qed/qed_cxt.c:972:41: sparse: incorrect type in assignment (different base types) @@    expected unsigned long long [unsigned] [usertype] next @@    got g long [unsigned] [usertype] next @@
   drivers/net/ethernet/qlogic/qed/qed_cxt.c:972:41:    expected unsigned long long [unsigned] [usertype] next
   drivers/net/ethernet/qlogic/qed/qed_cxt.c:972:41:    got restricted __be64 [usertype] <noident>
   drivers/net/ethernet/qlogic/qed/qed_cxt.c:979:33: sparse: incorrect type in assignment (different base types) @@    expected unsigned long long [unsigned] [usertype] next @@    got g long [unsigned] [usertype] next @@
   drivers/net/ethernet/qlogic/qed/qed_cxt.c:979:33:    expected unsigned long long [unsigned] [usertype] next
   drivers/net/ethernet/qlogic/qed/qed_cxt.c:979:33:    got restricted __be64 [usertype] <noident>
>> drivers/net/ethernet/qlogic/qed/qed_cxt.c:1534:6: sparse: symbol 'qed_cm_init_pf' was not declared. Should it be static?
>> drivers/net/ethernet/qlogic/qed/qed_cxt.c:2331:25: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_cxt.c:2331:25:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_cxt.c:2331:25:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_cxt.c:2331:25: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_cxt.c:2331:25:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_cxt.c:2331:25:    right side has type unsigned long long
--
>> drivers/net/ethernet/qlogic/qed/qed_dev.c:233:4: sparse: symbol 'qed_init_qm_get_num_tcs' was not declared. Should it be static?
>> drivers/net/ethernet/qlogic/qed/qed_dev.c:238:5: sparse: symbol 'qed_init_qm_get_num_vfs' was not declared. Should it be static?
>> drivers/net/ethernet/qlogic/qed/qed_dev.c:246:5: sparse: symbol 'qed_init_qm_get_num_pf_rls' was not declared. Should it be static?
>> drivers/net/ethernet/qlogic/qed/qed_dev.c:264:5: sparse: symbol 'qed_init_qm_get_num_vports' was not declared. Should it be static?
>> drivers/net/ethernet/qlogic/qed/qed_dev.c:276:5: sparse: symbol 'qed_init_qm_get_num_pqs' was not declared. Should it be static?
>> drivers/net/ethernet/qlogic/qed/qed_dev.c:510:5: sparse: symbol 'qed_get_cm_pq_idx_rl' was not declared. Should it be static?
--
>> drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17:    right side has type unsigned long long
>> drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17:    right side has type int
>> drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17:    right side has type unsigned long long
>> drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17:    right side has type int
>> drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17:    right side has type unsigned long long
>> drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:503:17:    right side has type unsigned long long
>> drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1228:6: sparse: symbol 'qed_set_gft_event_id_cm_hdr' was not declared. Should it be static?
>> drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1396:23: sparse: cast to restricted __be32
>> drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1396:23: sparse: cast to restricted __be32
>> drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1396:23: sparse: cast to restricted __be32
>> drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1396:23: sparse: cast to restricted __be32
>> drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1396:23: sparse: cast to restricted __be32
>> drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1396:23: sparse: cast to restricted __be32
--
>> drivers/net/ethernet/qlogic/qed/qed_init_ops.c:238:33: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:239:20: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:252:16: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:309:20: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:325:24: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:329:24: sparse: cast to restricted __le32
>> drivers/net/ethernet/qlogic/qed/qed_init_ops.c:341:29: sparse: cast to restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:342:29: sparse: cast to restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:374:16: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:400:16: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:409:17: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:409:17: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:465:22: sparse: cast to restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:470:24: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:478:20: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:479:23: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:507:28: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:530:25: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:530:25: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:530:25: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:530:25: sparse: cast to restricted __le32
--
>> drivers/net/ethernet/qlogic/qed/qed_int.c:1039:33: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] sb_id_and_flags @@    got  [usertype] sb_id_and_flags @@
   drivers/net/ethernet/qlogic/qed/qed_int.c:1039:33:    expected restricted __le32 [usertype] sb_id_and_flags
   drivers/net/ethernet/qlogic/qed/qed_int.c:1039:33:    got unsigned int
>> drivers/net/ethernet/qlogic/qed/qed_int.c:1046:9: sparse: cast from restricted __le32
   include/linux/qed/qed_if.h:969:33: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] sb_id_and_flags @@    got  [usertype] sb_id_and_flags @@
   include/linux/qed/qed_if.h:969:33:    expected restricted __le32 [usertype] sb_id_and_flags
   include/linux/qed/qed_if.h:969:33:    got unsigned int
   include/linux/qed/qed_if.h:976:9: sparse: cast from restricted __le32
   include/linux/qed/qed_if.h:969:33: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] sb_id_and_flags @@    got  [usertype] sb_id_and_flags @@
   include/linux/qed/qed_if.h:969:33:    expected restricted __le32 [usertype] sb_id_and_flags
   include/linux/qed/qed_if.h:969:33:    got unsigned int
   include/linux/qed/qed_if.h:976:9: sparse: cast from restricted __le32
   include/linux/qed/qed_if.h:969:33: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] sb_id_and_flags @@    got  [usertype] sb_id_and_flags @@
   include/linux/qed/qed_if.h:969:33:    expected restricted __le32 [usertype] sb_id_and_flags
   include/linux/qed/qed_if.h:969:33:    got unsigned int
   include/linux/qed/qed_if.h:976:9: sparse: cast from restricted __le32
   include/linux/qed/qed_if.h:969:33: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] sb_id_and_flags @@    got  [usertype] sb_id_and_flags @@
   include/linux/qed/qed_if.h:969:33:    expected restricted __le32 [usertype] sb_id_and_flags
   include/linux/qed/qed_if.h:969:33:    got unsigned int
   include/linux/qed/qed_if.h:976:9: sparse: cast from restricted __le32
>> drivers/net/ethernet/qlogic/qed/qed_int.c:1266:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_int.c:1266:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_int.c:1266:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_int.c:1266:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_int.c:1266:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_int.c:1266:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_int.c:1267:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_int.c:1267:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_int.c:1267:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_int.c:1267:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_int.c:1267:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_int.c:1267:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_int.c:1268:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_int.c:1268:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_int.c:1268:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_int.c:1268:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_int.c:1268:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_int.c:1268:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_int.c:1269:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_int.c:1269:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_int.c:1269:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_int.c:1269:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_int.c:1269:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_int.c:1269:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_int.c:1270:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_int.c:1270:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_int.c:1270:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_int.c:1270:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_int.c:1270:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_int.c:1270:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_int.c:1289:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_int.c:1289:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_int.c:1289:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_int.c:1289:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_int.c:1289:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_int.c:1289:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_int.c:1297:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_int.c:1297:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_int.c:1297:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_int.c:1297:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_int.c:1297:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_int.c:1297:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_int.c:1299:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_int.c:1299:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_int.c:1299:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_int.c:1299:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_int.c:1299:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_int.c:1299:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_int.c:1300:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_int.c:1300:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_int.c:1300:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_int.c:1300:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_int.c:1300:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_int.c:1300:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_int.c:1319:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_int.c:1319:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_int.c:1319:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_int.c:1319:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_int.c:1319:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_int.c:1319:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_int.c:1321:17: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_int.c:1321:17:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_int.c:1321:17:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_int.c:1321:17: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_int.c:1321:17:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_int.c:1321:17:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_int.c:1323:17: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_int.c:1323:17:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_int.c:1323:17:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_int.c:1323:17: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_int.c:1323:17:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_int.c:1323:17:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_int.c:2220:17: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_int.c:2220:17:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_int.c:2220:17:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_int.c:2220:17: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_int.c:2220:17:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_int.c:2220:17:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_int.c:2222:17: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_int.c:2222:17:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_int.c:2222:17:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_int.c:2222:17: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_int.c:2222:17:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_int.c:2222:17:    right side has type unsigned long long
--
>> drivers/net/ethernet/qlogic/qed/qed_mcp.c:2691:1: sparse: symbol '__qed_mcp_resc_lock' was not declared. Should it be static?
>> drivers/net/ethernet/qlogic/qed/qed_mcp.c:464:9: sparse: context imbalance in '_qed_mcp_cmd_and_union' - unexpected unlock
--
>> drivers/net/ethernet/qlogic/qed/qed_sp_commands.c:163:32: sparse: mixing different enum types
   drivers/net/ethernet/qlogic/qed/qed_sp_commands.c:163:32:     int enum tunnel_clss  versus
   drivers/net/ethernet/qlogic/qed/qed_sp_commands.c:163:32:     int enum qed_tunn_clss
   drivers/net/ethernet/qlogic/qed/qed_sp_commands.c:165:33: sparse: mixing different enum types
   drivers/net/ethernet/qlogic/qed/qed_sp_commands.c:165:33:     int enum tunnel_clss  versus
   drivers/net/ethernet/qlogic/qed/qed_sp_commands.c:165:33:     int enum qed_tunn_clss
   drivers/net/ethernet/qlogic/qed/qed_sp_commands.c:167:33: sparse: mixing different enum types
   drivers/net/ethernet/qlogic/qed/qed_sp_commands.c:167:33:     int enum tunnel_clss  versus
   drivers/net/ethernet/qlogic/qed/qed_sp_commands.c:167:33:     int enum qed_tunn_clss
   drivers/net/ethernet/qlogic/qed/qed_sp_commands.c:169:36: sparse: mixing different enum types
   drivers/net/ethernet/qlogic/qed/qed_sp_commands.c:169:36:     int enum tunnel_clss  versus
   drivers/net/ethernet/qlogic/qed/qed_sp_commands.c:169:36:     int enum qed_tunn_clss
   drivers/net/ethernet/qlogic/qed/qed_sp_commands.c:171:36: sparse: mixing different enum types
   drivers/net/ethernet/qlogic/qed/qed_sp_commands.c:171:36:     int enum tunnel_clss  versus
   drivers/net/ethernet/qlogic/qed/qed_sp_commands.c:171:36:     int enum qed_tunn_clss
--
>> drivers/net/ethernet/qlogic/qed/qed_spq.c:310:55: sparse: incorrect type in argument 3 (different base types) @@    expected unsigned short [unsigned] [usertype] echo @@    got  short [unsigned] [usertype] echo @@
   drivers/net/ethernet/qlogic/qed/qed_spq.c:310:55:    expected unsigned short [unsigned] [usertype] echo
   drivers/net/ethernet/qlogic/qed/qed_spq.c:310:55:    got restricted __le16 [usertype] echo
--
>> drivers/net/ethernet/qlogic/qed/qed_l2.c:414:50: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] tpa_max_size @@    got unsignedrestricted __le16 [usertype] tpa_max_size @@
   drivers/net/ethernet/qlogic/qed/qed_l2.c:414:50:    expected restricted __le16 [usertype] tpa_max_size
   drivers/net/ethernet/qlogic/qed/qed_l2.c:414:50:    got unsigned short [unsigned] [usertype] <noident>
>> drivers/net/ethernet/qlogic/qed/qed_l2.c:415:58: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] tpa_min_size_to_cont @@    got e] tpa_min_size_to_cont @@
   drivers/net/ethernet/qlogic/qed/qed_l2.c:415:58:    expected restricted __le16 [usertype] tpa_min_size_to_cont
   drivers/net/ethernet/qlogic/qed/qed_l2.c:415:58:    got int
>> drivers/net/ethernet/qlogic/qed/qed_l2.c:416:59: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] tpa_min_size_to_start @@    got e] tpa_min_size_to_start @@
   drivers/net/ethernet/qlogic/qed/qed_l2.c:416:59:    expected restricted __le16 [usertype] tpa_min_size_to_start
   drivers/net/ethernet/qlogic/qed/qed_l2.c:416:59:    got int
   drivers/net/ethernet/qlogic/qed/qed_l2.c:647:29: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] tpa_max_size @@    got unsignedrestricted __le16 [usertype] tpa_max_size @@
   drivers/net/ethernet/qlogic/qed/qed_l2.c:647:29:    expected restricted __le16 [usertype] tpa_max_size
   drivers/net/ethernet/qlogic/qed/qed_l2.c:647:29:    got unsigned short [unsigned] [usertype] tpa_max_size
>> drivers/net/ethernet/qlogic/qed/qed_l2.c:648:38: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] tpa_min_size_to_start @@    got unsignedrestricted __le16 [usertype] tpa_min_size_to_start @@
   drivers/net/ethernet/qlogic/qed/qed_l2.c:648:38:    expected restricted __le16 [usertype] tpa_min_size_to_start
   drivers/net/ethernet/qlogic/qed/qed_l2.c:648:38:    got unsigned short [unsigned] [usertype] tpa_min_size_to_start
>> drivers/net/ethernet/qlogic/qed/qed_l2.c:649:37: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] tpa_min_size_to_cont @@    got unsignedrestricted __le16 [usertype] tpa_min_size_to_cont @@
   drivers/net/ethernet/qlogic/qed/qed_l2.c:649:37:    expected restricted __le16 [usertype] tpa_min_size_to_cont
   drivers/net/ethernet/qlogic/qed/qed_l2.c:649:37:    got unsigned short [unsigned] [usertype] tpa_min_size_to_cont
>> drivers/net/ethernet/qlogic/qed/qed_l2.c:2090:21: sparse: restricted __le32 degrades to integer
   drivers/net/ethernet/qlogic/qed/qed_l2.c:2123:21: sparse: restricted __le32 degrades to integer
--
>> drivers/net/ethernet/qlogic/qed/qed_dcbx.c:586:21: sparse: cast to restricted __be32
>> drivers/net/ethernet/qlogic/qed/qed_dcbx.c:586:21: sparse: cast to restricted __be32
>> drivers/net/ethernet/qlogic/qed/qed_dcbx.c:586:21: sparse: cast to restricted __be32
>> drivers/net/ethernet/qlogic/qed/qed_dcbx.c:586:21: sparse: cast to restricted __be32
>> drivers/net/ethernet/qlogic/qed/qed_dcbx.c:586:21: sparse: cast to restricted __be32
>> drivers/net/ethernet/qlogic/qed/qed_dcbx.c:586:21: sparse: cast to restricted __be32
   drivers/net/ethernet/qlogic/qed/qed_dcbx.c:587:21: sparse: cast to restricted __be32
   drivers/net/ethernet/qlogic/qed/qed_dcbx.c:587:21: sparse: cast to restricted __be32
   drivers/net/ethernet/qlogic/qed/qed_dcbx.c:587:21: sparse: cast to restricted __be32
   drivers/net/ethernet/qlogic/qed/qed_dcbx.c:587:21: sparse: cast to restricted __be32
   drivers/net/ethernet/qlogic/qed/qed_dcbx.c:587:21: sparse: cast to restricted __be32
   drivers/net/ethernet/qlogic/qed/qed_dcbx.c:587:21: sparse: cast to restricted __be32
   drivers/net/ethernet/qlogic/qed/qed_dcbx.c:588:22: sparse: cast to restricted __be32
   drivers/net/ethernet/qlogic/qed/qed_dcbx.c:588:22: sparse: cast to restricted __be32
   drivers/net/ethernet/qlogic/qed/qed_dcbx.c:588:22: sparse: cast to restricted __be32
   drivers/net/ethernet/qlogic/qed/qed_dcbx.c:588:22: sparse: cast to restricted __be32
   drivers/net/ethernet/qlogic/qed/qed_dcbx.c:588:22: sparse: cast to restricted __be32
   drivers/net/ethernet/qlogic/qed/qed_dcbx.c:588:22: sparse: cast to restricted __be32
   drivers/net/ethernet/qlogic/qed/qed_dcbx.c:589:22: sparse: cast to restricted __be32
   drivers/net/ethernet/qlogic/qed/qed_dcbx.c:589:22: sparse: cast to restricted __be32
   drivers/net/ethernet/qlogic/qed/qed_dcbx.c:589:22: sparse: cast to restricted __be32
   drivers/net/ethernet/qlogic/qed/qed_dcbx.c:589:22: sparse: cast to restricted __be32
   drivers/net/ethernet/qlogic/qed/qed_dcbx.c:589:22: sparse: cast to restricted __be32
   drivers/net/ethernet/qlogic/qed/qed_dcbx.c:589:22: sparse: cast to restricted __be32
>> drivers/net/ethernet/qlogic/qed/qed_dcbx.c:863:6: sparse: symbol 'qed_dcbx_aen' was not declared. Should it be static?
>> drivers/net/ethernet/qlogic/qed/qed_dcbx.c:1083:37: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [unsigned] <noident> @@    got restrunsigned int [unsigned] <noident> @@
   drivers/net/ethernet/qlogic/qed/qed_dcbx.c:1083:37:    expected unsigned int [unsigned] <noident>
   drivers/net/ethernet/qlogic/qed/qed_dcbx.c:1083:37:    got restricted __be32 [usertype] <noident>
   drivers/net/ethernet/qlogic/qed/qed_dcbx.c:1084:38: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [unsigned] <noident> @@    got restrunsigned int [unsigned] <noident> @@
   drivers/net/ethernet/qlogic/qed/qed_dcbx.c:1084:38:    expected unsigned int [unsigned] <noident>
   drivers/net/ethernet/qlogic/qed/qed_dcbx.c:1084:38:    got restricted __be32 [usertype] <noident>
--
>> drivers/net/ethernet/qlogic/qed/qed_debug.c:1847:29: sparse: restricted __le32 degrades to integer
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1847:58: sparse: restricted __le32 degrades to integer
>> drivers/net/ethernet/qlogic/qed/qed_debug.c:1849:22: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [unsigned] [assigned] [usertype] addr @@    got igned int [unsigned] [assigned] [usertype] addr @@
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1849:22:    expected unsigned int [unsigned] [assigned] [usertype] addr
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1849:22:    got restricted __le32 [addressable] [usertype] grc_addr
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1851:33: sparse: restricted __le32 degrades to integer
>> drivers/net/ethernet/qlogic/qed/qed_debug.c:1996:65: sparse: incorrect type in argument 4 (different base types) @@    expected unsigned int [unsigned] [usertype] param_val @@    got restrictunsigned int [unsigned] [usertype] param_val @@
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1996:65:    expected unsigned int [unsigned] [usertype] param_val
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1996:65:    got restricted __le32 [addressable] [usertype] timestamp
--
>> drivers/net/ethernet/qlogic/qed/qed_sriov.c:574:35: sparse: incorrect type in argument 3 (incompatible argument 3 (different base types)) @@    expected int ( *[usertype] cb )( ... ) @@    got rtype] cb )( ... ) @@
   drivers/net/ethernet/qlogic/qed/qed_sriov.c:574:35:    expected int ( *[usertype] cb )( ... )
   drivers/net/ethernet/qlogic/qed/qed_sriov.c:574:35:    got int ( *<noident> )( ... )
>> drivers/net/ethernet/qlogic/qed/qed_sriov.c:675:6: sparse: symbol '_qed_iov_pf_sanity_check' was not declared. Should it be static?
>> drivers/net/ethernet/qlogic/qed/qed_sriov.c:690:6: sparse: symbol 'qed_iov_pf_sanity_check' was not declared. Should it be static?
>> drivers/net/ethernet/qlogic/qed/qed_sriov.c:3928:6: sparse: symbol 'qed_iov_pf_get_pending_events' was not declared. Should it be static?
>> drivers/net/ethernet/qlogic/qed/qed_sriov.c:3971:39: sparse: cast from restricted __le32
>> drivers/net/ethernet/qlogic/qed/qed_sriov.c:3971:70: sparse: restricted __le32 degrades to integer
--
>> drivers/net/ethernet/qlogic/qed/qed_vf.c:172:5: sparse: symbol '_qed_vf_pf_release' was not declared. Should it be static?
--
>> drivers/net/ethernet/qlogic/qed/qed_ll2.c:161:6: sparse: symbol 'qed_ll2b_complete_rx_packet' was not declared. Should it be static?
>> drivers/net/ethernet/qlogic/qed/qed_ll2.c:756:44: sparse: mixing different enum types
   drivers/net/ethernet/qlogic/qed/qed_ll2.c:756:44:     int enum core_tx_dest  versus
   drivers/net/ethernet/qlogic/qed/qed_ll2.c:756:44:     int enum qed_ll2_tx_dest
>> drivers/net/ethernet/qlogic/qed/qed_ll2.c:1661:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_ll2.c:1661:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_ll2.c:1661:9:    right side has type int
>> drivers/net/ethernet/qlogic/qed/qed_ll2.c:1661:9: sparse: cast from restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_ll2.c:1661:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_ll2.c:1661:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_ll2.c:1661:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_ll2.c:1663:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_ll2.c:1663:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_ll2.c:1663:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_ll2.c:1663:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_ll2.c:1663:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_ll2.c:1663:9:    right side has type unsigned long long
>> drivers/net/ethernet/qlogic/qed/qed_ll2.c:2126:20: sparse: symbol 'll2_cbs' was not declared. Should it be static?
--
>> drivers/net/ethernet/qlogic/qed/qed_roce.c:151:6: sparse: symbol 'qed_roce_free_cid_pair' was not declared. Should it be static?
>> drivers/net/ethernet/qlogic/qed/qed_roce.c:267:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:267:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_roce.c:267:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_roce.c:267:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:267:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_roce.c:267:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_roce.c:270:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:270:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_roce.c:270:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_roce.c:270:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:270:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_roce.c:270:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_roce.c:274:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:274:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_roce.c:274:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_roce.c:274:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:274:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_roce.c:274:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_roce.c:278:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:278:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_roce.c:278:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_roce.c:278:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:278:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_roce.c:278:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_roce.c:282:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:282:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_roce.c:282:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_roce.c:282:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:282:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_roce.c:282:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_roce.c:286:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:286:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_roce.c:286:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_roce.c:286:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:286:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_roce.c:286:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_roce.c:289:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:289:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_roce.c:289:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_roce.c:289:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:289:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_roce.c:289:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_roce.c:293:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:293:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_roce.c:293:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_roce.c:293:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:293:9:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_roce.c:293:9:    right side has type unsigned long long
>> drivers/net/ethernet/qlogic/qed/qed_roce.c:311:44: sparse: cast from restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_roce.c:312:44: sparse: cast from restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_roce.c:313:42: sparse: cast from restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_roce.c:314:42: sparse: cast from restricted __le32
>> drivers/net/ethernet/qlogic/qed/qed_roce.c:327:29: sparse: incorrect type in argument 1 (different base types) @@    expected unsigned short [usertype] *p_fw_mac @@    got  short [usertype] *p_fw_mac @@
   drivers/net/ethernet/qlogic/qed/qed_roce.c:327:29:    expected unsigned short [usertype] *p_fw_mac
   drivers/net/ethernet/qlogic/qed/qed_roce.c:327:29:    got restricted __le16 *<noident>
   drivers/net/ethernet/qlogic/qed/qed_roce.c:328:29: sparse: incorrect type in argument 1 (different base types) @@    expected unsigned short [usertype] *p_fw_mac @@    got  short [usertype] *p_fw_mac @@
   drivers/net/ethernet/qlogic/qed/qed_roce.c:328:29:    expected unsigned short [usertype] *p_fw_mac
   drivers/net/ethernet/qlogic/qed/qed_roce.c:328:29:    got restricted __le16 *<noident>
>> drivers/net/ethernet/qlogic/qed/qed_roce.c:330:32: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] udp_src_port @@    got unsignedrestricted __le16 [usertype] udp_src_port @@
   drivers/net/ethernet/qlogic/qed/qed_roce.c:330:32:    expected restricted __le16 [usertype] udp_src_port
   drivers/net/ethernet/qlogic/qed/qed_roce.c:330:32:    got unsigned short [unsigned] [usertype] udp_src_port
   drivers/net/ethernet/qlogic/qed/qed_roce.c:408:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:408:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_roce.c:408:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_roce.c:408:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:408:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_roce.c:408:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_roce.c:411:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:411:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_roce.c:411:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_roce.c:411:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:411:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_roce.c:411:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_roce.c:415:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:415:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_roce.c:415:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_roce.c:415:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:415:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_roce.c:415:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_roce.c:418:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:418:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_roce.c:418:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_roce.c:418:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:418:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_roce.c:418:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_roce.c:421:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:421:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_roce.c:421:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_roce.c:421:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:421:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_roce.c:421:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_roce.c:440:44: sparse: cast from restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_roce.c:441:44: sparse: cast from restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_roce.c:442:42: sparse: cast from restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_roce.c:443:42: sparse: cast from restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_roce.c:456:29: sparse: incorrect type in argument 1 (different base types) @@    expected unsigned short [usertype] *p_fw_mac @@    got  short [usertype] *p_fw_mac @@
   drivers/net/ethernet/qlogic/qed/qed_roce.c:456:29:    expected unsigned short [usertype] *p_fw_mac
   drivers/net/ethernet/qlogic/qed/qed_roce.c:456:29:    got restricted __le16 *<noident>
   drivers/net/ethernet/qlogic/qed/qed_roce.c:457:29: sparse: incorrect type in argument 1 (different base types) @@    expected unsigned short [usertype] *p_fw_mac @@    got  short [usertype] *p_fw_mac @@
   drivers/net/ethernet/qlogic/qed/qed_roce.c:457:29:    expected unsigned short [usertype] *p_fw_mac
   drivers/net/ethernet/qlogic/qed/qed_roce.c:457:29:    got restricted __le16 *<noident>
   drivers/net/ethernet/qlogic/qed/qed_roce.c:459:32: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] udp_src_port @@    got unsignedrestricted __le16 [usertype] udp_src_port @@
   drivers/net/ethernet/qlogic/qed/qed_roce.c:459:32:    expected restricted __le16 [usertype] udp_src_port
   drivers/net/ethernet/qlogic/qed/qed_roce.c:459:32:    got unsigned short [unsigned] [usertype] udp_src_port
   drivers/net/ethernet/qlogic/qed/qed_roce.c:519:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:519:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_roce.c:519:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_roce.c:519:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:519:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_roce.c:519:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_roce.c:522:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:522:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_roce.c:522:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_roce.c:522:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:522:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_roce.c:522:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_roce.c:526:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:526:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_roce.c:526:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_roce.c:526:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:526:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_roce.c:526:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_roce.c:530:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:530:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_roce.c:530:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_roce.c:530:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:530:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_roce.c:530:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_roce.c:534:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:534:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_roce.c:534:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_roce.c:534:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:534:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_roce.c:534:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_roce.c:538:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:538:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_roce.c:538:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_roce.c:538:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:538:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_roce.c:538:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_roce.c:543:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:543:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_roce.c:543:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_roce.c:543:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:543:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_roce.c:543:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_roce.c:547:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:547:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_roce.c:547:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_roce.c:547:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:547:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_roce.c:547:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_roce.c:552:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:552:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_roce.c:552:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_roce.c:552:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_roce.c:552:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_roce.c:552:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_roce.c:557:9: sparse: invalid assignment: &=
--
>> drivers/net/ethernet/qlogic/qed/qed_rdma.c:137:5: sparse: symbol 'qed_rdma_get_sb_id' was not declared. Should it be static?
>> drivers/net/ethernet/qlogic/qed/qed_rdma.c:685:5: sparse: symbol 'qed_rdma_stop' was not declared. Should it be static?
>> drivers/net/ethernet/qlogic/qed/qed_rdma.c:772:33: sparse: cast removes address space of expression
>> drivers/net/ethernet/qlogic/qed/qed_rdma.c:1039:31: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] int_timeout @@    got unsignedrestricted __le16 [usertype] int_timeout @@
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1039:31:    expected restricted __le16 [usertype] int_timeout
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1039:31:    got unsigned short [unsigned] [usertype] int_timeout
>> drivers/net/ethernet/qlogic/qed/qed_rdma.c:1141:21: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [unsigned] [short] [usertype] <noident> @@    got unsigned] [short] [usertype] <noident> @@
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1141:21:    expected unsigned short [unsigned] [short] [usertype] <noident>
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1141:21:    got restricted __le16 [usertype] <noident>
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1142:21: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [unsigned] [short] [usertype] <noident> @@    got unsigned] [short] [usertype] <noident> @@
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1142:21:    expected unsigned short [unsigned] [short] [usertype] <noident>
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1142:21:    got restricted __le16 [usertype] <noident>
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1143:21: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [unsigned] [short] [usertype] <noident> @@    got unsigned] [short] [usertype] <noident> @@
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1143:21:    expected unsigned short [unsigned] [short] [usertype] <noident>
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1143:21:    got restricted __le16 [usertype] <noident>
>> drivers/net/ethernet/qlogic/qed/qed_rdma.c:1434:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1434:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1434:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1434:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1434:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1434:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1438:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1438:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1438:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1438:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1438:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1438:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1441:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1441:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1441:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1441:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1441:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1441:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1446:17: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1446:17:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1446:17:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1446:17: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1446:17:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1446:17:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1450:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1450:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1450:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1450:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1450:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1450:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1454:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1454:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1454:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1454:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1454:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1454:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1458:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1458:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1458:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1458:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1458:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1458:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1462:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1462:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1462:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1462:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1462:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1462:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1466:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1466:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1466:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1466:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1466:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1466:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1469:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1469:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1469:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1469:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1469:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1469:9:    right side has type unsigned long long
--
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:270:22: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] pd @@    got unsignedrestricted __le16 [usertype] pd @@
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:270:22:    expected restricted __le16 [usertype] pd
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:270:22:    got unsigned short [unsigned] [usertype] pd
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:271:32: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] sq_num_pages @@    got unsignedrestricted __le16 [usertype] sq_num_pages @@
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:271:32:    expected restricted __le16 [usertype] sq_num_pages
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:271:32:    got unsigned short [unsigned] [usertype] sq_num_pages
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:272:32: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] rq_num_pages @@    got unsignedrestricted __le16 [usertype] rq_num_pages @@
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:272:32:    expected restricted __le16 [usertype] rq_num_pages
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:272:32:    got unsigned short [unsigned] [usertype] rq_num_pages
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:274:42: sparse: cast from restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:275:42: sparse: cast from restricted __le32
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:325:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:325:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:325:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:325:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:325:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:325:9:    right side has type unsigned long long
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:328:47: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] transition_to_state @@    got e] transition_to_state @@
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:328:47:    expected restricted __le16 [usertype] transition_to_state
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:328:47:    got int
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:330:47: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] transition_to_state @@    got e] transition_to_state @@
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:330:47:    expected restricted __le16 [usertype] transition_to_state
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:330:47:    got int
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:378:12: sparse: symbol 'iwarp_state_names' was not declared. Should it be static?
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:695:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:695:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:695:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:695:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:695:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:695:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:698:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:698:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:698:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:698:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:698:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:698:9:    right side has type unsigned long long
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:716:53: sparse: restricted __le16 degrades to integer
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:716:19: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] cwnd @@    got e] cwnd @@
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:716:19:    expected restricted __le32 [usertype] cwnd
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:716:19:    got int
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:718:25: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] ka_timeout @@    got e] ka_timeout @@
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:718:25:    expected restricted __le32 [usertype] ka_timeout
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:718:25:    got int
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:719:26: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] ka_interval @@    got e] ka_interval @@
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:719:26:    expected restricted __le32 [usertype] ka_interval
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:719:26:    got int
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:813:63: sparse: restricted __le16 degrades to integer
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:865:54: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] len @@    got unsignedrestricted __le16 [usertype] len @@
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:865:54:    expected restricted __le16 [usertype] len
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:865:54:    got unsigned short [unsigned] [usertype] private_data_len
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:869:41: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] ord @@    got unsignerestricted __le32 [usertype] ord @@
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:869:41:    expected restricted __le32 [usertype] ord
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:869:41:    got unsigned char [unsigned] [usertype] ord
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:870:41: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] ird @@    got unsignerestricted __le32 [usertype] ird @@
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:870:41:    expected restricted __le32 [usertype] ird
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:870:41:    got unsigned char [unsigned] [usertype] ird
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:872:31: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] tcp_cid @@    got  [usertype] tcp_cid @@
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:872:31:    expected restricted __le32 [usertype] tcp_cid
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:872:31:    got unsigned int
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:898:31: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] rcv_wnd @@    got unsignedrestricted __le16 [usertype] rcv_wnd @@
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:898:31:    expected restricted __le16 [usertype] rcv_wnd
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:898:31:    got unsigned short [unsigned] [usertype] rcv_wnd_size
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:964:64: sparse: restricted __le16 degrades to integer
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:944:1: sparse: symbol 'qed_iwarp_parse_private_data' was not declared. Should it be static?
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:969:1: sparse: symbol 'qed_iwarp_mpa_reply_arrived' was not declared. Should it be static?
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:1835:19: sparse: cast to restricted __be16
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:1835:19: sparse: cast to restricted __be16
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:1835:19: sparse: cast to restricted __be16
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:1835:19: sparse: cast to restricted __be16
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:1860:56: sparse: restricted __le16 degrades to integer
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:1861:59: sparse: restricted __le16 degrades to integer
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:1896:9: sparse: restricted __le16 degrades to integer
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:1903:9: sparse: restricted __le16 degrades to integer
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:2103:56: sparse: restricted __le16 degrades to integer
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:2124:23: sparse: cast to restricted __le32
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:2124:23: sparse: cast to restricted __le32
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:2127:36: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] first_mpa_offset @@    got e] first_mpa_offset @@
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:2127:36:    expected restricted __le16 [usertype] first_mpa_offset
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:2127:36:    got int
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:2129:23: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] cid @@    got unsignrestricted __le32 [usertype] cid @@
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:2129:23:    expected restricted __le32 [usertype] cid
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:2129:23:    got unsigned int [unsigned] [usertype] <noident>
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:2147:56: sparse: restricted __le32 degrades to integer
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:2155:57: sparse: restricted __le16 degrades to integer
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:2201:52: sparse: bad assignment (+=) to restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:2240:52: sparse: bad assignment (+=) to restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:2313:49: sparse: restricted __le16 degrades to integer
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:2314:40: sparse: bad assignment (+=) to restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_iwarp.c:2525:49: sparse: cast from restricted __le32
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:2511:1: sparse: symbol 'qed_iwarp_ll2_slowpath' was not declared. Should it be static?
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:2813:6: sparse: symbol 'qed_iwarp_qp_in_error' was not declared. Should it be static?
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:2834:6: sparse: symbol 'qed_iwarp_exception_received' was not declared. Should it be static?
>> drivers/net/ethernet/qlogic/qed/qed_iwarp.c:2965:1: sparse: symbol 'qed_iwarp_connect_complete' was not declared. Should it be static?
--
>> drivers/net/ethernet/qlogic/qed/qed_iscsi.c:325:29: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [unsigned] [usertype] physical_q0 @@    got  short [unsigned] [usertype] physical_q0 @@
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:325:29:    expected unsigned short [unsigned] [usertype] physical_q0
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:325:29:    got restricted __le16 [usertype] <noident>
>> drivers/net/ethernet/qlogic/qed/qed_iscsi.c:330:29: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [unsigned] [usertype] physical_q1 @@    got  short [unsigned] [usertype] physical_q1 @@
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:330:29:    expected unsigned short [unsigned] [usertype] physical_q1
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:330:29:    got restricted __le16 [usertype] <noident>
>> drivers/net/ethernet/qlogic/qed/qed_iscsi.c:361:42: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] local_mac_addr_hi @@    got e] local_mac_addr_hi @@
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:361:42:    expected restricted __le16 [usertype] local_mac_addr_hi
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:361:42:    got int
>> drivers/net/ethernet/qlogic/qed/qed_iscsi.c:362:43: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] local_mac_addr_mid @@    got e] local_mac_addr_mid @@
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:362:43:    expected restricted __le16 [usertype] local_mac_addr_mid
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:362:43:    got int
>> drivers/net/ethernet/qlogic/qed/qed_iscsi.c:363:42: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] local_mac_addr_lo @@    got e] local_mac_addr_lo @@
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:363:42:    expected restricted __le16 [usertype] local_mac_addr_lo
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:363:42:    got int
>> drivers/net/ethernet/qlogic/qed/qed_iscsi.c:366:43: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] remote_mac_addr_hi @@    got e] remote_mac_addr_hi @@
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:366:43:    expected restricted __le16 [usertype] remote_mac_addr_hi
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:366:43:    got int
>> drivers/net/ethernet/qlogic/qed/qed_iscsi.c:367:44: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] remote_mac_addr_mid @@    got e] remote_mac_addr_mid @@
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:367:44:    expected restricted __le16 [usertype] remote_mac_addr_mid
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:367:44:    got int
>> drivers/net/ethernet/qlogic/qed/qed_iscsi.c:368:43: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] remote_mac_addr_lo @@    got e] remote_mac_addr_lo @@
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:368:43:    expected restricted __le16 [usertype] remote_mac_addr_lo
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:368:43:    got int
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:427:43: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] local_mac_addr_hi @@    got e] local_mac_addr_hi @@
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:427:43:    expected restricted __le16 [usertype] local_mac_addr_hi
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:427:43:    got int
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:428:44: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] local_mac_addr_mid @@    got e] local_mac_addr_mid @@
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:428:44:    expected restricted __le16 [usertype] local_mac_addr_mid
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:428:44:    got int
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:429:43: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] local_mac_addr_lo @@    got e] local_mac_addr_lo @@
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:429:43:    expected restricted __le16 [usertype] local_mac_addr_lo
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:429:43:    got int
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:432:44: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] remote_mac_addr_hi @@    got e] remote_mac_addr_hi @@
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:432:44:    expected restricted __le16 [usertype] remote_mac_addr_hi
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:432:44:    got int
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:433:45: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] remote_mac_addr_mid @@    got e] remote_mac_addr_mid @@
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:433:45:    expected restricted __le16 [usertype] remote_mac_addr_mid
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:433:45:    got int
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:434:44: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] remote_mac_addr_lo @@    got e] remote_mac_addr_lo @@
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:434:44:    expected restricted __le16 [usertype] remote_mac_addr_lo
   drivers/net/ethernet/qlogic/qed/qed_iscsi.c:434:44:    got int
>> drivers/net/ethernet/qlogic/qed/qed_iscsi.c:876:6: sparse: symbol 'qed_iscsi_free_connection' was not declared. Should it be static?
--
>> drivers/net/ethernet/qlogic/qed/qed_fcoe.c:154:13: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [unsigned] [usertype] tmp @@    got  short [unsigned] [usertype] tmp @@
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:154:13:    expected unsigned short [unsigned] [usertype] tmp
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:154:13:    got restricted __le16 [usertype] <noident>
>> drivers/net/ethernet/qlogic/qed/qed_fcoe.c:155:37: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] sq_num_pages_in_pbl @@    got unsignedrestricted __le16 [usertype] sq_num_pages_in_pbl @@
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:155:37:    expected restricted __le16 [usertype] sq_num_pages_in_pbl
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:155:37:    got unsigned short [unsigned] [usertype] tmp
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:174:13: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [unsigned] [usertype] tmp @@    got  short [unsigned] [usertype] tmp @@
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:174:13:    expected unsigned short [unsigned] [usertype] tmp
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:174:13:    got restricted __le16 [usertype] <noident>
>> drivers/net/ethernet/qlogic/qed/qed_fcoe.c:175:39: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] num_tasks @@    got unsignedrestricted __le16 [usertype] num_tasks @@
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:175:39:    expected restricted __le16 [usertype] num_tasks
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:175:39:    got unsigned short [unsigned] [usertype] tmp
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:182:13: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [unsigned] [usertype] tmp @@    got  short [unsigned] [usertype] tmp @@
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:182:13:    expected unsigned short [unsigned] [usertype] tmp
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:182:13:    got restricted __le16 [usertype] <noident>
>> drivers/net/ethernet/qlogic/qed/qed_fcoe.c:183:41: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] cq_num_entries @@    got unsignedrestricted __le16 [usertype] cq_num_entries @@
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:183:41:    expected restricted __le16 [usertype] cq_num_entries
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:183:41:    got unsigned short [unsigned] [usertype] tmp
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:185:13: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [unsigned] [usertype] tmp @@    got  short [unsigned] [usertype] tmp @@
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:185:13:    expected unsigned short [unsigned] [usertype] tmp
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:185:13:    got restricted __le16 [usertype] <noident>
>> drivers/net/ethernet/qlogic/qed/qed_fcoe.c:186:43: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] cmdq_num_entries @@    got unsignedrestricted __le16 [usertype] cmdq_num_entries @@
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:186:43:    expected restricted __le16 [usertype] cmdq_num_entries
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:186:43:    got unsigned short [unsigned] [usertype] tmp
>> drivers/net/ethernet/qlogic/qed/qed_fcoe.c:198:21: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [unsigned] [assigned] [usertype] tmp @@    got igned] [assigned] [usertype] tmp @@
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:198:21:    expected unsigned short [unsigned] [assigned] [usertype] tmp
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:198:21:    got restricted __le16 [usertype] <noident>
>> drivers/net/ethernet/qlogic/qed/qed_fcoe.c:199:56: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 <noident> @@    got unsigned short [unsigned] [assrestricted __le16 <noident> @@
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:199:56:    expected restricted __le16 <noident>
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:199:56:    got unsigned short [unsigned] [assigned] [usertype] tmp
>> drivers/net/ethernet/qlogic/qed/qed_fcoe.c:276:29: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [unsigned] [usertype] physical_q0 @@    got  short [unsigned] [usertype] physical_q0 @@
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:276:29:    expected unsigned short [unsigned] [usertype] physical_q0
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:276:29:    got restricted __le16 [usertype] <noident>
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:298:13: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [unsigned] [usertype] tmp @@    got  short [unsigned] [usertype] tmp @@
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:298:13:    expected unsigned short [unsigned] [usertype] tmp
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:298:13:    got restricted __le16 [usertype] <noident>
>> drivers/net/ethernet/qlogic/qed/qed_fcoe.c:299:35: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] tx_max_fc_pay_len @@    got unsignedrestricted __le16 [usertype] tx_max_fc_pay_len @@
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:299:35:    expected restricted __le16 [usertype] tx_max_fc_pay_len
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:299:35:    got unsigned short [unsigned] [usertype] tmp
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:300:13: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [unsigned] [usertype] tmp @@    got  short [unsigned] [usertype] tmp @@
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:300:13:    expected unsigned short [unsigned] [usertype] tmp
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:300:13:    got restricted __le16 [usertype] <noident>
>> drivers/net/ethernet/qlogic/qed/qed_fcoe.c:301:35: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] e_d_tov_timer_val @@    got unsignedrestricted __le16 [usertype] e_d_tov_timer_val @@
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:301:35:    expected restricted __le16 [usertype] e_d_tov_timer_val
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:301:35:    got unsigned short [unsigned] [usertype] tmp
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:302:13: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [unsigned] [usertype] tmp @@    got  short [unsigned] [usertype] tmp @@
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:302:13:    expected unsigned short [unsigned] [usertype] tmp
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:302:13:    got restricted __le16 [usertype] <noident>
>> drivers/net/ethernet/qlogic/qed/qed_fcoe.c:303:38: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] rec_rr_tov_timer_val @@    got unsignedrestricted __le16 [usertype] rec_rr_tov_timer_val @@
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:303:38:    expected restricted __le16 [usertype] rec_rr_tov_timer_val
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:303:38:    got unsigned short [unsigned] [usertype] tmp
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:304:13: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [unsigned] [usertype] tmp @@    got  short [unsigned] [usertype] tmp @@
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:304:13:    expected unsigned short [unsigned] [usertype] tmp
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:304:13:    got restricted __le16 [usertype] <noident>
>> drivers/net/ethernet/qlogic/qed/qed_fcoe.c:305:35: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] rx_max_fc_pay_len @@    got unsignedrestricted __le16 [usertype] rx_max_fc_pay_len @@
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:305:35:    expected restricted __le16 [usertype] rx_max_fc_pay_len
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:305:35:    got unsigned short [unsigned] [usertype] tmp
>> drivers/net/ethernet/qlogic/qed/qed_fcoe.c:584:17: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:584:17:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:584:17:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:584:17: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:584:17:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:584:17:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:586:17: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:586:17:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:586:17:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:586:17: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:586:17:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_fcoe.c:586:17:    right side has type unsigned long long

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
