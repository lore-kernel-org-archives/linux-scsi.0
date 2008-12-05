From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: oops in ibmvstgt
Date: Fri, 5 Dec 2008 22:26:03 +0900
Message-ID: <20081205221802G.fujita.tomonori@lab.ntt.co.jp>
References: <20081203145857.GA10070@suse.de>
	<20081204212414H.fujita.tomonori@lab.ntt.co.jp>
	<20081205105309.GA2198@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:42665 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbYLEN0L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2008 08:26:11 -0500
In-Reply-To: <20081205105309.GA2198@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olh@suse.de
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

On Fri, 5 Dec 2008 11:53:09 +0100
Olaf Hering <olh@suse.de> wrote:

> On Thu, Dec 04, FUJITA Tomonori wrote:
> 
> > On Wed, 3 Dec 2008 15:58:57 +0100
> > Olaf Hering <olh@suse.de> wrote:
> > 
> > > 
> > > change init order to fix crash due to uninitalized shost_data
> > 
> > I think that calling crq_queue_create leads to the creation of a rport
> > so we need to set up everything before that. The current code is racy.
> > 
> > 
> > > No idea if the patch is correct.
> > 
> > Almost correct, I think. Needs to modify the error handling
> > too. Probably, it would be better to call scsi_tgt_alloc_queue before
> > crq_queue_create.
> > 
> > How about this?
> 
> Yes, that works for me.

Thanks!

> Would be nice to get this into 2.6.28 to avoid a crash.

Yeah, hopefully we can. I'll resend this with a proper description.
