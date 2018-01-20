From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 6/6] mpt3sas: Introduce function to clone mpi reply.
Date: Sun, 21 Jan 2018 03:01:34 +0800
Message-ID: <201801210258.QgnweTjs%fengguang.wu@intel.com>
References: <1516365462-14708-7-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:51094 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756422AbeATTBt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 20 Jan 2018 14:01:49 -0500
Content-Disposition: inline
In-Reply-To: <1516365462-14708-7-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: kbuild-all@01.org, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, chaitra.basappa@broadcom.com, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

Hi Suganath,

I love your patch! Perhaps something to improve:

[auto build test WARNING on scsi/for-next]
[also build test WARNING on v4.15-rc8 next-20180119]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Suganath-Prabu-S/mpt3sas-Add-PCI-device-ID-for-Andromeda/20180121-002454
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/scsi/mpt3sas/mpt3sas_base.c:148:35: sparse: cast removes address space of expression
   drivers/scsi/mpt3sas/mpt3sas_base.c:151:16: sparse: cast from restricted __le32
   drivers/scsi/mpt3sas/mpt3sas_base.c:151:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:151:16: expected unsigned int val
   drivers/scsi/mpt3sas/mpt3sas_base.c:151:16: got restricted __le32 <noident>
   drivers/scsi/mpt3sas/mpt3sas_base.c:151:36: sparse: incorrect type in argument 2 (different address spaces) @@ expected void volatile @@ got @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:151:36: expected void volatile
   drivers/scsi/mpt3sas/mpt3sas_base.c:151:36: got void
   drivers/scsi/mpt3sas/mpt3sas_base.c:169:24: sparse: cast from restricted __le32
   drivers/scsi/mpt3sas/mpt3sas_base.c:169:24: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:169:24: expected unsigned int val
   drivers/scsi/mpt3sas/mpt3sas_base.c:169:24: got restricted __le32 <noident>
   drivers/scsi/mpt3sas/mpt3sas_base.c:169:64: sparse: incorrect type in argument 2 (different address spaces) @@ expected void volatile @@ got @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:169:64: expected void volatile
   drivers/scsi/mpt3sas/mpt3sas_base.c:169:64: got void COPYING CREDITS Documentation Kbuild Kconfig MAINTAINERS Makefile README arch block certs crypto drivers firmware fs include init ipc kernel lib mm net samples scripts security sound tools usr virt
   drivers/scsi/mpt3sas/mpt3sas_base.c:186:24: sparse: cast from restricted __le32
   drivers/scsi/mpt3sas/mpt3sas_base.c:186:24: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:186:24: expected unsigned int val
   drivers/scsi/mpt3sas/mpt3sas_base.c:186:24: got restricted __le32 <noident>
   drivers/scsi/mpt3sas/mpt3sas_base.c:186:64: sparse: incorrect type in argument 2 (different address spaces) @@ expected void volatile @@ got @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:186:64: expected void volatile
   drivers/scsi/mpt3sas/mpt3sas_base.c:186:64: got void COPYING CREDITS Documentation Kbuild Kconfig MAINTAINERS Makefile README arch block certs crypto drivers firmware fs include init ipc kernel lib mm net samples scripts security sound tools usr virt
   drivers/scsi/mpt3sas/mpt3sas_base.c:206:24: sparse: cast removes address space of expression
   drivers/scsi/mpt3sas/mpt3sas_base.c:359:24: sparse: undefined identifier 'mpt3sas_scsih_scsi_lookup_get'
   drivers/scsi/mpt3sas/mpt3sas_base.c:1208:42: sparse: incorrect type in assignment (different base types) @@ expected unsigned short Event @@ got short Event @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:1209:49: sparse: incorrect type in assignment (different base types) @@ expected unsigned int EventContext @@ got ed int EventContext @@
