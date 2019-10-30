Return-Path: <SRS0=//Xo=YX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E0ACA9EC7
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 22:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D42622087E
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 22:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbfJ3W4d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Oct 2019 18:56:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:6045 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727250AbfJ3W4d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Oct 2019 18:56:33 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Oct 2019 15:56:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,248,1569308400"; 
   d="scan'208";a="283698161"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 30 Oct 2019 15:56:29 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iPwtB-0001FD-BE; Thu, 31 Oct 2019 06:56:29 +0800
Date:   Thu, 31 Oct 2019 06:56:13 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     kbuild-all@lists.01.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH] scsi: Fix scsi_get/set_resid() interface
Message-ID: <201910310616.NvJqgsxM%lkp@intel.com>
References: <20191028105732.29913-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191028105732.29913-1-damien.lemoal@wdc.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Damien,

I love your patch! Perhaps something to improve:

[auto build test WARNING on scsi/for-next]
[cannot apply to v5.4-rc5 next-20191030]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Damien-Le-Moal/scsi-Fix-scsi_get-set_resid-interface/20191030-074824
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   drivers/usb/storage/ene_ub6250.c:2161:33: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] DataTransferLength @@    got e] DataTransferLength @@
   drivers/usb/storage/ene_ub6250.c:2161:33: sparse:    expected restricted __le32 [usertype] DataTransferLength
   drivers/usb/storage/ene_ub6250.c:2161:33: sparse:    got int
   drivers/usb/storage/ene_ub6250.c:2091:33: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] DataTransferLength @@    got e] DataTransferLength @@
   drivers/usb/storage/ene_ub6250.c:2091:33: sparse:    expected restricted __le32 [usertype] DataTransferLength
   drivers/usb/storage/ene_ub6250.c:2091:33: sparse:    got int
   drivers/usb/storage/ene_ub6250.c:1935:33: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] DataTransferLength @@    got unrestricted __le32 [usertype] DataTransferLength @@
   drivers/usb/storage/ene_ub6250.c:1935:33: sparse:    expected restricted __le32 [usertype] DataTransferLength
   drivers/usb/storage/ene_ub6250.c:1935:33: sparse:    got unsigned long const [usertype] size
   drivers/usb/storage/ene_ub6250.c:501:43: sparse: sparse: incorrect type in initializer (different base types) @@    expected unsigned int transfer_length @@    got restricted __le3unsigned int transfer_length @@
   drivers/usb/storage/ene_ub6250.c:501:43: sparse:    expected unsigned int transfer_length
   drivers/usb/storage/ene_ub6250.c:501:43: sparse:    got restricted __le32 [usertype] DataTransferLength
