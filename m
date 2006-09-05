From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Linux 2.6.18-rc6
Date: Wed, 06 Sep 2006 08:20:37 +1000
Message-ID: <1157494837.22705.151.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0609031939100.27779@g5.osdl.org>
	 <20060905122656.GA3650@aepfle.de>
	 <1157490066.3463.73.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965215AbWIEWU6@vger.kernel.org>
In-Reply-To: <1157490066.3463.73.camel@mulgrave.il.steeleye.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Olaf Hering <olaf@aepfle.de>, Linus Torvalds <torvalds@osdl.org>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2006-09-05 at 16:01 -0500, James Bottomley wrote:
> On Tue, 2006-09-05 at 14:26 +0200, Olaf Hering wrote:
> > <4>Machine check in kernel mode.
> > <4>Caused by (from SRR1=49030): Transfer error ack signal
> > <4>Oops: Machine check, sig: 7 [#1]
> [...]
> > <4> scsi0: PCI error Interrupt at seqaddr = 0x8
> 
> Is this actually a PCI bus error?  In which case it's probably the
> ahc_inb(,SBLKCTL) of ahc_linux_get_signalling().  Can you verify this?
> And what happens when you try to cat /proc/scsi_host/host<n>/signalling
> for this card?

Yes, it's a PCI error.

Ben.
