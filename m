From: Matthew Wilcox <willy@debian.org>
Subject: Re: 2.6.5-rc1 SCSI + st regressions (was: Linux 2.6.5-rc1)
Date: Tue, 16 Mar 2004 22:29:51 +0000
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040316222951.GC25059@parcelfarce.linux.theplanet.co.uk>
References: <Pine.LNX.4.58.0403152154070.19853@ppc970.osdl.org> <20040316211203.GA3679@merlin.emma.line.org> <20040316211700.GA25059@parcelfarce.linux.theplanet.co.uk> <20040316215659.GA3861@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040316215659.GA3861@merlin.emma.line.org>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 16, 2004 at 10:56:59PM +0100, Matthias Andree wrote:
> I've backed out the 2004-03-12 ChangeSet,
> willy@debian.org|ChangeSet|20040312212827|57687
> 
> and rebooted, result (does that make sense? Was that a complete
> back-out?):
[...]
> Attached scsi CD-ROM sr0 at scsi0, channel 0, id 2, lun 0
> st: Version 20040226, fixed bufsize 32768, s/g segs 256
> Unable to handle kernel NULL pointer dereference at virtual address 0000002e
>  printing eip:
> d1ba00fc
> *pde = 00000000
> Oops: 0002 [#1]

OK, that confirms it's not the sym2 changes that were the problem.
Thanks for testing!

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
