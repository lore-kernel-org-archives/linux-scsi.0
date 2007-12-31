From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Bad escriptions in Kconfig
Date: Mon, 31 Dec 2007 19:35:58 +0100 (CET)
Message-ID: <alpine.LSU.0.999.0712311931080.5775@be1.lrz>
References: <alpine.LSU.0.999.0712311313050.3761@be1.lrz> <477907DB.8030406@torque.net>
 <20071231154731.GY11638@parisc-linux.org> <47791A32.1020405@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752793AbXLaSg0@vger.kernel.org>
In-Reply-To: <47791A32.1020405@torque.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Matthew Wilcox <matthew@wil.cx>, Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 31 Dec 2007, Douglas Gilbert wrote:
> Matthew Wilcox wrote:
> > On Mon, Dec 31, 2007 at 10:16:43AM -0500, Douglas Gilbert wrote:
> >> Bodo Eggert wrote:

(Kicking netdev from CC)

> >>> ---
> >>> SCSI target support (SCSI_TGT) [N/m/y/?] (NEW) ?
> >>>
> >>> If you want to use SCSI target mode drivers enable this option.
> >>> If you choose M, the module will be called scsi_tgt.
> >>> ---
> >>>
> >>> What TF is a SCSI target mode, what is a target mode driver?
> >> Heard of google :-)
> >>
> >> For explanations of SCSI (and other storage) terminology
> >> reference could be made to SAM-3 or SAM-4 drafts (because
> >> the real standards cost money) at www.t10.org .
> >>
> >> Perhaps many other subsections in the kernel could have
> >> similar references.
> > 
> > I think that's an appalling idea.  Someone's trying to configure their
> > kernel, not research hundreds of new ideas on the internet.  Here's a
> > better description:
> > 
> > 	help
> > 	  The SCSI target code allows your computer to appear as a SCSI
> > 	  device.  This is useful in a SAN or NAS environment where you
> > 	  want other computers to be able to treat this computer as a disc.
> > 
> > 	  To compile this driver as a module, choose M here: the module
> > 	  will be called scsi_tgt.
> 
> Appalling or not, it is more accurate to define a SCSI target
> properly than equate it to a direct access logical unit (i.e.
> a disk).

Yes, but calling the current text a "help text" would be even less accurate.
Can you create a helpfull text without being incorrect?
-- 
Field experience is something you don't get until just after you need it.
