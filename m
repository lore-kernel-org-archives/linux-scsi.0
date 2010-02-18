From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 0/8] qla2xxx: fixes for 2.6.33-rcX [8.03.02-k1]
Date: Thu, 18 Feb 2010 10:42:48 -0600
Message-ID: <1266511368.4355.44.camel@mulgrave.site>
References: <1266511114-307-1-git-send-email-giridhar.malavali@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42347 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758079Ab0BRQm4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2010 11:42:56 -0500
In-Reply-To: <1266511114-307-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: giridhar.malavali@qlogic.com
Cc: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On Thu, 2010-02-18 at 08:38 -0800, giridhar.malavali@qlogic.com wrote:
> From: Giridhar Malavali <giridhar.malavali@qlogic.com>
> 
> James,
> 
> Please apply..

You're very late for this.  I was stabilising the final fixes in
linux-next to send on tomorrow ... assuming Linus plans a Saturday
release, so it might be better just to add cc: stable tags and put them
in scsi-misc.

> Andrew Vasquez (4):
>   qla2xxx: Correct EH bus-reset handling.
>   qla2xxx: Correct use-after-free issue in terminate_rport_io callback.
>   qla2xxx: Correct loop-resync issues during SNS scans.
>   qla2xxx: Add firmware ETS burst support.

How is that last one a bug fix?

James


