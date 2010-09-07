From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Tue, 7 Sep 2010 08:15:01 +0200
Message-ID: <AANLkTi=KTPMRQpdKihE=+otDUSDjPcjw2OeL8+V58k2o@mail.gmail.com>
References: <1283204792.32007.448.camel@haakon2.linux-iscsi.org>
	<4C7FFD1A.8090509@vlnb.net>
	<1283459158.5598.143.camel@haakon2.linux-iscsi.org>
	<20100905201802.GC18411@core.coreip.homeip.net>
	<1283723447.556.133.camel@haakon2.linux-iscsi.org>
	<20100905234134.GA17212@core.coreip.homeip.net>
	<1283731194.556.147.camel@haakon2.linux-iscsi.org>
	<1283769578.15944.1293.camel@mulgrave.site>
	<4C85617E.2080603@vlnb.net>
	<1283810135.556.238.camel@haakon2.linux-iscsi.org>
	<20100907004424.GB21430@core.coreip.homeip.net>
	<AANLkTikxeV3yVXcnKgZCiORyzZ8xR4Ydxf2rbquvRcJ=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59879 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab0IGGPC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2010 02:15:02 -0400
In-Reply-To: <AANLkTikxeV3yVXcnKgZCiORyzZ8xR4Ydxf2rbquvRcJ=@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chetan Loke <chetanloke@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Vladislav Bolkhovitin <vst@vlnb.net>, James Bottomley <James.Bottomley@suse.de>, Dirk Meister <dmeister@uni-paderborn.de>, linux-scsi@vger.kernel.org, Chetan Loke <generationgnu@yahoo.com>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Tue, Sep 7, 2010 at 5:45 AM, Chetan Loke <chetanloke@gmail.com> wrote:
> [ ... ]
>
> I would also appreciate an overview or a block diagram of how things
> work in LIO. I hope that's not too much to ask for? That way we can
> compare/contrast how things work from 10,000 feet level.
> I for one don't want to look at a single patch and comment -
> i) Oh, change this variable here because it doesn't follow linux coding style.
> ii) You dropped a lock in queue-cmd? Good. qla's driver has been doing
> it for sometime, no? So you could have just looked at that LLDD.
>
> Sorry, not trying to criticize anything but would like to offer my 2 cents too.

I agree with you. Not only the code of the two projects should be
reviewed but their respective designs should be reviewed too.

Bart.
