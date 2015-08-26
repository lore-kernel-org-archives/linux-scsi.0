From: kbuild test robot <fengguang.wu@intel.com>
Subject: [scsi:misc 35/39] drivers/scsi/qla2xxx/qla_iocb.c:1972:18: sparse:
 incorrect type in assignment (different base types)
Date: Thu, 27 Aug 2015 05:01:12 +0800
Message-ID: <201508270507.SZtS5QlR%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:59422 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbbHZVE3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Aug 2015 17:04:29 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: kbuild-all@01.org, James Bottomley <JBottomley@Odin.com>, linux-scsi@vger.kernel.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git misc
head:   8d16366b5f23e928e5fd22eaeaceeb0356921fc0
commit: 118e2ef9df2297147706d21d2a1dfeefea878c5a [35/39] qla2xxx: Avoid that sparse complains about duplicate [noderef] attributes
reproduce:
  # apt-get install sparse
  git checkout 118e2ef9df2297147706d21d2a1dfeefea878c5a
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/scsi/qla2xxx/qla_iocb.c:1380:17:    got restricted __be32 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1383:37: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1383:37:    expected unsigned int [unsigned] [usertype] byte_count
   drivers/scsi/qla2xxx/qla_iocb.c:1383:37:    got restricted __le32 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1388:32: sparse: invalid assignment: |=
   drivers/scsi/qla2xxx/qla_iocb.c:1388:32:    left side has type unsigned short
   drivers/scsi/qla2xxx/qla_iocb.c:1388:32:    right side has type restricted __le16
   drivers/scsi/qla2xxx/qla_iocb.c:1400:40: sparse: invalid assignment: |=
   drivers/scsi/qla2xxx/qla_iocb.c:1400:40:    left side has type unsigned short
   drivers/scsi/qla2xxx/qla_iocb.c:1400:40:    right side has type restricted __le16
   drivers/scsi/qla2xxx/qla_iocb.c:1732:26: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1732:26:    expected unsigned short [unsigned] [usertype] timeout
   drivers/scsi/qla2xxx/qla_iocb.c:1732:26:    got restricted __le16 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1880:30: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1880:30:    expected unsigned short [unsigned] [usertype] control_flags
   drivers/scsi/qla2xxx/qla_iocb.c:1880:30:    got restricted __le16 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1882:38: sparse: invalid assignment: |=
   drivers/scsi/qla2xxx/qla_iocb.c:1882:38:    left side has type unsigned short
   drivers/scsi/qla2xxx/qla_iocb.c:1882:38:    right side has type restricted __le16
   drivers/scsi/qla2xxx/qla_iocb.c:1884:38: sparse: invalid assignment: |=
   drivers/scsi/qla2xxx/qla_iocb.c:1884:38:    left side has type unsigned short
   drivers/scsi/qla2xxx/qla_iocb.c:1884:38:    right side has type restricted __le16
   drivers/scsi/qla2xxx/qla_iocb.c:1885:29: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1885:29:    expected unsigned short [unsigned] [usertype] nport_handle
   drivers/scsi/qla2xxx/qla_iocb.c:1885:29:    got restricted __le16 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1900:9: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1900:9:    expected unsigned short [unsigned] [usertype] extended
   drivers/scsi/qla2xxx/qla_iocb.c:1900:9:    got restricted __le16 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1901:18: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1901:18:    expected unsigned short [unsigned] [usertype] mb0
   drivers/scsi/qla2xxx/qla_iocb.c:1901:18:    got restricted __le16 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1905:26: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1905:26:    expected unsigned short [unsigned] [usertype] mb1
   drivers/scsi/qla2xxx/qla_iocb.c:1905:26:    got restricted __le16 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1906:27: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1906:27:    expected unsigned short [unsigned] [usertype] mb10
   drivers/scsi/qla2xxx/qla_iocb.c:1906:27:    got restricted __le16 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1908:26: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1908:26:    expected unsigned short [unsigned] [usertype] mb1
   drivers/scsi/qla2xxx/qla_iocb.c:1908:26:    got restricted __le16 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1910:18: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1910:18:    expected unsigned short [unsigned] [usertype] mb2
   drivers/scsi/qla2xxx/qla_iocb.c:1910:18:    got restricted __le16 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1911:18: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1911:18:    expected unsigned short [unsigned] [usertype] mb3
   drivers/scsi/qla2xxx/qla_iocb.c:1911:18:    got restricted __le16 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1913:18: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1913:18:    expected unsigned short [unsigned] [usertype] mb9
   drivers/scsi/qla2xxx/qla_iocb.c:1913:18:    got restricted __le16 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1920:30: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1920:30:    expected unsigned short [unsigned] [usertype] control_flags
   drivers/scsi/qla2xxx/qla_iocb.c:1920:30:    got restricted __le16 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1922:29: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1922:29:    expected unsigned short [unsigned] [usertype] nport_handle
   drivers/scsi/qla2xxx/qla_iocb.c:1922:29:    got restricted __le16 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1935:9: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1935:9:    expected unsigned short [unsigned] [usertype] extended
   drivers/scsi/qla2xxx/qla_iocb.c:1935:9:    got restricted __le16 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1936:18: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1936:18:    expected unsigned short [unsigned] [usertype] mb0
   drivers/scsi/qla2xxx/qla_iocb.c:1936:18:    got restricted __le16 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1937:18: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1937:18:    expected unsigned short [unsigned] [usertype] mb1
   drivers/scsi/qla2xxx/qla_iocb.c:1937:18:    got restricted __le16
   drivers/scsi/qla2xxx/qla_iocb.c:1940:18: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1940:18:    expected unsigned short [unsigned] [usertype] mb2
   drivers/scsi/qla2xxx/qla_iocb.c:1940:18:    got restricted __le16 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1941:18: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1941:18:    expected unsigned short [unsigned] [usertype] mb3
   drivers/scsi/qla2xxx/qla_iocb.c:1941:18:    got restricted __le16 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1943:18: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1943:18:    expected unsigned short [unsigned] [usertype] mb9
   drivers/scsi/qla2xxx/qla_iocb.c:1943:18:    got restricted __le16 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1951:30: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1951:30:    expected unsigned short [unsigned] [usertype] control_flags
   drivers/scsi/qla2xxx/qla_iocb.c:1951:30:    got restricted __le16 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1952:29: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1952:29:    expected unsigned short [unsigned] [usertype] nport_handle
   drivers/scsi/qla2xxx/qla_iocb.c:1952:29:    got restricted __le16 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1962:9: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1962:9:    expected unsigned short [unsigned] [usertype] extended
   drivers/scsi/qla2xxx/qla_iocb.c:1962:9:    got restricted __le16 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1963:18: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1963:18:    expected unsigned short [unsigned] [usertype] mb0
   drivers/scsi/qla2xxx/qla_iocb.c:1963:18:    got restricted __le16 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1965:26: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1965:26:    expected unsigned short [unsigned] [usertype] mb1
   drivers/scsi/qla2xxx/qla_iocb.c:1965:26:    got restricted __le16 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1966:27: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1966:27:    expected unsigned short [unsigned] [usertype] mb10
   drivers/scsi/qla2xxx/qla_iocb.c:1966:27:    got restricted __le16 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1968:26: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1968:26:    expected unsigned short [unsigned] [usertype] mb1
   drivers/scsi/qla2xxx/qla_iocb.c:1968:26:    got restricted __le16 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1970:18: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1970:18:    expected unsigned short [unsigned] [usertype] mb2
   drivers/scsi/qla2xxx/qla_iocb.c:1970:18:    got restricted __le16 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1971:18: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1971:18:    expected unsigned short [unsigned] [usertype] mb3
   drivers/scsi/qla2xxx/qla_iocb.c:1971:18:    got restricted __le16 [usertype] <noident>