>> drivers/scsi/mpt3sas/mpt3sas_base.c:1404:75: sparse: incorrect type in argument 2 (different base types) @@ expected restricted __le32 reply @@ got unsigned int [unsrestricted __le32 reply @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:1430:64: sparse: incorrect type in argument 2 (different address spaces) @@ expected void volatile @@ got oid volatile @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:1479:52: sparse: incorrect type in argument 2 (different address spaces) @@ expected void volatile @@ got oid volatile @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:3011:32: sparse: cast removes address space of expression
   drivers/scsi/mpt3sas/mpt3sas_base.c:3359:26: sparse: cast removes address space of expression
   drivers/scsi/mpt3sas/mpt3sas_base.c:3303:26: sparse: incorrect type in initializer (different base types) @@ expected unsigned long long data_out @@ got g long data_out @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:3326:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned long val @@ got restunsigned long val @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:3326:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned long val @@ got restunsigned long val @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:3443:34: sparse: cast removes address space of expression
   drivers/scsi/mpt3sas/mpt3sas_base.c:3303:26: sparse: incorrect type in initializer (different base types) @@ expected unsigned long long data_out @@ got g long data_out @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:3326:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned long val @@ got restunsigned long val @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:3326:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned long val @@ got restunsigned long val @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:3512:34: sparse: cast removes address space of expression
   drivers/scsi/mpt3sas/mpt3sas_base.c:3303:26: sparse: incorrect type in initializer (different base types) @@ expected unsigned long long data_out @@ got g long data_out @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:3326:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned long val @@ got restunsigned long val @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:3552:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:3574:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:3597:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:3618:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:3639:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:5091:24: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:5112:20: sparse: cast to restricted __le16
   drivers/scsi/mpt3sas/mpt3sas_base.c:5121:20: sparse: cast to restricted __le16
   drivers/scsi/mpt3sas/mpt3sas_base.c:5135:36: sparse: cast to restricted __le16
   drivers/scsi/mpt3sas/mpt3sas_base.c:6274:59: sparse: incorrect type in argument 2 (different base types) @@ expected restricted __le32 reply @@ got unsigned int [unsrestricted __le32 reply @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:6319:55: sparse: incorrect type in argument 2 (different address spaces) @@ expected void volatile @@ got oid volatile @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:359:53: sparse: call with no type!
   drivers/scsi/mpt3sas/mpt3sas_base.c: In function '_clone_sg_entries':
   drivers/scsi/mpt3sas/mpt3sas_base.c:359:10: error: implicit declaration of function 'mpt3sas_scsih_scsi_lookup_get'; did you mean
    scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    mpt3sas_scsih_issue_locked_tm
   drivers/scsi/mpt3sas/mpt3sas_base.c:359:8: warning: assignment makes pointer from integer without a cast
    scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
    ^
   cc1: some warnings being treated as errors

vim +1404 drivers/scsi/mpt3sas/mpt3sas_base.c

  1311	
  1312	/**
  1313	 * _base_interrupt - MPT adapter (IOC) specific interrupt handler.
  1314	 * @irq: irq number (not used)
  1315	 * @bus_id: bus identifier cookie == pointer to MPT_ADAPTER structure
  1316	 * @r: pt_regs pointer (not used)
  1317	 *
  1318	 * Return IRQ_HANDLE if processed, else IRQ_NONE.
  1319	 */
  1320	static irqreturn_t
  1321	_base_interrupt(int irq, void *bus_id)
  1322	{
  1323		struct adapter_reply_queue *reply_q = bus_id;
  1324		union reply_descriptor rd;
  1325		u32 completed_cmds;
  1326		u8 request_desript_type;
  1327		u16 smid;
  1328		u8 cb_idx;
  1329		u32 reply;
  1330		u8 msix_index = reply_q->msix_index;
  1331		struct MPT3SAS_ADAPTER *ioc = reply_q->ioc;
  1332		Mpi2ReplyDescriptorsUnion_t *rpf;
  1333		u8 rc;
  1334	
  1335		if (ioc->mask_interrupts)
  1336			return IRQ_NONE;
  1337	
  1338		if (!atomic_add_unless(&reply_q->busy, 1, 1))
  1339			return IRQ_NONE;
  1340	
  1341		rpf = &reply_q->reply_post_free[reply_q->reply_post_host_index];
  1342		request_desript_type = rpf->Default.ReplyFlags
  1343		     & MPI2_RPY_DESCRIPT_FLAGS_TYPE_MASK;
  1344		if (request_desript_type == MPI2_RPY_DESCRIPT_FLAGS_UNUSED) {
  1345			atomic_dec(&reply_q->busy);
  1346			return IRQ_NONE;
  1347		}
  1348	
  1349		completed_cmds = 0;
  1350		cb_idx = 0xFF;
  1351		do {
  1352			rd.word = le64_to_cpu(rpf->Words);
  1353			if (rd.u.low == UINT_MAX || rd.u.high == UINT_MAX)
  1354				goto out;
  1355			reply = 0;
  1356			smid = le16_to_cpu(rpf->Default.DescriptorTypeDependent1);
  1357			if (request_desript_type ==
  1358			    MPI25_RPY_DESCRIPT_FLAGS_FAST_PATH_SCSI_IO_SUCCESS ||
  1359			    request_desript_type ==
  1360			    MPI2_RPY_DESCRIPT_FLAGS_SCSI_IO_SUCCESS ||
  1361			    request_desript_type ==
  1362			    MPI26_RPY_DESCRIPT_FLAGS_PCIE_ENCAPSULATED_SUCCESS) {
  1363				cb_idx = _base_get_cb_idx(ioc, smid);
  1364				if ((likely(cb_idx < MPT_MAX_CALLBACKS)) &&
  1365				    (likely(mpt_callbacks[cb_idx] != NULL))) {
  1366					rc = mpt_callbacks[cb_idx](ioc, smid,
  1367					    msix_index, 0);
  1368					if (rc)
  1369						mpt3sas_base_free_smid(ioc, smid);
  1370				}
  1371			} else if (request_desript_type ==
  1372			    MPI2_RPY_DESCRIPT_FLAGS_ADDRESS_REPLY) {
  1373				reply = le32_to_cpu(
  1374				    rpf->AddressReply.ReplyFrameAddress);
  1375				if (reply > ioc->reply_dma_max_address ||
  1376				    reply < ioc->reply_dma_min_address)
  1377					reply = 0;
  1378				if (smid) {
  1379					cb_idx = _base_get_cb_idx(ioc, smid);
  1380					if ((likely(cb_idx < MPT_MAX_CALLBACKS)) &&
  1381					    (likely(mpt_callbacks[cb_idx] != NULL))) {
  1382						rc = mpt_callbacks[cb_idx](ioc, smid,
  1383						    msix_index, reply);
  1384						if (reply)
  1385							_base_display_reply_info(ioc,
  1386							    smid, msix_index, reply);
  1387						if (rc)
  1388							mpt3sas_base_free_smid(ioc,
  1389							    smid);
  1390					}
  1391				} else {
  1392					_base_async_event(ioc, msix_index, reply);
  1393				}
  1394	
  1395				/* reply free queue handling */
  1396				if (reply) {
  1397					ioc->reply_free_host_index =
  1398					    (ioc->reply_free_host_index ==
  1399					    (ioc->reply_free_queue_depth - 1)) ?
  1400					    0 : ioc->reply_free_host_index + 1;
  1401					ioc->reply_free[ioc->reply_free_host_index] =
  1402					    cpu_to_le32(reply);
  1403					if (ioc->is_mcpu_endpoint)
> 1404						_base_clone_reply_to_sys_mem(ioc, reply,
  1405							ioc->reply_free_host_index);
  1406					writel(ioc->reply_free_host_index,
  1407					    &ioc->chip->ReplyFreeHostIndex);
  1408				}
  1409			}
  1410	
  1411			rpf->Words = cpu_to_le64(ULLONG_MAX);
  1412			reply_q->reply_post_host_index =
  1413			    (reply_q->reply_post_host_index ==
  1414			    (ioc->reply_post_queue_depth - 1)) ? 0 :
  1415			    reply_q->reply_post_host_index + 1;
  1416			request_desript_type =
  1417			    reply_q->reply_post_free[reply_q->reply_post_host_index].
  1418			    Default.ReplyFlags & MPI2_RPY_DESCRIPT_FLAGS_TYPE_MASK;
  1419			completed_cmds++;
  1420			/* Update the reply post host index after continuously
  1421			 * processing the threshold number of Reply Descriptors.
  1422			 * So that FW can find enough entries to post the Reply
  1423			 * Descriptors in the reply descriptor post queue.
  1424			 */
  1425			if (completed_cmds > ioc->hba_queue_depth/3) {
  1426				if (ioc->combined_reply_queue) {
  1427					writel(reply_q->reply_post_host_index |
  1428							((msix_index  & 7) <<
  1429							 MPI2_RPHI_MSIX_INDEX_SHIFT),
  1430					    ioc->replyPostRegisterIndex[msix_index/8]);
  1431				} else {
  1432					writel(reply_q->reply_post_host_index |
  1433							(msix_index <<
  1434							 MPI2_RPHI_MSIX_INDEX_SHIFT),
  1435							&ioc->chip->ReplyPostHostIndex);
  1436				}
  1437				completed_cmds = 1;
  1438			}
  1439			if (request_desript_type == MPI2_RPY_DESCRIPT_FLAGS_UNUSED)
  1440				goto out;
  1441			if (!reply_q->reply_post_host_index)
  1442				rpf = reply_q->reply_post_free;
  1443			else
  1444				rpf++;
  1445		} while (1);
  1446	
  1447	 out:
  1448	
  1449		if (!completed_cmds) {
  1450			atomic_dec(&reply_q->busy);
  1451			return IRQ_NONE;
  1452		}
  1453	
  1454		if (ioc->is_warpdrive) {
  1455			writel(reply_q->reply_post_host_index,
  1456			ioc->reply_post_host_index[msix_index]);
  1457			atomic_dec(&reply_q->busy);
  1458			return IRQ_HANDLED;
  1459		}
  1460	
  1461		/* Update Reply Post Host Index.
  1462		 * For those HBA's which support combined reply queue feature
  1463		 * 1. Get the correct Supplemental Reply Post Host Index Register.
  1464		 *    i.e. (msix_index / 8)th entry from Supplemental Reply Post Host
  1465		 *    Index Register address bank i.e replyPostRegisterIndex[],
  1466		 * 2. Then update this register with new reply host index value
  1467		 *    in ReplyPostIndex field and the MSIxIndex field with
  1468		 *    msix_index value reduced to a value between 0 and 7,
  1469		 *    using a modulo 8 operation. Since each Supplemental Reply Post
  1470		 *    Host Index Register supports 8 MSI-X vectors.
  1471		 *
  1472		 * For other HBA's just update the Reply Post Host Index register with
  1473		 * new reply host index value in ReplyPostIndex Field and msix_index
  1474		 * value in MSIxIndex field.
  1475		 */
  1476		if (ioc->combined_reply_queue)
  1477			writel(reply_q->reply_post_host_index | ((msix_index  & 7) <<
  1478				MPI2_RPHI_MSIX_INDEX_SHIFT),
  1479				ioc->replyPostRegisterIndex[msix_index/8]);
  1480		else
  1481			writel(reply_q->reply_post_host_index | (msix_index <<
  1482				MPI2_RPHI_MSIX_INDEX_SHIFT),
  1483				&ioc->chip->ReplyPostHostIndex);
  1484		atomic_dec(&reply_q->busy);
  1485		return IRQ_HANDLED;
  1486	}
  1487	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
