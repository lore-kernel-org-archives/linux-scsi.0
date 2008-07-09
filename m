From: Bernd Petrovitsch <bernd@firmix.at>
Subject: Re: [PATCH] Mark i2o config broken on 64-bit platforms.
Date: Wed, 09 Jul 2008 17:08:22 +0200
Message-ID: <1215616102.21931.38.camel@tara.firmix.at>
References: <E1KGa1W-0004nG-Cw@n2o.xs4all.nl>
	 <20080709113547.19235.15424.stgit@warthog.procyon.org.uk>
	 <4561.1215612914@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758022AbYGIPKY@vger.kernel.org>
In-Reply-To: <4561.1215612914@redhat.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Miquel van Smoorenburg <miquels@cistron.nl>, akpm@linux-foundation.org, alan@redhat.com, Markus.Lidel@shadowconnect.com, vvs@sw.ru, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mit, 2008-07-09 at 15:15 +0100, David Howells wrote:
> Miquel van Smoorenburg <miquels@cistron.nl> wrote:
> 
> > The adaptec management application ("raidutils") is also not 64-bit clean
> > (read the code .. it puts pointers into ints etc etc), and fixing
> > that is not trivial, _but_ the 32 bit version works on a 64 bit kernel.
> 
> That may be so, but there is nothing to protect the 64-bit ioctl() call,
> should someone choose to make one.

Experience showed that (64bit) raidutils simply seg-fault reliably (at
least on a kernel 2.6.15-1-em64t-p4-smp from Debian-Sarge/Backports from
approx. 2 years ago, raidutils 0.0.4-5).

For sure that's not an excuse for "allowing" the calls in the first
place (and not at least return some appropriate -E value).

[...]
> > second, compiling it gives warnings, but it works, and I bet people are
> > using it.

ACK.
And the 32bit raidutils work on top of a 64bit kernel so far (at least
the above version in one case).

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services
