From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] SCSI: Make error printing more user friendly
Date: Mon, 19 Feb 2007 10:43:09 -0500
Message-ID: <yq1k5yeqhki.fsf@sermon.lab.mkp.net>
References: <yq1hctvycyg.fsf@sermon.lab.mkp.net>
	<1171638659.3443.8.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:50839 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368AbXBSPnr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Feb 2007 10:43:47 -0500
In-Reply-To: <1171638659.3443.8.camel@mulgrave.il.steeleye.com> (James Bottomley's message of "Fri, 16 Feb 2007 09:10:59 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@SteelEye.com> writes:

James> I think we should be going through dev_printk as the primary,
James> particularly as doing this would make the output of sdev_printk
James> different from scmd_printk.  How about

Fine with me except we're now back to having inconsistent prefixes for
the result printing and the matching sense data.

I'll try to sanitize the sense printing too and post a new patch.


James> The other nasty is that we can't actually deref rq_disk unless
James> <linux/blkdev.h> is included.  You'll find megaraid_sas.c fails
James> to compile becuase of this.  It can probably be fixed by
James> including blkdev.h from scsi_device.h

You must have had a reject on scsi_device.h.  My patch did include
<linux/blkdev.h> to fix that very issue.

-- 
Martin K. Petersen	Oracle Linux Engineering

