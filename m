From: Matthew Wilcox <willy@debian.org>
Subject: Re: Symbios 53C8XX broken on ia64?
Date: Wed, 24 Mar 2004 01:50:43 +0000
Sender: linux-ia64-owner@vger.kernel.org
Message-ID: <20040324015043.GE25059@parcelfarce.linux.theplanet.co.uk>
References: <je3c80ph2o.fsf@sykes.suse.de> <1080060468.2091.28.camel@patsy.fc.hp.com> <jeisgvxh2j.fsf@sykes.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ia64-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <jeisgvxh2j.fsf@sykes.suse.de>
To: Andreas Schwab <schwab@suse.de>
Cc: Alex Williamson <alex.williamson@hp.com>, linux-ia64 <linux-ia64@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 24, 2004 at 12:46:28AM +0100, Andreas Schwab wrote:
> I can't confirm, still fails for me.  I see sym2_init called, but never
> sym2_probe.  This is with an Everest (rx5670).

I just booted on an rx5670 and it works fine.

However, I think I may have an idea ... what do you get in the line
that reports the SAL version?  I wonder if you have prototype firmware
that's reporting a bogus version or revision?  I just debugged a problem
on a prototype that was using SAl 3.2 calls to access PCI config space,
so it looked like there were no PCI devices available.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
