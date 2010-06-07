From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/3] Add proper STGT <-> bs_sg passthrough v3
Date: Mon, 07 Jun 2010 02:40:52 -0700
Message-ID: <1275903652.26888.73.camel@haakon2.linux-iscsi.org>
References: <1275899236.26888.40.camel@haakon2.linux-iscsi.org>
	 <20100607175535Q.fujita.tomonori@lab.ntt.co.jp>
	 <1275901629.26888.62.camel@haakon2.linux-iscsi.org>
	 <20100607183438Y.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:32332 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752118Ab0FGJkz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2010 05:40:55 -0400
In-Reply-To: <20100607183438Y.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stgt@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, michaelc@cs.wisc.edu, bharrosh@panasas.com, James.Bottomley@suse.de, dgilbert@interlog.com

On Mon, 2010-06-07 at 18:35 +0900, FUJITA Tomonori wrote:
> On Mon, 07 Jun 2010 02:07:09 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > On Mon, 2010-06-07 at 17:56 +0900, FUJITA Tomonori wrote:
> > > On Mon, 07 Jun 2010 01:27:16 -0700
> > > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > > 
> > > > Ok, I just fixed some minor breakage and applied patch 3 on top of
> > > > tgt.git/pass in my local tree and everything appears to work with
> > > > '-E bsg -Y pt'.
> > > > 
> > > > Please let me know if you have any other comments on the BSG bits or if
> > > > you would like me to send along a updated patch 3 seperately.
> > > 
> > > Please send patches except for bsg first.
> > > 
> > > About bsg support, we need both sg and bsg? Just bsg is not enough?
> > 
> > I figured you would still like legacy support w/o bsg for the forseeable
> > future with older production kernels.  I don't recall which kernel BSG
> > support was added or if this code has already been backported to the
> > various distro kernels.
> 
> I prefer to support only bsg (until someone tells me to support sg).
> 

Ok, if that is the case I will respin a patch on top of tgt.git/pass to
remove SG and use BSG exclusively.  Please let me know if you have any
more recommendations in this area.

> 
> btw, if you look for a tool to generate a bidi command, my sgv4-tools
> might work for you.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/sgv4-tools.git
> 
> try sgv4_xdwriteread (note that it's not useful at all except for
> generating bidi).

Ah perfect, this is exactly what I am looking for.  Many thanks.

Best,

--nab

