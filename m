From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: 2.6.24-rc5: tape drive not responding
Date: Mon, 17 Dec 2007 15:52:28 -0600
Message-ID: <1197928348.3204.14.camel@localhost.localdomain>
References: <18277.52079.718004.969358@stoffel.org>
	 <20071217112551H.fujita.tomonori@lab.ntt.co.jp>
	 <20071217031510.c3d500fd.akpm@linux-foundation.org>
	 <18278.55130.471797.398922@stoffel.org>
	 <18278.58314.892734.490418@stoffel.org>
	 <20071217134344.3f024461.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:49271 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753225AbXLQVwb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Dec 2007 16:52:31 -0500
In-Reply-To: <20071217134344.3f024461.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: John Stoffel <john@stoffel.org>, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>


On Mon, 2007-12-17 at 13:43 -0800, Andrew Morton wrote:
> On Mon, 17 Dec 2007 16:02:02 -0500
> "John Stoffel" <john@stoffel.org> wrote:
> 
> > 
> > Just to confirm, the propsed patch to st.c fixes the issue with
> > 2.6.24-rc5 as well at 2.6.24-rc5-mm1 with access to my DLT tape
> > drives.
> 
> err, what patch to st.c?

That's this one:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=acdd0b1c371b2fbb4b6110a51ba69cb0af9e6f45

> So it seems that 2.6.24 (and presumably 2.6.23?) need

Not 2.6.23 .. the scatterlist changes causing the st problems are local
to 2.6.24.

> 1: Alan's "initio: fix conflict when loading driver" (currently stocuk
>    in git-scsi-misc)

Yes, I'm moving this into scsi-rc-fixes

> 2: Boaz's "initio: initio_build_scb() fix" (my name for it)

And applying this ... although I'd still appreciate confirmation from
someone that the initio driver works after this.

> 3: The mystery st.c fix.
> 
> yes?

James


