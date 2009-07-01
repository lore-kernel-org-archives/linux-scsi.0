From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: can't access LUN >2TB with aic7xxx, Infortrend EonStor and
 2.6.31-rc1
Date: Wed, 01 Jul 2009 09:19:31 -0500
Message-ID: <1246457971.3894.23.camel@mulgrave.site>
References: <20090629130835.GA3657@mother.pipebreaker.pl>
	 <20090629133431.GM5480@parisc-linux.org>
	 <20090629134602.GN5480@parisc-linux.org>
	 <20090630094046.GE3657@mother.pipebreaker.pl>
	 <1246376899.3816.60.camel@mulgrave.site>
	 <20090701061011.GG3657@mother.pipebreaker.pl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39986 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751839AbZGAOTb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2009 10:19:31 -0400
In-Reply-To: <20090701061011.GG3657@mother.pipebreaker.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomasz Torcz <tomek@pipebreaker.pl>
Cc: linux-scsi@vger.kernel.org

On Wed, 2009-07-01 at 08:10 +0200, Tomasz Torcz wrote:
>   Still not good:
> sd 6:0:0:0: Attached scsi generic sg2 type 0
> sd 6:0:0:1: Attached scsi generic sg3 type 0
> sd 6:0:0:0: [sdc] Spinning up disk...
> sd 6:0:0:1: [sdd] Spinning up disk........ready
> sd 6:0:0:0: [sdc] Very big device. Trying to use READ CAPACITY(16).
> (scsi6:A:0:0): No or incomplete CDB sent to device.
> (scsi6:A:0:0): Protocol violation in Message-in phase.  Attempting to abort.
> (scsi6:A:0:0): Abort Tag Message Sent
> (scsi6:A:0:0): SCB 2 - Abort Tag Completed.
> (scsi6:A:0:0): No or incomplete CDB sent to device.
> (scsi6:A:0:0): Protocol violation in Message-in phase.  Attempting to abort.
> (scsi6:A:0:0): Abort Tag Message Sent
> (scsi6:A:0:0): SCB 3 - Abort Tag Completed.
> 
> 
>  ... and so on.
>  Maybe this HBA is too old? Newest BIOS for it is from year 2000. I've checked
> another controller, sym53c8xx driven, it shows 3,5TB briefly before reverting to 2TB,
> so array itself is reporting OK.

OK ... I'll look again.  The only doc I have for this is a 1998 HIM
guide for the u160 chip, so it's possible earlier versions didn't
support the >12 CDBs but I'd expect a field warning in that case and I
don't see one.

Chances are there's simply another issue in the driver that I haven't
seen yet.

James


