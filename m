From: Matthew Wilcox <willy@debian.org>
Subject: Re: two sym53c8xx.o modules
Date: Thu, 9 Oct 2003 13:38:57 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20031009123857.GC27861@parcelfarce.linux.theplanet.co.uk>
References: <3F84AF3C.9050408@wanadoo.es> <Pine.LNX.4.44.0310090826290.2569-100000@logos.cnet> <20031009122428.GF11525@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20031009122428.GF11525@bitwizard.nl>
To: Erik Mouw <erik@harddisk-recovery.com>
Cc: Marcelo Tosatti <marcelo.tosatti@cyclades.com>, Xose Vazquez Perez <xose@wanadoo.es>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 09, 2003 at 02:24:28PM +0200, Erik Mouw wrote:
> No, it's not allright. Modprobe can't distinguish between
> sym53c8xx_2/sym53c8xx.o and sym53c8xx.o, you have to figure out the
> full path and insmod one of them manually. Xose is right in that
> sym53c8xx_2/sym53c8xx.o should be renamed in sym53c8xx_2/sym53c8xx_2.o.
> Compare with aic7xxx and aic7xxx_old.

Is it really important to change this at this stage of 2.4?  For
reference, sym1 has already gone away in 2.6, so it'll be incovenient
for users no matter what you change.  Let's stick with the devil we know.

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