>> drivers/scsi/qla2xxx/qla_iocb.c:1972:18: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1972:18:    expected unsigned short [unsigned] [usertype] mb6
   drivers/scsi/qla2xxx/qla_iocb.c:1972:18:    got restricted __le16 [usertype] <noident>
   drivers/scsi/qla2xxx/qla_iocb.c:1973:18: sparse: too many warnings

vim +1972 drivers/scsi/qla2xxx/qla_iocb.c

5ff1d584 Andrew Vasquez 2010-05-04  1962  	SET_TARGET_ID(ha, mbx->loop_id, sp->fcport->loop_id);
5ff1d584 Andrew Vasquez 2010-05-04  1963  	mbx->mb0 = cpu_to_le16(MBC_GET_PORT_DATABASE);
5ff1d584 Andrew Vasquez 2010-05-04  1964  	if (HAS_EXTENDED_IDS(ha)) {
5ff1d584 Andrew Vasquez 2010-05-04  1965  		mbx->mb1 = cpu_to_le16(sp->fcport->loop_id);
5ff1d584 Andrew Vasquez 2010-05-04  1966  		mbx->mb10 = cpu_to_le16(BIT_0);
5ff1d584 Andrew Vasquez 2010-05-04  1967  	} else {
5ff1d584 Andrew Vasquez 2010-05-04 @1968  		mbx->mb1 = cpu_to_le16((sp->fcport->loop_id << 8) | BIT_0);
5ff1d584 Andrew Vasquez 2010-05-04  1969  	}
5ff1d584 Andrew Vasquez 2010-05-04  1970  	mbx->mb2 = cpu_to_le16(MSW(ha->async_pd_dma));
5ff1d584 Andrew Vasquez 2010-05-04  1971  	mbx->mb3 = cpu_to_le16(LSW(ha->async_pd_dma));
5ff1d584 Andrew Vasquez 2010-05-04 @1972  	mbx->mb6 = cpu_to_le16(MSW(MSD(ha->async_pd_dma)));
5ff1d584 Andrew Vasquez 2010-05-04  1973  	mbx->mb7 = cpu_to_le16(LSW(MSD(ha->async_pd_dma)));
c6d39e23 Joe Carnuccio  2012-05-15  1974  	mbx->mb9 = cpu_to_le16(sp->fcport->vha->vp_idx);
5ff1d584 Andrew Vasquez 2010-05-04  1975  }

:::::: The code at line 1972 was first introduced by commit
:::::: 5ff1d58410ffb160b388d622ef0c6a0411a05559 [SCSI] qla2xxx: Limit mailbox command contention for ADISC requests.

:::::: TO: Andrew Vasquez <andrew.vasquez@qlogic.com>
:::::: CC: James Bottomley <James.Bottomley@suse.de>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
