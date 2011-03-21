From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Mon, 21 Mar 2011 10:09:04 +0900
Message-ID: <20110321100909E.fujita.tomonori@lab.ntt.co.jp>
References: <20110307134033K.fujita.tomonori@lab.ntt.co.jp>
	<1299508803.12730.1.camel@mulgrave.site>
	<4D83C78D.5040908@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:57344 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283Ab1CUBJW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Mar 2011 21:09:22 -0400
In-Reply-To: <4D83C78D.5040908@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@linux.vnet.ibm.com
Cc: James.Bottomley@suse.de, fujita.tomonori@lab.ntt.co.jp, nab@linux-iscsi.org, linux-scsi@vger.kernel.org

Thanks for the testings,

On Fri, 18 Mar 2011 15:58:53 -0500
Brian King <brking@linux.vnet.ibm.com> wrote:

> On 03/07/2011 08:40 AM, James Bottomley wrote:
> > On Mon, 2011-03-07 at 13:41 +0900, FUJITA Tomonori wrote:
> >> On Sat, 12 Feb 2011 14:27:26 -0600
> >> James Bottomley <James.Bottomley@suse.de> wrote:
> >>
> >>>> Disregard my previous comment. It looks like current client should handle reservations
> >>>> just fine without any further changes.
> >>>
> >>> So is that an ack for putting this in scsi-misc ... or did you want to
> >>> do more testing first?
> >>
> >> Ping,
> >>
> >> Brian, James, can we merge this during the next merge window?
> > 
> > I'm still waiting for an ack from Brian.
> 
> Sorry for the delay... I've got this loaded in the lab and have managed to oops
> a couple times. The first one was during shutdown, which I wasn't able to collect
> any data for. The most recent occurred when a client was trying to login for the
> first time:

You mean that the kernel crashes every time when a client logs in?
