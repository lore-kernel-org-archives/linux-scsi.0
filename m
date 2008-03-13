From: Ulrich Schweitzer <us-@gmx.de>
Subject: Re: [Bugme-new] [Bug 10226] New: BusLogic Flashpoint SCSI Adapter not working with x86_64 kernels
Date: Thu, 13 Mar 2008 07:09:43 +0100
Message-ID: <200803130709.44066.us-@gmx.de>
References: <bug-10226-10286@http.bugzilla.kernel.org/> <200803122125.50161.us-@gmx.de> <1205357733.2941.160.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60878 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750875AbYCMGJx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Mar 2008 02:09:53 -0400
In-Reply-To: <1205357733.2941.160.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On Wednesday March 12 2008, James Bottomley wrote:
> On Wed, 2008-03-12 at 21:25 +0100, Ulrich Schweitzer wrote:
> > Sorry for straying off topic, but this has to be the right crowd to ask:
> > I assume that the driver won't be ported to x86_64 soon (if ever),
>
> Not unless someone volunteers, but FlashPoint.c is huge.

If its not going to be ported, I guess we should add a sentence to the help 
text of CONFIG_SCSI_BUSLOGIC so people like me don't think its a bug. 
Something like "Flashpoint Host Adapter support is only available on x86 but 
not on x86_64 systems."
Would one of you please submit such a patch? I've never submitted a kernel 
patch and don't know how to do it.

Ulrich
