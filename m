From: Andrew Morton <akpm@osdl.org>
Subject: Re: i450nx-scanning-fix.patch
Date: Mon, 29 Dec 2003 03:27:59 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031229032759.26802292.akpm@osdl.org>
References: <20031229030235.315d5502.akpm@osdl.org>
	<1072697054.5223.12.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:49589 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262762AbTL2L2A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Dec 2003 06:28:00 -0500
In-Reply-To: <1072697054.5223.12.camel@laptop.fenrus.com>
List-Id: linux-scsi@vger.kernel.org
To: arjanv@redhat.com
Cc: willy@debian.org, linux-scsi@vger.kernel.org

Arjan van de Ven <arjanv@redhat.com> wrote:
>
> On Mon, 2003-12-29 at 12:02, Andrew Morton wrote:
> > I have had this in -mm for some time.  It works on my 450nx-based 4-way. 
> > Was planning on merging it.  Speak now or forever hold your pieces.
> 
> the one thing I can say is that I had a "fix" for this in the RH kernel
> for a while, but it broke with newer bioses. End result was that there
> was a working kernel for either old or for new bioses; the existing
> linux worked well for newer bioses so I just dropped the patch entirely.
> (Several machines only come with newer bioses and most people with old
> bioses had updated anyway, probably for y2k issues :)
> 

Thus leaving me even-more-confused-than-usual.  Ho hum.

Was your fix equivalent to this patch?