>> drivers/usb/storage/ene_ub6250.c:563:49: sparse: sparse: incompatible types in comparison expression (different signedness):
>> drivers/usb/storage/ene_ub6250.c:563:49: sparse:    unsigned int *
>> drivers/usb/storage/ene_ub6250.c:563:49: sparse:    int *
   drivers/usb/storage/ene_ub6250.c:702:33: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] DataTransferLength @@    got icted __le32 [usertype] DataTransferLength @@
   drivers/usb/storage/ene_ub6250.c:702:33: sparse:    expected restricted __le32 [usertype] DataTransferLength
   drivers/usb/storage/ene_ub6250.c:702:33: sparse:    got unsigned int [usertype] blenByte
   drivers/usb/storage/ene_ub6250.c:742:33: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] DataTransferLength @@    got icted __le32 [usertype] DataTransferLength @@
   drivers/usb/storage/ene_ub6250.c:742:33: sparse:    expected restricted __le32 [usertype] DataTransferLength
   drivers/usb/storage/ene_ub6250.c:742:33: sparse:    got unsigned int [usertype] blenByte
   drivers/usb/storage/ene_ub6250.c:888:33: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] DataTransferLength @@    got e] DataTransferLength @@
   drivers/usb/storage/ene_ub6250.c:888:33: sparse:    expected restricted __le32 [usertype] DataTransferLength
   drivers/usb/storage/ene_ub6250.c:888:33: sparse:    got int
   drivers/usb/storage/ene_ub6250.c:907:33: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] DataTransferLength @@    got e] DataTransferLength @@
   drivers/usb/storage/ene_ub6250.c:907:33: sparse:    expected restricted __le32 [usertype] DataTransferLength
   drivers/usb/storage/ene_ub6250.c:907:33: sparse:    got int
   drivers/usb/storage/ene_ub6250.c:953:18: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:953:18: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:953:18: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:953:18: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:973:34: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:973:34: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:973:34: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:973:34: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:974:41: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:974:41: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:974:41: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:974:41: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:975:41: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:975:41: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:975:41: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:975:41: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:978:26: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:978:26: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:978:26: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:978:26: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:992:31: sparse: sparse: cast to restricted __be32
   drivers/usb/storage/ene_ub6250.c:992:31: sparse: sparse: cast to restricted __be32
   drivers/usb/storage/ene_ub6250.c:992:31: sparse: sparse: cast to restricted __be32
   drivers/usb/storage/ene_ub6250.c:992:31: sparse: sparse: cast to restricted __be32
   drivers/usb/storage/ene_ub6250.c:992:31: sparse: sparse: cast to restricted __be32
   drivers/usb/storage/ene_ub6250.c:992:31: sparse: sparse: cast to restricted __be32
   drivers/usb/storage/ene_ub6250.c:996:29: sparse: sparse: cast to restricted __be32
   drivers/usb/storage/ene_ub6250.c:996:29: sparse: sparse: cast to restricted __be32
   drivers/usb/storage/ene_ub6250.c:996:29: sparse: sparse: cast to restricted __be32
   drivers/usb/storage/ene_ub6250.c:996:29: sparse: sparse: cast to restricted __be32
   drivers/usb/storage/ene_ub6250.c:996:29: sparse: sparse: cast to restricted __be32
   drivers/usb/storage/ene_ub6250.c:996:29: sparse: sparse: cast to restricted __be32
   drivers/usb/storage/ene_ub6250.c:1028:42: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:1028:42: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:1028:42: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:1028:42: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:1052:29: sparse: sparse: cast to restricted __le16
   drivers/usb/storage/ene_ub6250.c:1055:55: sparse: sparse: cast to restricted __le16
   drivers/usb/storage/ene_ub6250.c:1167:33: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] DataTransferLength @@    got e] DataTransferLength @@
   drivers/usb/storage/ene_ub6250.c:1167:33: sparse:    expected restricted __le32 [usertype] DataTransferLength
   drivers/usb/storage/ene_ub6250.c:1167:33: sparse:    got int
   drivers/usb/storage/ene_ub6250.c:1200:33: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] DataTransferLength @@    got e] DataTransferLength @@
   drivers/usb/storage/ene_ub6250.c:1200:33: sparse:    expected restricted __le32 [usertype] DataTransferLength
   drivers/usb/storage/ene_ub6250.c:1200:33: sparse:    got int
   drivers/usb/storage/ene_ub6250.c:1231:23: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:1231:23: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:1231:23: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:1231:23: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:1277:33: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] DataTransferLength @@    got e] DataTransferLength @@
   drivers/usb/storage/ene_ub6250.c:1277:33: sparse:    expected restricted __le32 [usertype] DataTransferLength
   drivers/usb/storage/ene_ub6250.c:1277:33: sparse:    got int
   drivers/usb/storage/ene_ub6250.c:1359:33: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] DataTransferLength @@    got e] DataTransferLength @@
   drivers/usb/storage/ene_ub6250.c:1359:33: sparse:    expected restricted __le32 [usertype] DataTransferLength
   drivers/usb/storage/ene_ub6250.c:1359:33: sparse:    got int
   drivers/usb/storage/ene_ub6250.c:1543:33: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] DataTransferLength @@    got e] DataTransferLength @@
   drivers/usb/storage/ene_ub6250.c:1543:33: sparse:    expected restricted __le32 [usertype] DataTransferLength
   drivers/usb/storage/ene_ub6250.c:1543:33: sparse:    got int
   drivers/usb/storage/ene_ub6250.c:1662:41: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] DataTransferLength @@    got icted __le32 [usertype] DataTransferLength @@
   drivers/usb/storage/ene_ub6250.c:1662:41: sparse:    expected restricted __le32 [usertype] DataTransferLength
   drivers/usb/storage/ene_ub6250.c:1662:41: sparse:    got unsigned int [usertype] blenByte
   drivers/usb/storage/ene_ub6250.c:1706:49: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] DataTransferLength @@    got e] DataTransferLength @@
   drivers/usb/storage/ene_ub6250.c:1706:49: sparse:    expected restricted __le32 [usertype] DataTransferLength
   drivers/usb/storage/ene_ub6250.c:1706:49: sparse:    got int
   drivers/usb/storage/ene_ub6250.c:1763:41: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] DataTransferLength @@    got icted __le32 [usertype] DataTransferLength @@
   drivers/usb/storage/ene_ub6250.c:1763:41: sparse:    expected restricted __le32 [usertype] DataTransferLength
   drivers/usb/storage/ene_ub6250.c:1763:41: sparse:    got unsigned int [usertype] blenByte
   drivers/usb/storage/ene_ub6250.c:1839:33: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] DataTransferLength @@    got e] DataTransferLength @@
   drivers/usb/storage/ene_ub6250.c:1839:33: sparse:    expected restricted __le32 [usertype] DataTransferLength
   drivers/usb/storage/ene_ub6250.c:1839:33: sparse:    got int
   drivers/usb/storage/ene_ub6250.c:1991:26: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:1991:26: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:1991:26: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:1991:26: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:1992:26: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:1992:26: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:1992:26: sparse: sparse: cast to restricted __be16
   drivers/usb/storage/ene_ub6250.c:1992:26: sparse: sparse: cast to restricted __be16

