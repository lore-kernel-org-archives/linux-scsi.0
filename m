From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [patchset 0/33] scsi_data_buffer for after the last driver is
 converted
Date: Thu, 18 Oct 2007 08:32:28 +0900
Message-ID: <20071018083228C.fujita.tomonori@lab.ntt.co.jp>
References: <47164306.6090702@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:49692 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759260AbXJQXrY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 19:47:24 -0400
In-Reply-To: <47164306.6090702@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: James.Bottomley@SteelEye.com, jens.axboe@oracle.com, tomof@acm.org, matthew@wil.cx, mdharm-scsi@one-eyed-alien.net, rmk@arm.linux.org.uk, stern@rowland.harvard.edu, davem@davemloft.net, hch@infradead.org, linux-scsi@vger.kernel.org, jeff@garzik.org, bhalevy@panasas.com, pw@osc.edu

On Wed, 17 Oct 2007 19:14:46 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> This is a resend of all the remaining drivers rebased
> to latest code. And once the entire tree is converted,
> move to scsi_data_buffer in scsi_cmnd.
> 
> The work is on top of Jens's for-linus branch which
> is effectively sglist-arch (+ last minute fixes)
> This is because sglist-arch was already rebased to
> latest scsi-misc through linus tree, merged with 
> the extra work done there on scsi-ml (and the drivers)
> (Thanks Jens)
> 
> summery of patches:
> 
> left over from scsi_eh last change
>   [PATCH 01/32] arm: fas216 Use scsi_eh API for REQUEST_SENSE invocation
> 
> lots and lots of drivers left:
>   [PATCH 02/32] isd200.c: use one-element sg list in issuing commands
>   [PATCH 03/32] usb: transport - convert to accessors and !use_sg code path removal
>   [PATCH 04/32] usb: protocol.c - convert to accessors and !use_sg code path removal
>   [PATCH 05/32] usb: shuttle_usbat.c - convert to accessors and !use_sg code path removal
>   [PATCH 06/32] usb: freecom.c & sddr09.c - convert to accessors and !use_sg cleanup
>   [PATCH 07/32] NCR5380 familly convert to accessors & !use_sg cleanup
>   [PATCH 08/32] arm: scsi convert to accessors and !use_sg cleanup
>   [PATCH 09/32] nsp_cs.c convert to data accessors and !use_sg cleanup
>   [PATCH 10/32] eata_pio.c: convert to accessors and !use_sg cleanup
>   [PATCH 11/32] a2091.c: convert to accessors and !use_sg cleanup
>   [PATCH 12/32] a3000.c: convert to accessors and !use_sg cleanup
>   [PATCH 13/32] aha1542.c: convert to accessors and !use_sg cleanup
>   [PATCH 14/32] atp870u.c: convert to accessors and !use_sg cleanup
>   [PATCH 15/32] fd_mcs.c: convert to accessors and !use_sg cleanup
>   [PATCH 16/32] imm.c: convert to accessors and !use_sg cleanup
>   [PATCH 17/32] ppa.c: convert to accessors and !use_sg cleanup
>   [PATCH 18/32] wd32c93.c: convert to accessors and !use_sg cleanup
>   [PATCH 19/32] qlogicpti.c: convert to accessors and !use_sg cleanup
>   [PATCH 20/32] in2000.c: convert to accessors and !use_sg cleanup
>   [PATCH 21/32] scsi_debug: convert to use the data buffer accessors
> 
> Tomo's patch cleaned up:
>    [PATCH 22/32] qla1280: convert to use the data buffer accessors
>    [PATCH 23/32] qla1280: Indentation fix
> 
>  I separated the indentation from the real change make
>  the patch humanly readable.

It doesn't hurt but I'm not sure how useful the separation is.

