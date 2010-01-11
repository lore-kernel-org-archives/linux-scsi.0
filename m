From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 0/6] qla2xxx: qla2xxx: fixes for 2.6.33-rc3 [8.03.02-k0]
Date: Mon, 11 Jan 2010 15:02:53 -0600
Message-ID: <1263243773.2799.359.camel@mulgrave.site>
References: <1263238337-363-1-git-send-email-giridhar.malavali@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:34337 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887Ab0AKVDB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jan 2010 16:03:01 -0500
In-Reply-To: <1263238337-363-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: giridhar.malavali@qlogic.com
Cc: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On Mon, 2010-01-11 at 11:32 -0800, giridhar.malavali@qlogic.com wrote:
> From: Giridhar Malavali <giridhar.malavali@qlogic.com>
> 
> James,
> 
> Please apply following patches.
> 
> Andrew Vasquez (2):
>   qla2xxx: Correct FCP2 recovery handling.
>   qla2xxx: Perform fast mailbox read  of flash regardless of size nor
>     address alignment.
> 
> Giridhar Malavali (2):
>   qla2xxx: Add BSG support for FC ELS/CT passthrough and vendor
>     commands.

This one.

>   qla2xxx: Update version number to 8.03.02-k0.
> 
> Harish Zunjarrao (1):
>   fc-transport: Use packed modifier for fc_bsg_request structure.
> 
> Joe Carnuccio (1):
>   qla2xxx: Enhance EEH support and enable AER support.

And this one

Don't remotely qualify as bug fixes.  How about redoing the series minus
these and it can go in rc-fixes (the other two can go in scsi-misc)?

James


