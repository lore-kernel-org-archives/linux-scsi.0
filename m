From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH][RESEND]drivers/scsi/megaraid/megaraid_{mm,mbox}
Date: Mon, 16 May 2005 11:52:52 -0500
Message-ID: <1116262372.5040.37.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E570366289D@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:34478 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261742AbVEPQxD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2005 12:53:03 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570366289D@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <sju@lsil.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Mon, 2005-05-16 at 11:08 -0400, Ju, Seokmann wrote:
> Resending patch for megaraid driver.
> The patch has been recreated against 2.6.11.8.
> Please review the patch to previous driver.
> Attached file is same patch for convenience.

Look:

patching file Documentation/scsi/ChangeLog.megaraid
patching file drivers/scsi/megaraid/mega_common.h
patching file drivers/scsi/megaraid/megaraid_mbox.c
patching file drivers/scsi/megaraid/megaraid_mbox.h
patching file drivers/scsi/megaraid/megaraid_mm.c
Hunk #2 FAILED at 43.
Hunk #4 FAILED at 70.
Hunk #5 FAILED at 1217.
Hunk #6 FAILED at 1225.
Hunk #7 FAILED at 1246.
5 out of 7 hunks FAILED -- saving rejects to file
drivers/scsi/megaraid/megaraid_mm.c.rej
patching file drivers/scsi/megaraid/megaraid_mm.h


I'm getting tired of telling you this same patch doesn't apply. The
rejections are all in your compat_ioctl changes.

The removal of struct file * from your compat ioctl signature has
already been done ... it had to be otherwise the driver would have no
longer compiled.

Please get the latest kernel from kernel.org and prepare your patch
against that.

Thanks,

James


