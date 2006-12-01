From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: Infinite retries reading the partition table
Date: Thu, 30 Nov 2006 22:34:57 -0800 (PST)
Message-ID: <117439.97789.qm@web31803.mail.mud.yahoo.com>
References: <20061130214716.6306a586.akpm@osdl.org>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31803.mail.mud.yahoo.com ([68.142.207.66]:5289 "HELO
	web31803.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1759172AbWLAGe5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Dec 2006 01:34:57 -0500
In-Reply-To: <20061130214716.6306a586.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

--- Andrew Morton <akpm@osdl.org> wrote:
> On Wed, 29 Nov 2006 17:22:48 -0800 (PST)
> Luben Tuikov <ltuikov@yahoo.com> wrote:
> 
> > Suppose reading sector 0 always reports an error,
> > sense key HARDWARE ERROR.
> > 
> > What I'm observing is that the request to read sector 0,
> > reading partition information, is retried forever, ad infinitum.
> > 
> > Does anyone have a patch to resolve this? (2.6.19-rc6)
> > 
> 
> Please send a backtrace so we can see where the offending loop occurs.

I posted a patch to linux-scsi which resolves this issue:
http://marc.theaimsgroup.com/?l=linux-scsi&m=116485834119885&w=2

     Luben

