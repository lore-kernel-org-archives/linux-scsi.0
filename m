From: kbuild test robot <fengguang.wu@intel.com>
Subject: [hch-scsi-queue:scsi-for-3.20 39/42]
 drivers/scsi/megaraid/megaraid_sas_base.c:1701:6: sparse: symbol
 'megasas_complete_outstanding_ioctls' was not declared. Should it be static?
Date: Fri, 9 Jan 2015 23:54:30 +0800
Message-ID: <201501092322.aenpxV0o%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:45948 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbbAIPyx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jan 2015 10:54:53 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Sumit.Saxena@avagotech.com" <Sumit.Saxena@avagotech.com>
Cc: kbuild-all@01.org, Christoph Hellwig <hch@lst.de>, Sumit Saxena <sumit.saxena@avagotech.com>, Chaitra Basappa <chaitra.basappa@avagotech.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

tree:   git://git.infradead.org/users/hch/scsi-queue.git scsi-for-3.20
head:   0128d5cf8f85c93b3c70ff03299c2839f3e6d21e
commit: c8dd61eff2780c481fcf919c1572e16e397c714e [39/42] megaraid_sas: complete outstanding IOCTLs before killing adapter
reproduce:
  # apt-get install sparse
  git checkout c8dd61eff2780c481fcf919c1572e16e397c714e
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/scsi/megaraid/megaraid_sas_base.c:923:26: sparse: invalid assignment: |=
   drivers/scsi/megaraid/megaraid_sas_base.c:923:26:    left side has type unsigned short
   drivers/scsi/megaraid/megaraid_sas_base.c:923:26:    right side has type restricted __le16
   drivers/scsi/megaraid/megaraid_sas_base.c:1002:25: sparse: incorrect type in assignment (different base types)
   drivers/scsi/megaraid/megaraid_sas_base.c:1002:25:    expected unsigned short [unsigned] [usertype] flags
   drivers/scsi/megaraid/megaraid_sas_base.c:1002:25:    got restricted __le16 [usertype] <noident>
   drivers/scsi/megaraid/megaraid_sas_base.c:1003:33: sparse: incorrect type in assignment (different base types)
   drivers/scsi/megaraid/megaraid_sas_base.c:1003:33:    expected unsigned int [unsigned] [usertype] abort_context
   drivers/scsi/megaraid/megaraid_sas_base.c:1003:33:    got restricted __le32 [usertype] <noident>
   drivers/scsi/megaraid/megaraid_sas_base.c:1004:42: sparse: incorrect type in assignment (different base types)
   drivers/scsi/megaraid/megaraid_sas_base.c:1004:42:    expected unsigned int [unsigned] [usertype] abort_mfi_phys_addr_lo
   drivers/scsi/megaraid/megaraid_sas_base.c:1004:42:    got restricted __le32 [usertype] <noident>
   drivers/scsi/megaraid/megaraid_sas_base.c:1006:42: sparse: incorrect type in assignment (different base types)
   drivers/scsi/megaraid/megaraid_sas_base.c:1006:42:    expected unsigned int [unsigned] [usertype] abort_mfi_phys_addr_hi
   drivers/scsi/megaraid/megaraid_sas_base.c:1006:42:    got restricted __le32 [usertype] <noident>
   drivers/scsi/megaraid/megaraid_sas_base.c:1054:50: sparse: incorrect type in assignment (different base types)
   drivers/scsi/megaraid/megaraid_sas_base.c:1054:50:    expected unsigned int [unsigned] [usertype] length
   drivers/scsi/megaraid/megaraid_sas_base.c:1054:50:    got restricted __le32 [usertype] <noident>
   drivers/scsi/megaraid/megaraid_sas_base.c:1055:53: sparse: incorrect type in assignment (different base types)
   drivers/scsi/megaraid/megaraid_sas_base.c:1055:53:    expected unsigned int [unsigned] [usertype] phys_addr
   drivers/scsi/megaraid/megaraid_sas_base.c:1055:53:    got restricted __le32 [usertype] <noident>
   drivers/scsi/megaraid/megaraid_sas_base.c:1083:50: sparse: incorrect type in assignment (different base types)
   drivers/scsi/megaraid/megaraid_sas_base.c:1083:50:    expected unsigned int [unsigned] [usertype] length
   drivers/scsi/megaraid/megaraid_sas_base.c:1083:50:    got restricted __le32 [usertype] <noident>
   drivers/scsi/megaraid/megaraid_sas_base.c:1084:53: sparse: incorrect type in assignment (different base types)
   drivers/scsi/megaraid/megaraid_sas_base.c:1084:53:    expected unsigned long long [unsigned] [usertype] phys_addr
   drivers/scsi/megaraid/megaraid_sas_base.c:1084:53:    got restricted __le64 [usertype] <noident>
   drivers/scsi/megaraid/megaraid_sas_base.c:1111:55: sparse: incorrect type in assignment (different base types)
   drivers/scsi/megaraid/megaraid_sas_base.c:1111:55:    expected unsigned int [unsigned] [usertype] length
   drivers/scsi/megaraid/megaraid_sas_base.c:1111:55:    got restricted __le32 [usertype] <noident>
   drivers/scsi/megaraid/megaraid_sas_base.c:1113:58: sparse: incorrect type in assignment (different base types)
   drivers/scsi/megaraid/megaraid_sas_base.c:1113:58:    expected unsigned long long [unsigned] [usertype] phys_addr
   drivers/scsi/megaraid/megaraid_sas_base.c:1113:58:    got restricted __le64 [usertype] <noident>
   drivers/scsi/megaraid/megaraid_sas_base.c:1115:53: sparse: incorrect type in assignment (different base types)
   drivers/scsi/megaraid/megaraid_sas_base.c:1115:53:    expected unsigned int [unsigned] [usertype] flag
   drivers/scsi/megaraid/megaraid_sas_base.c:1115:53:    got restricted __le32 [usertype] <noident>
   drivers/scsi/megaraid/megaraid_sas_base.c:1224:22: sparse: incorrect type in assignment (different base types)
   drivers/scsi/megaraid/megaraid_sas_base.c:1224:22:    expected unsigned short [unsigned] [usertype] flags
   drivers/scsi/megaraid/megaraid_sas_base.c:1224:22:    got restricted __le16 [usertype] <noident>
   drivers/scsi/megaraid/megaraid_sas_base.c:1225:30: sparse: incorrect type in assignment (different base types)
   drivers/scsi/megaraid/megaraid_sas_base.c:1225:30:    expected unsigned int [unsigned] [usertype] data_xfer_len
   drivers/scsi/megaraid/megaraid_sas_base.c:1225:30:    got restricted __le32 [usertype] <noident>
   drivers/scsi/megaraid/megaraid_sas_base.c:1237:40: sparse: incorrect type in assignment (different base types)
   drivers/scsi/megaraid/megaraid_sas_base.c:1237:40:    expected unsigned short [unsigned] [usertype] timeout
   drivers/scsi/megaraid/megaraid_sas_base.c:1237:40:    got restricted __le16 [usertype] <noident>
   drivers/scsi/megaraid/megaraid_sas_base.c:1244:30: sparse: invalid assignment: |=
   drivers/scsi/megaraid/megaraid_sas_base.c:1244:30:    left side has type unsigned short
   drivers/scsi/megaraid/megaraid_sas_base.c:1244:30:    right side has type restricted __le16
   drivers/scsi/megaraid/megaraid_sas_base.c:1248:30: sparse: invalid assignment: |=
   drivers/scsi/megaraid/megaraid_sas_base.c:1248:30:    left side has type unsigned short
   drivers/scsi/megaraid/megaraid_sas_base.c:1248:30:    right side has type restricted __le16
   drivers/scsi/megaraid/megaraid_sas_base.c:1265:39: sparse: incorrect type in assignment (different base types)
   drivers/scsi/megaraid/megaraid_sas_base.c:1265:39:    expected unsigned int [unsigned] [usertype] sense_buf_phys_addr_hi
   drivers/scsi/megaraid/megaraid_sas_base.c:1265:39:    got restricted __le32 [usertype] <noident>
   drivers/scsi/megaraid/megaraid_sas_base.c:1267:39: sparse: incorrect type in assignment (different base types)
   drivers/scsi/megaraid/megaraid_sas_base.c:1267:39:    expected unsigned int [unsigned] [usertype] sense_buf_phys_addr_lo
   drivers/scsi/megaraid/megaraid_sas_base.c:1267:39:    got restricted __le32 [usertype] <noident>
   drivers/scsi/megaraid/megaraid_sas_base.c:1319:21: sparse: incorrect type in assignment (different base types)
   drivers/scsi/megaraid/megaraid_sas_base.c:1319:21:    expected unsigned short [unsigned] [usertype] flags
   drivers/scsi/megaraid/megaraid_sas_base.c:1319:21:    got restricted __le16 [usertype] <noident>
   drivers/scsi/megaraid/megaraid_sas_base.c:1327:33: sparse: incorrect type in assignment (different base types)
   drivers/scsi/megaraid/megaraid_sas_base.c:1327:33:    expected unsigned int [unsigned] [usertype] lba_count
   drivers/scsi/megaraid/megaraid_sas_base.c:1327:33:    got restricted __le32 [usertype] <noident>
   drivers/scsi/megaraid/megaraid_sas_base.c:1328:36: sparse: incorrect type in assignment (different base types)
   drivers/scsi/megaraid/megaraid_sas_base.c:1328:36:    expected unsigned int [unsigned] [usertype] start_lba_lo
   drivers/scsi/megaraid/megaraid_sas_base.c:1328:36:    got restricted __le32 [usertype] <noident>
   drivers/scsi/megaraid/megaraid_sas_base.c:1332:36: sparse: invalid assignment: &=
   drivers/scsi/megaraid/megaraid_sas_base.c:1332:36:    left side has type unsigned int
   drivers/scsi/megaraid/megaraid_sas_base.c:1332:36:    right side has type restricted __le32
   drivers/scsi/megaraid/megaraid_sas_base.c:1339:33: sparse: incorrect type in assignment (different base types)
   drivers/scsi/megaraid/megaraid_sas_base.c:1339:33:    expected unsigned int [unsigned] [usertype] lba_count
   drivers/scsi/megaraid/megaraid_sas_base.c:1339:33:    got restricted __le32 [usertype] <noident>
   drivers/scsi/megaraid/megaraid_sas_base.c:1341:36: sparse: incorrect type in assignment (different base types)
   drivers/scsi/megaraid/megaraid_sas_base.c:1341:36:    expected unsigned int [unsigned] [usertype] start_lba_lo
   drivers/scsi/megaraid/megaraid_sas_base.c:1341:36:    got restricted __le32 [usertype] <noident>
   drivers/scsi/megaraid/megaraid_sas_base.c:1351:33: sparse: incorrect type in assignment (different base types)
   drivers/scsi/megaraid/megaraid_sas_base.c:1351:33:    expected unsigned int [unsigned] [usertype] lba_count
   drivers/scsi/megaraid/megaraid_sas_base.c:1351:33:    got restricted __le32 [usertype] <noident>
   drivers/scsi/megaraid/megaraid_sas_base.c:1356:36: sparse: incorrect type in assignment (different base types)
   drivers/scsi/megaraid/megaraid_sas_base.c:1356:36:    expected unsigned int [unsigned] [usertype] start_lba_lo
   drivers/scsi/megaraid/megaraid_sas_base.c:1356:36:    got restricted __le32 [usertype] <noident>
   drivers/scsi/megaraid/megaraid_sas_base.c:1366:33: sparse: incorrect type in assignment (different base types)
   drivers/scsi/megaraid/megaraid_sas_base.c:1366:33:    expected unsigned int [unsigned] [usertype] lba_count
   drivers/scsi/megaraid/megaraid_sas_base.c:1366:33:    got restricted __le32 [usertype] <noident>
   drivers/scsi/megaraid/megaraid_sas_base.c:1371:36: sparse: incorrect type in assignment (different base types)
   drivers/scsi/megaraid/megaraid_sas_base.c:1371:36:    expected unsigned int [unsigned] [usertype] start_lba_lo
   drivers/scsi/megaraid/megaraid_sas_base.c:1371:36:    got restricted __le32 [usertype] <noident>
   drivers/scsi/megaraid/megaraid_sas_base.c:1376:36: sparse: incorrect type in assignment (different base types)
   drivers/scsi/megaraid/megaraid_sas_base.c:1376:36:    expected unsigned int [unsigned] [usertype] start_lba_hi
   drivers/scsi/megaraid/megaraid_sas_base.c:1376:36:    got restricted __le32 [usertype] <noident>
   drivers/scsi/megaraid/megaraid_sas_base.c:1387:29: sparse: invalid assignment: |=
   drivers/scsi/megaraid/megaraid_sas_base.c:1387:29:    left side has type unsigned short
   drivers/scsi/megaraid/megaraid_sas_base.c:1387:29:    right side has type restricted __le16
   drivers/scsi/megaraid/megaraid_sas_base.c:1391:29: sparse: invalid assignment: |=
   drivers/scsi/megaraid/megaraid_sas_base.c:1391:29:    left side has type unsigned short
   drivers/scsi/megaraid/megaraid_sas_base.c:1391:29:    right side has type restricted __le16
   drivers/scsi/megaraid/megaraid_sas_base.c:1407:38: sparse: incorrect type in assignment (different base types)
   drivers/scsi/megaraid/megaraid_sas_base.c:1407:38:    expected unsigned int [unsigned] [usertype] sense_buf_phys_addr_lo
   drivers/scsi/megaraid/megaraid_sas_base.c:1407:38:    got restricted __le32 [usertype] <noident>
>> drivers/scsi/megaraid/megaraid_sas_base.c:1701:6: sparse: symbol 'megasas_complete_outstanding_ioctls' was not declared. Should it be static?
   drivers/scsi/megaraid/megaraid_sas_base.c:1868:37: sparse: incorrect type in assignment (different base types)
   drivers/scsi/megaraid/megaraid_sas_base.c:1868:37:    expected unsigned int [unsigned] [usertype] <noident>
   drivers/scsi/megaraid/megaraid_sas_base.c:1868:37:    got restricted __le32 [usertype] <noident>
   drivers/scsi/megaraid/megaraid_sas_base.c:1863:6: sparse: symbol 'megasas_do_ocr' was not declared. Should it be static?
   drivers/scsi/megaraid/megaraid_sas_base.c:2177:5: sparse: too many warnings

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
