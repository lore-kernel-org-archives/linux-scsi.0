From: Matthew Wilcox <willy@debian.org>
Subject: Re: [PATCH] depends on PCI DMA API: Adaptec AIC7xxx_old
Date: Tue, 20 Jul 2004 20:55:52 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040720195552.GB2820@parcelfarce.linux.theplanet.co.uk>
References: <200407201839.i6KIdo2I015550@anakin.of.borg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S266129AbUGTT5Y@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200407201839.i6KIdo2I015550@anakin.of.borg>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, James.Bottomley@SteelEye.com, Linux Kernel Development <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 20, 2004 at 08:39:50PM +0200, Geert Uytterhoeven wrote:
> Adaptec AIC7xxx_old unconditionally depends on the PCI DMA API, so mark it
> broken if !PCI

Shouldn't we rather have dummy PCI DMA APIs?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
