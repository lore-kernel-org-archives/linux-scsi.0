From: Erik Mouw <erik@harddisk-recovery.com>
Subject: Re: two sym53c8xx.o modules
Date: Thu, 9 Oct 2003 14:24:28 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20031009122428.GF11525@bitwizard.nl>
References: <3F84AF3C.9050408@wanadoo.es> <Pine.LNX.4.44.0310090826290.2569-100000@logos.cnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0310090826290.2569-100000@logos.cnet>
To: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Cc: Xose Vazquez Perez <xose@wanadoo.es>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 09, 2003 at 08:41:49AM -0300, Marcelo Tosatti wrote:
> On Thu, 9 Oct 2003, Xose Vazquez Perez wrote:
> > kernel 2.4 has two modules with *same name*:
> > /lib/modules/2.4.XX/kernel/drivers/scsi/sym53c8xx_2/sym53c8xx.o
> > /lib/modules/2.4.XX/kernel/drivers/scsi/sym53c8xx.o
> > 
> > "# modprobe sym53c8xx" tries to load sym53c8xx.o first and then sym53c8xx_2/sym53c8xx.o
> > bug or feature?
> > 
> > should be sym53c8xx_2/sym53c8xx.o renamed to sym53c8xx_2/sym53c8xx_2.o ?
> 
> One should not have both drivers loaded at the same time, so I think this
> is alright.

No, it's not allright. Modprobe can't distinguish between
sym53c8xx_2/sym53c8xx.o and sym53c8xx.o, you have to figure out the
full path and insmod one of them manually. Xose is right in that
sym53c8xx_2/sym53c8xx.o should be renamed in sym53c8xx_2/sym53c8xx_2.o.
Compare with aic7xxx and aic7xxx_old.


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
| Data lost? Stay calm and contact Harddisk-recovery.com
