From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source device
	driver for new sequence firmware.
Date: Sat, 03 Feb 2007 16:28:43 -0600
Message-ID: <1170541723.3345.64.camel@mulgrave.il.steeleye.com>
References: <89FD792A883D4B47AD469FEA2E5D1F9B0F59B6@aime2k302.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:43295 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751626AbXBCW2v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Feb 2007 17:28:51 -0500
In-Reply-To: <89FD792A883D4B47AD469FEA2E5D1F9B0F59B6@aime2k302.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Wu, Gilbert" <Gilbert_Wu@adaptec.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2007-01-30 at 15:31 -0800, Wu, Gilbert wrote:
> Subject:  [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source device
> driver for new sequence firmware.

I put the patch, which seems fine, into scsi-misc-2.6; however, it looks
like the firmware isn't fine.  With the V28 firmware I get instability
on my directly attached SATA disk.  It begins about three minutes into a
small exercise of the filesystem on the disk as:

Feb  3 16:13:50 localhost kernel: sas: command 0xf7aca994, task
0x00000000, gone: EH_RESET_TIMER

and then times out commands and eventually flips ext3 into read only
mode because of the errors.

If I run the same tests with the V17/10c6 firmware, everything runs fine
and to completion.

James


