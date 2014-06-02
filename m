From: Christoph Hellwig <hch@lst.de>
Subject: Re: [next:master 9537/10000]
	drivers/scsi/be2iscsi/be_mgmt.c:182:21: sparse: incorrect type in
	assignment (different base types)
Date: Mon, 2 Jun 2014 13:06:59 +0200
Message-ID: <20140602110659.GA27504@lst.de>
References: <538740e7.5o0Xo7Ne05/hzB9g%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46508 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101AbaFBLHE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Jun 2014 07:07:04 -0400
Content-Disposition: inline
In-Reply-To: <538740e7.5o0Xo7Ne05/hzB9g%fengguang.wu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>, Minh Tran <minhduc.tran@emulex.com>, Christoph Hellwig <hch@lst.de>, kbuild-all@01.org, linux-scsi@vger.kernel.org

John,

can you please review the endianess annotations and byte swaps in be2scsi?

On Thu, May 29, 2014 at 10:15:03PM +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   07dd999f99b1135fdece697e17c4f4248ab40f72
> commit: 73af08e11c6638e2abd6b1fa13cdab58c2bbdbf8 [9537/10000] be2iscsi: Fix interrupt Coalescing mechanism.
> reproduce: make C=1 CF=-D__CHECK_ENDIAN__
> 
> 
> sparse warnings: (new ones prefixed by >>)
> 
> >> drivers/scsi/be2iscsi/be_mgmt.c:182:21: sparse: incorrect type in assignment (different base types)
>    drivers/scsi/be2iscsi/be_mgmt.c:182:21:    expected unsigned int [unsigned] [usertype] num_eq
>    drivers/scsi/be2iscsi/be_mgmt.c:182:21:    got restricted __le32 [usertype] <noident>
> >> drivers/scsi/be2iscsi/be_mgmt.c:184:37: sparse: incorrect type in assignment (different base types)
>    drivers/scsi/be2iscsi/be_mgmt.c:184:37:    expected unsigned int [unsigned] [usertype] eq_id
>    drivers/scsi/be2iscsi/be_mgmt.c:184:37:    got restricted __le32 [usertype] <noident>
> >> drivers/scsi/be2iscsi/be_mgmt.c:186:48: sparse: incorrect type in assignment (different base types)
>    drivers/scsi/be2iscsi/be_mgmt.c:186:48:    expected unsigned int [unsigned] [usertype] delay_multiplier
>    drivers/scsi/be2iscsi/be_mgmt.c:186:48:    got restricted __le32 [usertype] <noident>
>    drivers/scsi/be2iscsi/be_mgmt.c:309:20: sparse: incorrect type in assignment (different base types)
>    drivers/scsi/be2iscsi/be_mgmt.c:309:20:    expected unsigned int [unsigned] [usertype] pa_hi
>    drivers/scsi/be2iscsi/be_mgmt.c:309:20:    got restricted __le32 [usertype] <noident>
>    drivers/scsi/be2iscsi/be_mgmt.c:310:20: sparse: incorrect type in assignment (different base types)
>    drivers/scsi/be2iscsi/be_mgmt.c:310:20:    expected unsigned int [unsigned] [usertype] pa_lo
>    drivers/scsi/be2iscsi/be_mgmt.c:310:20:    got restricted __le32 [usertype] <noident>
>    drivers/scsi/be2iscsi/be_mgmt.c:311:18: sparse: incorrect type in assignment (different base types)
>    drivers/scsi/be2iscsi/be_mgmt.c:311:18:    expected unsigned int [unsigned] [usertype] len
>    drivers/scsi/be2iscsi/be_mgmt.c:311:18:    got restricted __le32 [usertype] <noident>
>    drivers/scsi/be2iscsi/be_mgmt.c:448:20: sparse: incorrect type in assignment (different base types)
>    drivers/scsi/be2iscsi/be_mgmt.c:448:20:    expected unsigned int [unsigned] [usertype] pa_hi
>    drivers/scsi/be2iscsi/be_mgmt.c:448:20:    got restricted __le32 [usertype] <noident>
>    drivers/scsi/be2iscsi/be_mgmt.c:449:20: sparse: incorrect type in assignment (different base types)
>    drivers/scsi/be2iscsi/be_mgmt.c:449:20:    expected unsigned int [unsigned] [usertype] pa_lo
>    drivers/scsi/be2iscsi/be_mgmt.c:449:20:    got restricted __le32 [usertype] <noident>
>    drivers/scsi/be2iscsi/be_mgmt.c:450:18: sparse: incorrect type in assignment (different base types)
>    drivers/scsi/be2iscsi/be_mgmt.c:450:18:    expected unsigned int [unsigned] [usertype] len
>    drivers/scsi/be2iscsi/be_mgmt.c:450:18:    got restricted __le32 [usertype] <noident>
>    drivers/scsi/be2iscsi/be_mgmt.c:538:24: sparse: incorrect type in assignment (different base types)
>    drivers/scsi/be2iscsi/be_mgmt.c:538:24:    expected unsigned int [unsigned] [usertype] pa_hi
>    drivers/scsi/be2iscsi/be_mgmt.c:538:24:    got restricted __le32 [usertype] <noident>
>    drivers/scsi/be2iscsi/be_mgmt.c:539:24: sparse: incorrect type in assignment (different base types)
>    drivers/scsi/be2iscsi/be_mgmt.c:539:24:    expected unsigned int [unsigned] [usertype] pa_lo
>    drivers/scsi/be2iscsi/be_mgmt.c:539:24:    got restricted __le32 [usertype] <noident>
>    drivers/scsi/be2iscsi/be_mgmt.c:540:22: sparse: incorrect type in assignment (different base types)
>    drivers/scsi/be2iscsi/be_mgmt.c:540:22:    expected unsigned int [unsigned] [usertype] len
>    drivers/scsi/be2iscsi/be_mgmt.c:540:22:    got restricted __le32 [usertype] <noident>
>    drivers/scsi/be2iscsi/be_mgmt.c:572:26: sparse: incorrect type in assignment (different base types)
>    drivers/scsi/be2iscsi/be_mgmt.c:572:26:    expected unsigned char [unsigned] [usertype] hdr_ring_id
>    drivers/scsi/be2iscsi/be_mgmt.c:572:26:    got restricted __le16 [usertype] <noident>
>    drivers/scsi/be2iscsi/be_mgmt.c:573:27: sparse: incorrect type in assignment (different base types)
>    drivers/scsi/be2iscsi/be_mgmt.c:573:27:    expected unsigned char [unsigned] [usertype] data_ring_id
>    drivers/scsi/be2iscsi/be_mgmt.c:573:27:    got restricted __le16 [usertype] <noident>
>    drivers/scsi/be2iscsi/be_mgmt.c:620:20: sparse: incorrect type in assignment (different base types)
>    drivers/scsi/be2iscsi/be_mgmt.c:620:20:    expected unsigned int [unsigned] [usertype] pa_hi
>    drivers/scsi/be2iscsi/be_mgmt.c:620:20:    got restricted __le32 [usertype] <noident>
>    drivers/scsi/be2iscsi/be_mgmt.c:621:20: sparse: incorrect type in assignment (different base types)
>    drivers/scsi/be2iscsi/be_mgmt.c:621:20:    expected unsigned int [unsigned] [usertype] pa_lo
>    drivers/scsi/be2iscsi/be_mgmt.c:621:20:    got restricted __le32 [usertype] <noident>
>    drivers/scsi/be2iscsi/be_mgmt.c:622:18: sparse: incorrect type in assignment (different base types)
>    drivers/scsi/be2iscsi/be_mgmt.c:622:18:    expected unsigned int [unsigned] [usertype] len
>    drivers/scsi/be2iscsi/be_mgmt.c:622:18:    got restricted __le32 [usertype] <noident>
>    drivers/scsi/be2iscsi/be_mgmt.c:755:43: sparse: restricted __be32 degrades to integer
>    drivers/scsi/be2iscsi/be_mgmt.c:756:44: sparse: restricted __be32 degrades to integer
>    drivers/scsi/be2iscsi/be_mgmt.c:757:44: sparse: restricted __be32 degrades to integer
>    drivers/scsi/be2iscsi/be_mgmt.c:758:44: sparse: restricted __be32 degrades to integer
>    drivers/scsi/be2iscsi/be_mgmt.c:760:38: sparse: incorrect type in assignment (different base types)
>    drivers/scsi/be2iscsi/be_mgmt.c:760:38:    expected unsigned long [unsigned] dst_addr
>    drivers/scsi/be2iscsi/be_mgmt.c:760:38:    got restricted __be32 [usertype] s_addr
>    drivers/scsi/be2iscsi/be_mgmt.c:794:20: sparse: incorrect type in assignment (different base types)
>    drivers/scsi/be2iscsi/be_mgmt.c:794:20:    expected unsigned int [unsigned] [usertype] pa_hi
>    drivers/scsi/be2iscsi/be_mgmt.c:794:20:    got restricted __le32 [usertype] <noident>
>    drivers/scsi/be2iscsi/be_mgmt.c:795:20: sparse: incorrect type in assignment (different base types)
>    drivers/scsi/be2iscsi/be_mgmt.c:795:20:    expected unsigned int [unsigned] [usertype] pa_lo
>    drivers/scsi/be2iscsi/be_mgmt.c:795:20:    got restricted __le32 [usertype] <noident>
>    drivers/scsi/be2iscsi/be_mgmt.c:796:18: sparse: incorrect type in assignment (different base types)
>    drivers/scsi/be2iscsi/be_mgmt.c:796:18:    expected unsigned int [unsigned] [usertype] len
>    drivers/scsi/be2iscsi/be_mgmt.c:796:18:    got restricted __le32 [usertype] <noident>
>    drivers/scsi/be2iscsi/be_mgmt.c:861:20: sparse: incorrect type in assignment (different base types)
>    drivers/scsi/be2iscsi/be_mgmt.c:861:20:    expected unsigned int [unsigned] [usertype] pa_hi
>    drivers/scsi/be2iscsi/be_mgmt.c:861:20:    got restricted __le32 [usertype] <noident>
>    drivers/scsi/be2iscsi/be_mgmt.c:862:20: sparse: incorrect type in assignment (different base types)
>    drivers/scsi/be2iscsi/be_mgmt.c:862:20:    expected unsigned int [unsigned] [usertype] pa_lo
>    drivers/scsi/be2iscsi/be_mgmt.c:862:20:    got restricted __le32 [usertype] <noident>
>    drivers/scsi/be2iscsi/be_mgmt.c:863:18: sparse: incorrect type in assignment (different base types)
>    drivers/scsi/be2iscsi/be_mgmt.c:863:18:    expected unsigned int [unsigned] [usertype] len
>    drivers/scsi/be2iscsi/be_mgmt.c:863:18:    got restricted __le32 [usertype] <noident>
> 
> vim +182 drivers/scsi/be2iscsi/be_mgmt.c
> 
>    176	
>    177		wrb->tag0 |= tag;
>    178		be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
>    179		be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_COMMON,
>    180			OPCODE_COMMON_MODIFY_EQ_DELAY, sizeof(*req));
>    181	
>  > 182		req->num_eq = cpu_to_le32(num);
>    183		for (i = 0; i < num; i++) {
>    184			req->delay[i].eq_id = cpu_to_le32(set_eqd[i].eq_id);
>    185			req->delay[i].phase = 0;
>    186			req->delay[i].delay_multiplier =
>    187					cpu_to_le32(set_eqd[i].delay_multiplier);
>    188		}
>    189	
> 
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
---end quoted text---
