From: Adrian Bunk <bunk@kernel.org>
Subject: Re: Scsi on sparc build break in 2.6.23.
Date: Sat, 13 Oct 2007 21:26:31 +0200
Message-ID: <20071013192631.GE4211@stusta.de>
References: <200710110552.49129.rob@landley.net> <200710111737.30420.rob@landley.net> <20071011235659.GB3620@stusta.de> <200710131409.36164.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200710131409.36164.rob@landley.net>
Sender: sparclinux-owner@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Oct 13, 2007 at 02:09:35PM -0500, Rob Landley wrote:
> On Thursday 11 October 2007 6:56:59 pm Adrian Bunk wrote:
> > On Thu, Oct 11, 2007 at 05:37:30PM -0500, Rob Landley wrote:
> > > On Thursday 11 October 2007 10:21:49 am Adrian Bunk wrote:
> > > > I assume you have the full .config in your build directory, and could
> > > > have taken it from there?
> > >
> > > Actually I don't.  (The extracted source tree is in a temporary directory
> > > which the script deletes afterwards unless I tell it not to.  I just
> > > followed my own instructions to create the .config and attach it, but I
> > > see that James Bottomley already diagnosed it and you came up with a
> > > patch.  Off to try it...)
> >
> > I was able to follow your instructions for generating it.
> >
> > But I hope you got my point that it's much easier to debug such issues
> > when you generate the .config yourself and attach it when sending the
> > bug report.
> 
> *shrug*  I find miniconfig much easier to read because I can see what the 50 
> or so intentional options are, not just the 1000 or so background options set 
> to various default values.

The .config is the canonical format everyone is used to.

It also has advantages like a defined order of the options.

And it is actually an advantage that you see what the other options are 
set to (e.g. in this case your miniconfig did not show the value of 
CONFIG_HOTPLUG which was the most important option for understanding the 
bug) - it doesn't matter whether you {dis,en}abled it intentionally, 
all that matter is it's value.

There might be use cases where a miniconfig is better, but for debugging 
compile errors a full .config is much better.

> Rob

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

