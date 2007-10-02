From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [git patch] SCSI aic94xx fix
Date: Tue, 02 Oct 2007 14:04:58 -0500
Message-ID: <1191351898.3530.116.camel@localhost.localdomain>
References: <20071002172151.GA28579@havoc.gtf.org>
	 <1191350862.3530.114.camel@localhost.localdomain>
	 <470293C7.6080906@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755113AbXJBTFU@vger.kernel.org>
In-Reply-To: <470293C7.6080906@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2007-10-02 at 14:53 -0400, Jeff Garzik wrote:
> James Bottomley wrote:
> > Sure, I'll state my case:  This is a bug, but it has no affected users,
> > nor will it because the aic94xx doesn't work on non-x86 architectures by
> > reason of other longstanding bugs (and TODEVICE/FROMDEVICE only matters
> 
> False.  It fails to work on _some_ non-x86 platforms.

OK, it fails to work on everything I can test, which is parisc, ia64 and
ppc.  However, I'm fairly certain there are no other non-x86 users
because we have no bug reports.

James
