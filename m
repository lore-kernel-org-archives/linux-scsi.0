From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Commit a692b0e broke my mvsas card
Date: Tue, 17 Apr 2012 19:47:17 +0400
Message-ID: <1334677637.3766.66.camel@dabdike>
References: <20120416224250.GA1983@bill-the-cat>
	 <CABE8wwvbSsc02U_m+20-DQgsZ2gQCi_A6susCrmfyx_scQkccw@mail.gmail.com>
	 <4F8CAC6F.6070907@ti.com>
	 <1334620782.23541.2.camel@ultramagnus.opencreations.com>
	 <4F8CCD0C.5060900@ti.com> <1334633159.13899.4.camel@dwillia2-mobl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37875 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756267Ab2DQPrX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Apr 2012 11:47:23 -0400
In-Reply-To: <1334633159.13899.4.camel@dwillia2-mobl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Tom Rini <trini@ti.com>, linux-scsi@vger.kernel.org, Xiangliang Yu <yuxiangl@marvell.com>

On Mon, 2012-04-16 at 20:25 -0700, Dan Williams wrote:
> On Mon, 2012-04-16 at 18:53 -0700, Tom Rini wrote:
> > > Thanks, yes it looks like a new regression.  Can you tell me if the
> > > following fixes it?
> > 
> > No joy, oopses.  http://alnk.org/43youngkirby for the dmesg and oops.
> > 
> 
> Agh, sorry, I rushed that one.  The phy array is initialized later, here
> is another run at it:

Are we sure it's initialised correctly in all the other SAS drivers that
use (well, one other: aic94xx)?

Given the oops issue, perhaps revert this for now and get a working
patch in for the next merge window?

James


