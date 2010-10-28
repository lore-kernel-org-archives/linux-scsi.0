From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Full hostlock pushdown available
Date: Thu, 28 Oct 2010 15:37:53 -0700
Message-ID: <1288305473.5169.355.camel@haakon2.linux-iscsi.org>
References: <20101028150508.GA2385@basil.fritz.box>
	 <1288294123.3043.164.camel@mulgrave.site>
	 <20101028201036.GA2797@basil.fritz.box>
	 <1288297365.10498.4.camel@mulgrave.site>
	 <20101028215017.GB2797@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm10-vm0.bullet.mail.ac4.yahoo.com ([98.139.53.194]:46640 "HELO
	nm10-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752521Ab0J1WsC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Oct 2010 18:48:02 -0400
In-Reply-To: <20101028215017.GB2797@basil.fritz.box>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, Boaz Harrosh <openosd@gmail.com>

On Thu, 2010-10-28 at 23:50 +0200, Andi Kleen wrote:
> > To put this upstream, I need the single commit (with changelog and
> > signoff).  Otherwise the series won't bisect.  Murphys law says that if
> > I apply an unbisectable series like this, all the kernel bisections in
> > the next few months will end up in here, and I'll take a huge amount of
> > flack ...
> 
> I expect even without the locking it should be safe enough for a bisect
> test. Not for production of course. And most drivers don't really
> need the lock anyways so they are safe in any case.
> 
> An alternative would be to use a different lock around the call
> temporary during the series and drop it again at the end.
> 

Mmmmmm, I don't really have an perference here.   Unless we want to
agree to follow Boaz's recommendation from this morning:

http://marc.info/?l=linux-scsi&m=128826469826164&w=2

--nab

