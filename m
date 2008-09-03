From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] lib: add generic helper to print sizes rounded to
 the correct SI range
Date: Wed, 3 Sep 2008 08:58:52 -0700
Message-ID: <20080903085852.ee31fee8.akpm@linux-foundation.org>
References: <48B9546B.4010004@simon.arlott.org.uk>
	<1220117091.3615.3.camel@localhost.localdomain>
	<20080830174516.GD1239@parisc-linux.org>
	<48B9B552.8060406@simon.arlott.org.uk>
	<48B9B588.7060709@simon.arlott.org.uk>
	<1220147947.3615.18.camel@localhost.localdomain>
	<20080831025412.GJ1239@parisc-linux.org>
	<1220195310.4021.4.camel@localhost.localdomain>
	<1220195634.4021.9.camel@localhost.localdomain>
	<20080902203914.4ddf3735.akpm@linux-foundation.org>
	<1220452354.3254.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753385AbYICP7Y@vger.kernel.org>
In-Reply-To: <1220452354.3254.11.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Simon Arlott <simon@fire.lp0.eu>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 03 Sep 2008 09:32:34 -0500 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> > > +	snprintf(buf, len, "%lld%s%s", size, tmp, units_str[units][i]);
> > 
> > Can't print a u64 - we don't know what type it has.  It must be cast to
> > something, usually unsigned long long.
> 
> I thought there was a patch from Matthew to move u64 to unsigned long
> long on all architectures, thus obviating this annoying conversion ...
> is that still wandering upstream, or has it been dropped?

It broke, and it needs vast numbers of conversions in the arch code.
