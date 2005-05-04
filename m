From: Anton Blanchard <anton@samba.org>
Subject: Re: LPFC issue with 2.6.12-rc3-git
Date: Wed, 4 May 2005 17:38:43 +1000
Message-ID: <20050504073843.GM13590@krispykreme>
References: <20050504055943.GL13590@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:24000 "EHLO ozlabs.org")
	by vger.kernel.org with ESMTP id S262059AbVEDHix (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2005 03:38:53 -0400
Content-Disposition: inline
In-Reply-To: <20050504055943.GL13590@krispykreme>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org


Hi James,

Im also getting these errors:

lpfc 0004:21:01.0: 0:0327 Rsp ring 0 error - command completion for iotag x0 not found
lpfc 0004:21:01.0: 0:0713 SCSI layer issued LUN reset (0, 0) Data: x2 x0 x0
lpfc 0004:21:01.0: 0:0317 Rsp ring 0 get: iotag x1700 greater then configured max x1000 wd0 x9032
lpfc 0004:21:01.0: 0:0327 Rsp ring 0 error -  command completion for iotag x0 not found
lpfc 0004:21:01.0: 0:0317 Rsp ring 0 get: iotag x1800 greater then configured max x1000 wd0 x9032

Which looks a lot like the problem last week which was solved with a
firmware update. I'll look into that.

In the end the partition locked up with the following backtrace:

d000000000078198 .lpfc_sli_validate_iocb_cmd+0x58/0xe0
d000000000079e80 .lpfc_sli_abort_iocb+0xd0/0x230
d000000000092e40 .lpfc_reset_bus_handler+0x210/0x470
c0000000002ee50c .scsi_try_bus_reset+0x7c/0x160
c0000000002ef774 .scsi_error_handler+0x924/0xb20
c000000000014988 .kernel_thread+0x4c/0x6c

Anton
