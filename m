From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] SCSI midlayer power management
Date: 11 Aug 2004 08:39:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092231542.2087.7.camel@mulgrave>
References: <411960C3.5090107@optonline.net>
	<1092218000.18968.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:62861 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268060AbUHKNjH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Aug 2004 09:39:07 -0400
In-Reply-To: <1092218000.18968.2.camel@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Nathan Bryant <nbryant@optonline.net>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>, Jeff Garzik <jgarzik@pobox.com>

On Wed, 2004-08-11 at 04:53, Alan Cox wrote:
> That was something Mark Lord reported higher level I suspect - which is
> that the scsi path is disabled before the sync cache command is sent so
> the command is always errored before it hits the drive

Yes, this one's my fault.  I have patches to fix this, I never got
around to merging them.  Randy was on at me yesterday about this too. 
I'll dig them out.  (The problem is that last sync is sent in SDEV_DEL
state, so it gets rejected).

James


