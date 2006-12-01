From: Andrew Morton <akpm@osdl.org>
Subject: Re: Infinite retries reading the partition table
Date: Thu, 30 Nov 2006 23:29:16 -0800
Message-ID: <20061130232916.6cbd1408.akpm@osdl.org>
References: <20061130214716.6306a586.akpm@osdl.org>
	<117439.97789.qm@web31803.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34994 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S934293AbWLAH3S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Dec 2006 02:29:18 -0500
In-Reply-To: <117439.97789.qm@web31803.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Thu, 30 Nov 2006 22:34:57 -0800 (PST)
Luben Tuikov <ltuikov@yahoo.com> wrote:

> --- Andrew Morton <akpm@osdl.org> wrote:
> > On Wed, 29 Nov 2006 17:22:48 -0800 (PST)
> > Luben Tuikov <ltuikov@yahoo.com> wrote:
> > 
> > > Suppose reading sector 0 always reports an error,
> > > sense key HARDWARE ERROR.
> > > 
> > > What I'm observing is that the request to read sector 0,
> > > reading partition information, is retried forever, ad infinitum.
> > > 
> > > Does anyone have a patch to resolve this? (2.6.19-rc6)
> > > 
> > 
> > Please send a backtrace so we can see where the offending loop occurs.
> 
> I posted a patch to linux-scsi

hm.  Does sending patches to linux-scsi get them applied?  It might, I
don't know.

> which resolves this issue:
> http://marc.theaimsgroup.com/?l=linux-scsi&m=116485834119885&w=2

That looks like it prevents the IO error.  But why was an IO error causing
an infinite loop?   What piece of code was initiating the retries?

