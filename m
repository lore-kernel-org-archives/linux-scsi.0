From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Mon, 21 Mar 2011 14:01:31 -0700
Message-ID: <1300741291.21880.17.camel@haakon2.linux-iscsi.org>
References: <20110307134033K.fujita.tomonori@lab.ntt.co.jp>
	 <1299508803.12730.1.camel@mulgrave.site>
	 <4D83C78D.5040908@linux.vnet.ibm.com>
	 <20110321100909E.fujita.tomonori@lab.ntt.co.jp>
	 <4D87BC8C.5090104@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:35482 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab1CUVIm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2011 17:08:42 -0400
In-Reply-To: <4D87BC8C.5090104@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@suse.de, linux-scsi@vger.kernel.org

On Mon, 2011-03-21 at 16:01 -0500, Brian King wrote:
> On 03/20/2011 08:09 PM, FUJITA Tomonori wrote:
> > Thanks for the testings,
> > 
> > On Fri, 18 Mar 2011 15:58:53 -0500
> > Brian King <brking@linux.vnet.ibm.com> wrote:
> > 
> >> On 03/07/2011 08:40 AM, James Bottomley wrote:
> >>> On Mon, 2011-03-07 at 13:41 +0900, FUJITA Tomonori wrote:
> >>>> On Sat, 12 Feb 2011 14:27:26 -0600
> >>>> James Bottomley <James.Bottomley@suse.de> wrote:
> >>>>
> >>>>>> Disregard my previous comment. It looks like current client should handle reservations
> >>>>>> just fine without any further changes.
> >>>>>
> >>>>> So is that an ack for putting this in scsi-misc ... or did you want to
> >>>>> do more testing first?
> >>>>
> >>>> Ping,
> >>>>
> >>>> Brian, James, can we merge this during the next merge window?
> >>>
> >>> I'm still waiting for an ack from Brian.
> >>
> >> Sorry for the delay... I've got this loaded in the lab and have managed to oops
> >> a couple times. The first one was during shutdown, which I wasn't able to collect
> >> any data for. The most recent occurred when a client was trying to login for the
> >> first time:
> > 
> > You mean that the kernel crashes every time when a client logs in?
> 
> I think the crash I was seeing when the client logs in was just due to the fact that
> I had things misconfigured. It took me a bit to figure out the configfs stuff. Didn't
> realize at first I had to go off and manually create a lot of the configfs layout
> described in the wiki page. Once I did that, I was able to get a LUN to successfully
> report in on the client side. I'll start pounding on this a bit and see how things
> hold up.
> 

Hi Brian,

If could send along the original misconfigured configfs layout that is
causing the OOPs in handle_crq(), I would be happy to have a quick look.

Thank you,

--nab

