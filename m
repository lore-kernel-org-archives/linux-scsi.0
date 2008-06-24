From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] Separating out libata out of SCSI (finally)
Date: Tue, 24 Jun 2008 17:54:33 +0100
Message-ID: <20080624175433.0461c85a@lxorguk.ukuu.org.uk>
References: <485B2CC6.6070201@kernel.org>
	<1213993737.3443.35.camel@localhost.localdomain>
	<485C31FE.8050408@garzik.org>
	<87f94c370806231404t13586777x7f7bee24ebe25ffc@mail.gmail.com>
	<1214255460.3310.27.camel@localhost.localdomain>
	<4860B099.2030305@panasas.com>
	<1214318550.3299.7.camel@localhost.localdomain>
	<48610BDC.6090101@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <48610BDC.6090101@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Greg Freemyer <greg.freemyer@gmail.com>, Jeff Garzik <jeff@garzik.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, brking@linux.vnet.ibm.com, Mark Lord <liml@rtr.ca>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

> I'm currently working on a scheme where partitions above gd->minors get
> allocated dynamic MAJ:MIN.  It looks like it can be done mostly in block
> layer proper.  The only problem I can foresee is not being able to
> specify MAJ:MIN as root device but that shouldn't be a major problem.
> I'll report back when I make more progress.

Run it past Al Viro, he vetoed the previous proposal to have discontiguous
minor number ranges a couple of years ago, which is why we are stuck with
this limit.

Alan
