From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] hpsa: fix physical device lun and target numbering
 problem
Date: Tue, 09 Aug 2011 15:20:41 -0500
Message-ID: <1312921242.8648.11.camel@mulgrave>
References: <20110809131801.10649.44268.stgit@beardog.cce.hp.com>
	 <CADzpL0SnZ+t6RT5iU2Ne+HEdBO1n2K51WwqaVDHXPs1CDHGk2A@mail.gmail.com>
	 <CADzpL0TZfdQqoE-X-tN0SrsNSOvqJAsX8DzC46XpM_JihJY29w@mail.gmail.com>
	 <1312920391.8648.6.camel@mulgrave>
	 <20110809200954.GH27723@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47550 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752412Ab1HIUUq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2011 16:20:46 -0400
In-Reply-To: <20110809200954.GH27723@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: Stephen Cameron <stephenmcameron@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, thenzl@redhat.com, akpm@linux-foundation.org, axboe@kernel.dk

On Tue, 2011-08-09 at 15:09 -0500, scameron@beardog.cce.hp.com wrote:
> On Tue, Aug 09, 2011 at 03:06:31PM -0500, James Bottomley wrote:
> > On Tue, 2011-08-09 at 14:58 -0500, Stephen Cameron wrote:
> > > On Tue, Aug 9, 2011 at 8:33 AM, Stephen Cameron
> > > <stephenmcameron@gmail.com> wrote:
> > > 
> > > > Despite the above patch, which I do think is correct, I can still get
> > > > a panic (on RHEL 6.1 with 2.6.31-rc1 kernel)
> > > 
> > > Er, I meant 3.1-rc1, not 2.6.31-rc1.
> > 
> > Do I take it from the fact that you cc'd stable that you want these
> > patches in the stable tree in spite of not adding the stable tag?
> > 
> > James
> > 
> 
> Well, I obviously don't know how to CC stable properly.

Yes, that's why Greg keeps sending you a form letter.

> I think I will stop since it only seems to annoy Greg
> and make me feel like an idiot for trying.

First, but why don't you actually read the file Greg keeps referring you
to in his form letter:

 Documentation/stable_kernel_rules.txt

It actually tells you how to submit, and what this tag thing I've been
asking about is.  It's only 80 lines long and will amply repay time
spent reading it.

James


