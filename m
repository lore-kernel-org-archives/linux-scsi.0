From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: RE: HP (Compaq) Smart Array 5xxx controller SCSI driver
Date: Fri, 25 Jul 2008 00:06:38 +0900
Message-ID: <20080725000638Q.fujita.tomonori@lab.ntt.co.jp>
References: <20080724133012.GH8833@beardog.cca.cpqcorp.net>
	<20080724224438B.fujita.tomonori@lab.ntt.co.jp>
	<0F5B06BAB751E047AB5C87D1F77A778826B3DD7474@GVW0547EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:42985 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbYGXPMr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jul 2008 11:12:47 -0400
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A778826B3DD7474@GVW0547EXC.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike.Miller@hp.com
Cc: fujita.tomonori@lab.ntt.co.jp, scameron@beardog.cca.cpqcorp.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 24 Jul 2008 15:00:00 +0000
"Miller, Mike (OS Dev)" <Mike.Miller@hp.com> wrote:

> 
> > > As for the patches I mentioned which were previously ignored for
> > > improving how the current cciss SCSI code handled hot plogging, if
> > > you're curious about that, check here:
> > >
> > > http://marc.info/?l=linux-scsi&m=120213565000426&w=4
> > >
> > > A change like that becomes more important if logical drives are
> > > exposed through the scsi layer.
> >
> > We need to think about the best way to map (expose) logical
> > and physical drivers to SCSI luns. As I wrote before, I'm
> > interested in how HP SCSI driver does.
> 
> We don't neccesarily want or need to expose the physical disks. The only exception is disks that are not part of a logical volume. If the disks are part of a logical volume but exposed the user may shoot themselves in the foot by destroying the firmware metadata.

Oops, sorry, I meant physical tape drives.
