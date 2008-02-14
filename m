From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: "mount: could not find filesystem" - aacraid? (was: Re:
	2.6.26-git0: IDE oops during boot)
Date: Thu, 14 Feb 2008 09:47:32 -0600
Message-ID: <1203004052.3189.18.camel@localhost.localdomain>
References: <20080206105334.GA3664@elf.ucw.cz>
	 <47B40DF2.10009@linux.vnet.ibm.com> <200802141301.35032.bzolnier@gmail.com>
	 <200802141307.42169.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200802141307.42169.bzolnier@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, Nish Aravamudan <nish.aravamudan@gmail.com>, Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, ananth@in.ibm.com, Andi Kleen <andi@firstfloor.org>, linux-scsi@vger.kernel.org, aacraid@adaptec.com
List-Id: linux-scsi@vger.kernel.org

On Thu, 2008-02-14 at 13:07 +0100, Bartlomiej Zolnierkiewicz wrote:
> > I worry that another git-bisect session will be needed unless SCSI
> > developers are already aware of the problem source.
> 
> Yinghai Lu noticed that it may be actually a SES problem:
> 
> http://lkml.org/lkml/2008/2/14/88
> 
> [ I overlooked the above mail, sorry ]

Only if SES is enabled, is it (CONFIG_SCSI_ENCLOSURE)? ... is there
actually a dmesg of the failing system somewhere, I couldn't find it in
the (somewhat long) thread?

James




