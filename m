From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: INITIO scsi driver fails to work properly
Date: Fri, 11 Jan 2008 11:33:25 -0600
Message-ID: <1200072805.3286.34.camel@localhost.localdomain>
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>
	 <9f00bd9d0712190048g60d79ma067ba85b5553459@mail.gmail.com>
	 <476C1472.1040103@redhat.com>
	 <1198271036.3130.60.camel@localhost.localdomain>
	 <476C4177.3030902@redhat.com>
	 <1198277391.3130.73.camel@localhost.localdomain>
	 <9f00bd9d0801031618l324e9078i56b0679a35e27f69@mail.gmail.com>
	 <1200028577.5337.8.camel@localhost.localdomain>
	 <9f00bd9d0801110154i3b2f9c1flf076823747950196@mail.gmail.com>
	 <1200066295.3286.19.camel@localhost.localdomain>
	 <9f00bd9d0801110844g176acdcdle0331783f82ed866@mail.gmail.com>
	 <20080111170122.33b16e9a@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43515 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760731AbYAKRdb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jan 2008 12:33:31 -0500
In-Reply-To: <20080111170122.33b16e9a@lxorguk.ukuu.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Filippos Papadopoulos <psybases@gmail.com>, linux-scsi@vger.kernel.org, Chuck Ebbert <cebbert@redhat.com>, Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org


On Fri, 2008-01-11 at 17:01 +0000, Alan Cox wrote:
> > Yes it works under 2.6.16.13.  See the beginning of this thread, i
> > mention there some things about newer versions.
> 
> It worked (ish.. it has problems and always has had) before the big
> updates, and according to my tester after the big update + two patches
> that escaped somewhere in the process. Unfortunately my tester no longer
> has the card to dig further.
> 
> The 0x0 bug was fixed a while ago but seems to have sat in -mm for a bit.
> Don't know about further stuff.

The statement that OpenSuse 10.3, based on 2.6.22.5, also fails
indicates there may be something else that predates your reorganisation
at the root of this (depending on whether the vendor kernel contains a
back port or not).  That's why I want to see what happens on this system
with a vanilla 2.6.22

James


