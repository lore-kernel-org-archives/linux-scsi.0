From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [git patch] SCSI aic94xx fix
Date: Tue, 02 Oct 2007 14:53:59 -0400
Message-ID: <470293C7.6080906@garzik.org>
References: <20071002172151.GA28579@havoc.gtf.org> <1191350862.3530.114.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:53655 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbXJBSyB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2007 14:54:01 -0400
In-Reply-To: <1191350862.3530.114.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

James Bottomley wrote:
> Sure, I'll state my case:  This is a bug, but it has no affected users,
> nor will it because the aic94xx doesn't work on non-x86 architectures by
> reason of other longstanding bugs (and TODEVICE/FROMDEVICE only matters

False.  It fails to work on _some_ non-x86 platforms.

	Jeff


