From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi_lib.c: avoid max_hw_segments warning
Date: Mon, 11 Dec 2006 10:23:46 -0600
Message-ID: <1165854226.2791.4.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.64.0612081206300.21386@halbrend.uninett.no>
	 <Pine.LNX.4.58.0612081356540.6702@xplor.biophys.uni-duesseldorf.de>
	 <Pine.LNX.4.62.0612081433590.17313@pademelon.sonytel.be>
	 <Pine.LNX.4.58.0612081601080.7221@xplor.biophys.uni-duesseldorf.de>
	 <Pine.LNX.4.58.0612111351020.29925@xplor.biophys.uni-duesseldorf.de>
	 <Pine.LNX.4.62.0612111414140.1150@pademelon.sonytel.be>
	 <Pine.LNX.4.58.0612111704370.30544@xplor.biophys.uni-duesseldorf.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:50810 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936997AbWLKQX7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Dec 2006 11:23:59 -0500
In-Reply-To: <Pine.LNX.4.58.0612111704370.30544@xplor.biophys.uni-duesseldorf.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
Cc: jejb@SteelEye.com, Geert Uytterhoeven <geert@linux-m68k.org>, linux-scsi@vger.kernel.org

On Mon, 2006-12-11 at 17:09 +0100, Michael Schmitz wrote:
> Hi,
> 
> as per request by Geert Uytterhoeven: the patch below avoids a warning in
> blk_queue_max_hw_segments(), caused by a SCSI host adapter using SG_NONE.
> Please apply.

Actually, isn't the correct fix to change SG_NONE to 1?

We're deprecating the non-sg paths, however use_sg == 1 is equivalent to
use_sg==0, you just set it up differently.

James


