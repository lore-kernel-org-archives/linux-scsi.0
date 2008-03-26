From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Wed, 26 Mar 2008 11:58:43 +0200
Message-ID: <47EA1E53.5070907@panasas.com>
References: <47E875AD.1000901@rtr.ca> <47E87942.2020409@rtr.ca> <1206458278.3273.5.camel@localhost.localdomain> <87f94c370803251045h46cbdc0auc541302fbad4a3b9@mail.gmail.com> <20080325105228.26396685.randy.dunlap@oracle.com> <20080325180910.GF16721@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080325180910.GF16721@parisc-linux.org>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Greg Freemyer <greg.freemyer@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Mark Lord <lkml@rtr.ca>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 25 2008 at 20:09 +0200, Matthew Wilcox <matthew@wil.cx> wrote:
> On Tue, Mar 25, 2008 at 10:52:28AM -0700, Randy Dunlap wrote:
>>> I'm not sure what the Linux Kernel support is for GPTs.
>> It's implemented.  Not sure about how well used/tested it is.
> 
> ia64 uses it exclusively ... at least on discs that you want to use from
> EFI.
> 
I thinks intel-Macs do too.

Boaz

