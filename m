From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fw: crash on x86_64 - mm related?
Date: Thu, 01 Dec 2005 14:28:02 -0600
Message-ID: <1133468882.5232.14.camel@mulgrave>
References: <20051129092432.0f5742f0.akpm@osdl.org>
	 <Pine.LNX.4.63.0512012040390.5777@kai.makisara.local>
	 <Pine.LNX.4.64.0512011136000.3099@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932439AbVLAU2u@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0512011136000.3099@g5.osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, Ryan Richter <ryan@tau.solarneutrino.net>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2005-12-01 at 11:38 -0800, Linus Torvalds wrote:
> Ryan, can you test 2.6.15-rc4 and report what it does?
> 
> The "Bad page state" messages may (should) remain, but the crashes should 
> be gone and the machine should hopefully continue functioning fine. And, 
> perhaps more importantly, you should hopefully have a _new_ message about 
> incomplete pfn mappings that should help pinpoint which driver causes 
> this..

On a side note, I have Kai's patch in the scsi-rc-fixes tree which I'm
getting ready to push.  Can we get a consensus on whether it should be
removed before I merge upwards?

Thanks,

James