vim +563 drivers/usb/storage/ene_ub6250.c

41e568d14ec0ac huajun li    2011-03-04  492  
41e568d14ec0ac huajun li    2011-03-04  493  static int ene_send_scsi_cmd(struct us_data *us, u8 fDir, void *buf, int use_sg)
41e568d14ec0ac huajun li    2011-03-04  494  {
41e568d14ec0ac huajun li    2011-03-04  495  	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
41e568d14ec0ac huajun li    2011-03-04  496  	struct bulk_cs_wrap *bcs = (struct bulk_cs_wrap *) us->iobuf;
41e568d14ec0ac huajun li    2011-03-04  497  
41e568d14ec0ac huajun li    2011-03-04  498  	int result;
41e568d14ec0ac huajun li    2011-03-04  499  	unsigned int residue;
41e568d14ec0ac huajun li    2011-03-04  500  	unsigned int cswlen = 0, partial = 0;
41e568d14ec0ac huajun li    2011-03-04  501  	unsigned int transfer_length = bcb->DataTransferLength;
41e568d14ec0ac huajun li    2011-03-04  502  
191648d03d2022 Joe Perches  2013-04-19  503  	/* usb_stor_dbg(us, "transport --- ene_send_scsi_cmd\n"); */
41e568d14ec0ac huajun li    2011-03-04  504  	/* send cmd to out endpoint */
41e568d14ec0ac huajun li    2011-03-04  505  	result = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe,
41e568d14ec0ac huajun li    2011-03-04  506  					    bcb, US_BULK_CB_WRAP_LEN, NULL);
41e568d14ec0ac huajun li    2011-03-04  507  	if (result != USB_STOR_XFER_GOOD) {
191648d03d2022 Joe Perches  2013-04-19  508  		usb_stor_dbg(us, "send cmd to out endpoint fail ---\n");
41e568d14ec0ac huajun li    2011-03-04  509  		return USB_STOR_TRANSPORT_ERROR;
41e568d14ec0ac huajun li    2011-03-04  510  	}
41e568d14ec0ac huajun li    2011-03-04  511  
41e568d14ec0ac huajun li    2011-03-04  512  	if (buf) {
41e568d14ec0ac huajun li    2011-03-04  513  		unsigned int pipe = fDir;
41e568d14ec0ac huajun li    2011-03-04  514  
41e568d14ec0ac huajun li    2011-03-04  515  		if (fDir  == FDIR_READ)
41e568d14ec0ac huajun li    2011-03-04  516  			pipe = us->recv_bulk_pipe;
41e568d14ec0ac huajun li    2011-03-04  517  		else
41e568d14ec0ac huajun li    2011-03-04  518  			pipe = us->send_bulk_pipe;
41e568d14ec0ac huajun li    2011-03-04  519  
41e568d14ec0ac huajun li    2011-03-04  520  		/* Bulk */
41e568d14ec0ac huajun li    2011-03-04  521  		if (use_sg) {
41e568d14ec0ac huajun li    2011-03-04  522  			result = usb_stor_bulk_srb(us, pipe, us->srb);
41e568d14ec0ac huajun li    2011-03-04  523  		} else {
41e568d14ec0ac huajun li    2011-03-04  524  			result = usb_stor_bulk_transfer_sg(us, pipe, buf,
41e568d14ec0ac huajun li    2011-03-04  525  						transfer_length, 0, &partial);
41e568d14ec0ac huajun li    2011-03-04  526  		}
41e568d14ec0ac huajun li    2011-03-04  527  		if (result != USB_STOR_XFER_GOOD) {
191648d03d2022 Joe Perches  2013-04-19  528  			usb_stor_dbg(us, "data transfer fail ---\n");
41e568d14ec0ac huajun li    2011-03-04  529  			return USB_STOR_TRANSPORT_ERROR;
41e568d14ec0ac huajun li    2011-03-04  530  		}
41e568d14ec0ac huajun li    2011-03-04  531  	}
41e568d14ec0ac huajun li    2011-03-04  532  
41e568d14ec0ac huajun li    2011-03-04  533  	/* Get CSW for device status */
41e568d14ec0ac huajun li    2011-03-04  534  	result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe, bcs,
41e568d14ec0ac huajun li    2011-03-04  535  					    US_BULK_CS_WRAP_LEN, &cswlen);
41e568d14ec0ac huajun li    2011-03-04  536  
41e568d14ec0ac huajun li    2011-03-04  537  	if (result == USB_STOR_XFER_SHORT && cswlen == 0) {
191648d03d2022 Joe Perches  2013-04-19  538  		usb_stor_dbg(us, "Received 0-length CSW; retrying...\n");
41e568d14ec0ac huajun li    2011-03-04  539  		result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe,
41e568d14ec0ac huajun li    2011-03-04  540  					    bcs, US_BULK_CS_WRAP_LEN, &cswlen);
41e568d14ec0ac huajun li    2011-03-04  541  	}
41e568d14ec0ac huajun li    2011-03-04  542  
41e568d14ec0ac huajun li    2011-03-04  543  	if (result == USB_STOR_XFER_STALLED) {
41e568d14ec0ac huajun li    2011-03-04  544  		/* get the status again */
191648d03d2022 Joe Perches  2013-04-19  545  		usb_stor_dbg(us, "Attempting to get CSW (2nd try)...\n");
41e568d14ec0ac huajun li    2011-03-04  546  		result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe,
41e568d14ec0ac huajun li    2011-03-04  547  						bcs, US_BULK_CS_WRAP_LEN, NULL);
41e568d14ec0ac huajun li    2011-03-04  548  	}
41e568d14ec0ac huajun li    2011-03-04  549  
41e568d14ec0ac huajun li    2011-03-04  550  	if (result != USB_STOR_XFER_GOOD)
41e568d14ec0ac huajun li    2011-03-04  551  		return USB_STOR_TRANSPORT_ERROR;
41e568d14ec0ac huajun li    2011-03-04  552  
41e568d14ec0ac huajun li    2011-03-04  553  	/* check bulk status */
41e568d14ec0ac huajun li    2011-03-04  554  	residue = le32_to_cpu(bcs->Residue);
41e568d14ec0ac huajun li    2011-03-04  555  
f0183a338e4f90 Felipe Balbi 2016-04-18  556  	/*
f0183a338e4f90 Felipe Balbi 2016-04-18  557  	 * try to compute the actual residue, based on how much data
f0183a338e4f90 Felipe Balbi 2016-04-18  558  	 * was really transferred and what the device tells us
f0183a338e4f90 Felipe Balbi 2016-04-18  559  	 */
41e568d14ec0ac huajun li    2011-03-04  560  	if (residue && !(us->fflags & US_FL_IGNORE_RESIDUE)) {
41e568d14ec0ac huajun li    2011-03-04  561  		residue = min(residue, transfer_length);
41e568d14ec0ac huajun li    2011-03-04  562  		if (us->srb != NULL)
41e568d14ec0ac huajun li    2011-03-04 @563  			scsi_set_resid(us->srb, max(scsi_get_resid(us->srb),
41e568d14ec0ac huajun li    2011-03-04  564  								(int)residue));
41e568d14ec0ac huajun li    2011-03-04  565  	}
41e568d14ec0ac huajun li    2011-03-04  566  
41e568d14ec0ac huajun li    2011-03-04  567  	if (bcs->Status != US_BULK_STAT_OK)
41e568d14ec0ac huajun li    2011-03-04  568  		return USB_STOR_TRANSPORT_ERROR;
41e568d14ec0ac huajun li    2011-03-04  569  
41e568d14ec0ac huajun li    2011-03-04  570  	return USB_STOR_TRANSPORT_GOOD;
41e568d14ec0ac huajun li    2011-03-04  571  }
41e568d14ec0ac huajun li    2011-03-04  572  

:::::: The code at line 563 was first introduced by commit
:::::: 41e568d14ec0aca1b2bb19563517aad3b06d6805 Staging: Merge ENE UB6250 SD card codes from keucr to drivers/usb/storage

:::::: TO: huajun li <huajun.li.lee@gmail.com>
:::::: CC: Greg Kroah-Hartman <gregkh@suse.de>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
