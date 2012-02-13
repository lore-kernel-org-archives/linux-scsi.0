From: Dave Jones <davej@redhat.com>
Subject: Re: Kernel crashing on eject SD card
Date: Sun, 12 Feb 2012 21:18:13 -0500
Message-ID: <20120213021813.GA589@redhat.com>
References: <1328660390.4f31bfa6e8f4b@www.imp.polymtl.ca>
 <20120212220836.6aa7fa4d@stein>
 <20120212222027.71651e8b@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120212222027.71651e8b@stein>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Naveen Goswamy <naveen.goswamy@polymtl.ca>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Feb 12, 2012 at 10:20:27PM +0100, Stefan Richter wrote:
 > On Feb 12 Stefan Richter wrote:
 > > Modules linked in: [...] vboxnetadp(O) vboxnetflt(O) vboxdrv(O) [...]
 > 
 > Oh, could you try without virtualbox?
 > 
 > The debian bug report hints that kernel 3.2 /without virtualbox drivers/
 > seems to behave itself.
 > http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=649735

We've seen this a bunch of times in Fedora too.

Here's a report we've been duping similar bugs against
https://bugzilla.redhat.com/show_bug.cgi?id=754518

Some of them are using vbox/vmware, but there's a few in there that
haven't used either, so I think that might be a red herring.

	Dave
