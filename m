From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch] ibmvscsi.c: limit size of I/O requests, updated
Date: Fri, 31 Dec 2004 13:10:40 -0600
Message-ID: <1104520241.5247.13.camel@mulgrave>
References: <20041129203107.GB31011@cs.umn.edu>
	 <20041231174745.GA10894@cs.umn.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:39095 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261734AbULaTL3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Dec 2004 14:11:29 -0500
In-Reply-To: <20041231174745.GA10894@cs.umn.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: boutcher@cs.umn.edu
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2004-12-31 at 11:47 -0600, Dave C Boutcher wrote:
> Description: Limit the size of I/O requests sent by the 
> ibmvscsi adapter.  With better I/O scheduling (and thus larger
> requests) we were breaking some servers.
> 
> Updated based on comments from Jens Axboe and James
> Bottomley to not specify max I/O sectors as a module
> parameter, and subsequently not needlessly store
> the value as a static variable.

Got it, thanks (you don't actually have to summarise the argument,
merely describe the current patch).

Can you look at the scsi-misc-2.6 tree (or the current BK head plus the
scsi-misc-2.6 patch from http://parisc-linux.org/~jejb/scsi_diffs/) and
tell me what (if anything) I'm still missing?

Thanks,

James

