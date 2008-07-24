From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: RE: [RFC PATCH] HP (Compaq) Smart Array 5xxx controller SCSI driver
Date: Thu, 24 Jul 2008 10:32:42 +0900
Message-ID: <20080724095325F.fujita.tomonori@lab.ntt.co.jp>
References: <0F5B06BAB751E047AB5C87D1F77A778826B3D60673@GVW0547EXC.americas.hpqcorp.net>
	<20080723223940S.tomof@acm.org>
	<0F5B06BAB751E047AB5C87D1F77A778826B3D60DE5@GVW0547EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:42050 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbYGXBdI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jul 2008 21:33:08 -0400
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A778826B3D60DE5@GVW0547EXC.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike.Miller@hp.com
Cc: fujita.tomonori@lab.ntt.co.jp, iss_storagedev@hp.com, James.Bottomley@HansenPartnership.com, Jens.Axboe@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 23 Jul 2008 14:07:39 +0000
"Miller, Mike (OS Dev)" <Mike.Miller@hp.com> wrote:

> > > > If I can get an ACK from HP about the long-term migration
> > of cciss
> > > > to SCSI, I'm happy to keep working on the SCSI cciss driver and
> > > > maintain it until HP takes over the driver.
> > >
> > > We already have a SCSI port of the driver that is at least as
> > > functional as you decribe. But I am against it's release for the
> > > reasons stated above. If we ever decide to release the SCSI port it
> > > should be developed by HP so we can be assured that the utils and
> > > agents work as expected. That doesn't mean we wouldn't
> > leverage some
> > > of your work. ;)
> >
> > If HP releases its SCSI driver, I'm happy to throw my driver
> > away and work on HP SCSI driver. I like to see a driver in
> > development rather than a finished driver; development in
> > mainline rather than private development at a vendor.
> > Everyone can see the progress and try it.
> 
> We'll post something sooner rather than later.

Nice! When are you likely to release the driver?

One thing that I'm interested in is how you map CCISS logical and
physical units to SCSI logical unit numbers. During writing a patch,
I've been thinking about what's the best way for users.


> I've been hesitant to submit unfinished work but I guess having the
> community provide input along the way is the best way to go.

Yeah, I'm happy to polish the driver even if I can't compile it.


> OK, Tomo, you win!   :)

Thanks a lot for agreeing to move the CCISS driver to SCSI!

I know that there are several other people who are really pleased with
the decision.
