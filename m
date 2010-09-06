From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Mon, 06 Sep 2010 06:39:38 -0400
Message-ID: <1283769578.15944.1293.camel@mulgrave.site>
References: <4C76CA57.3050405@vlnb.net>
	 <1282857806.32007.175.camel@haakon2.linux-iscsi.org>
	 <4C79484B.3090607@vlnb.net>
	 <1283028468.32007.357.camel@haakon2.linux-iscsi.org>
	 <4C7C18CE.5020103@vlnb.net>
	 <1283204792.32007.448.camel@haakon2.linux-iscsi.org>
	 <4C7FFD1A.8090509@vlnb.net>
	 <1283459158.5598.143.camel@haakon2.linux-iscsi.org>
	 <20100905201802.GC18411@core.coreip.homeip.net>
	 <1283723447.556.133.camel@haakon2.linux-iscsi.org>
	 <20100905234134.GA17212@core.coreip.homeip.net>
	 <1283731194.556.147.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46057 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab0IFKj4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Sep 2010 06:39:56 -0400
In-Reply-To: <1283731194.556.147.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Vladislav Bolkhovitin <vst@vlnb.net>, Dirk Meister <dmeister@uni-paderborn.de>, linux-scsi@vger.kernel.org, Chetan Loke <chetanloke@gmail.com>, Chetan Loke <generationgnu@yahoo.com>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Sun, 2010-09-05 at 16:59 -0700, Nicholas A. Bellinger wrote:
> On Sun, 2010-09-05 at 16:41 -0700, Dmitry Torokhov wrote:
> > On Sun, Sep 05, 2010 at 02:50:47PM -0700, Nicholas A. Bellinger wrote:
> > > Anyways, if we are going to compare SCM distributed vs. centralized
> > > workflow in terms of kernel projects, lets please at least compare
> > > apples to apples here.
> > > 
> > 
> > No, we should not be comparing SCMs at all here but rather 2 competing
> > implementations based on quality of the code. You tried to bring SMC
> > angle in and I am saying that it is BS.
> > 
> 
> Again, without getting into another pointless flamewar,  I think the
> main point here is that a open source project using a distributed
> workflow (like git) has major advantages when it comes to working with a
> larger group of developers than a centralized model (like SVN) does.
> 
> Because being a subsystem maintainer typically involves this type of
> complex workflow involving lots of different parties, git is a tool that
> was created (originally) expressely for a kernel workflow, and for those
> types of people it works really, really well.

Oh, for god's sake children.  Why does every LIO vs SCST discussion turn
into a pointless flameware over stuff no-one really cares about?  If
none of you has anything substantive to say: don't say it.

Since patches into SCSI go over the mailing list for review and
integration (and running checkpatch.pl on ... this would be a hint), I
don't really give a toss how they're generated.

> So, please understand that code and project workflow is only one of the
> reasons why TCM/LIO v4 was selected over SCST.

It isn't yet ... your code still has to be reviewed properly.  My
preferred reviewer is currently honing his skills on a diet of raw beef
in Argentina, but hopefully he'll get around to it shortly.

James


