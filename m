From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH resend] bsg: Add support for submitting requests at
 tail of queue
Date: Tue, 24 Mar 2009 21:05:15 +0900
Message-ID: <20090324210440Z.fujita.tomonori@lab.ntt.co.jp>
References: <49C20CCD.5070607@panasas.com>
	<49C89CBC.7050306@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:50716 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866AbZCXMF5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Mar 2009 08:05:57 -0400
In-Reply-To: <49C89CBC.7050306@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, osd-dev@open-osd.org, dgilbert@interlog.com

On Tue, 24 Mar 2009 10:41:32 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> Boaz Harrosh wrote:
> > Hi Tomo Jens
> > 
> > Tomo you never ack-by on this patch. I absolutely needs this for the
> > user-mode API of osd-initiator. Which is needed with up-coming exofs
> > utilities.
> > 
> > What do you want to do?
> > 
> > Thanks 
> > 
> 
> Hi Jens.
> 
> I absolutely need this patch for 2.6.30 merge window. It is totally
> un-dangerous since defaults are left unchanged.

The question is we really need this feature or not. Though I guess
that we need to address this starvation issue.


> I need it because the user-mode utilities for osd and exofs that
> correspond to code in 2.6.30 will need this patch to compile,
> because they use a flag constant defined in this patch.

What do the user-mode utilities does for what?

You always say something like, "we need this for OSD, pNFS or
something". But I'm not sure you explain the detailed background.

A typical example is, why does the osd library export lots of
functions that exofs doesn't use with EXPORT_SYMBOL instead of
EXPORT_SYMBOL_GPL?
