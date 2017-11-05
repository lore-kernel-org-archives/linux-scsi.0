From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: target-pending/for-next patches
Date: Sat, 04 Nov 2017 18:14:22 -0700
Message-ID: <1509844462.29624.14.camel@haakon3.daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mike Christie <mchristi@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Hi all,

Just a friendly email after catching up on patches this week, the
majority of those outstanding on the list have been merged into
target-pending/for-next.  Please see below.

For those who submitted patches, please have a look and let me know if
anything is else missing.  Note there are two exceptions that have been
left out for now that I'll be following up with separately.

Thus far it's all been either straight-forward bug-fixes, minor
cleanups, or small miscellaneous enhancements.  AFAICT, nothing looks
particularly concerning.

Thank you,

--nab

17c45b9 iSCSI-target: Use common error handling code in iscsi_decode_text_input()
6eaf69e target/iscsi: Detect conn_cmd_list corruption early
cfe2b62 target/iscsi: Fix a race condition in iscsit_add_reject_from_cmd()
e1dfb21 target/iscsi: Modify iscsit_do_crypto_hash_buf() prototype
de3493a target/iscsi: Fix endianness in an error message
919765e target/iscsi: Use min() in iscsit_dump_data_payload() instead of open-coding it
8d973ab target/iscsi: Define OFFLOAD_BUF_SIZE once
c017069 target: Inline transport_put_cmd()
d7e595d target: Suppress gcc 7 fallthrough warnings
c48e559 target: Move a declaration of a global variable into a header file
0d44374 tcmu: fix double se_cmd completion
a271eac target: return SAM_STAT_TASK_SET_FULL for TCM_OUT_OF_RESOURCES
55435ba target: fix ALUA state file path truncation
bdc79f0 target: fix PR state file path truncation
1ae0172 cxgbit: Abort the TCP connection in case of data out timeout
b849b45 target: Add netlink command reply supported option for each device
b5ab697 target/tcmu: Use macro to call container_of in tcmu_cmd_time_out_show
c22adc0 tcmu: fix crash when removing the tcmu device
a0884d4 iscsi-target: fix memory leak in iscsit_release_discovery_tpg()
12d5a43 iscsi-target: fix memory leak in lio_target_tiqn_addtpg()
24528f0 target:fix condition return in core_pr_dump_initiator_port()
a2db857 target: fix match_token option in target_core_configfs.c
79dd6f2 target: add sense code INSUFFICIENT REGISTRATION RESOURCES
e437fa3 target: fix double unmap data sg in core_scsi3_emulate_pro_register_and_move()
c58a252 target: fix buffer offset in core_scsi3_pri_read_full_status
88fb2fa target: fix null pointer regression in core_tmr_drain_tmr_list
594e25e target/file: Do not return error for UNMAP if length is zero
