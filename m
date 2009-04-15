From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: LSF Papers online?
Date: Tue, 14 Apr 2009 23:58:26 -0400
Message-ID: <1239767906.15559.1.camel@mulgrave>
References: <49E335BA.3020103@panasas.com>
	 <200904141654.24067.bzolnier@gmail.com>
	 <20090414175441.5ce1f59d@lxorguk.ukuu.org.uk>
	 <200904150009.06539.bzolnier@gmail.com> <1239749357.3638.3.camel@mulgrave>
	 <49E53AE6.4010803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <49E53AE6.4010803@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>, Jonathan Corbet <corbet@lwn.net>, Boaz Harrosh <bharrosh@panasas.com>, Zach Brown <zach.brown@oracle.com>, Chris Mason <chris.mason@oracle.com>, Tejun Heo <tj@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linux IDE mailing list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2009-04-14 at 19:39 -0600, Robert Hancock wrote:
> James Bottomley wrote:
> > 
> > On a final note about the urgency of getting libata out of SCSI: Intel
> > has been worrying for a while about the fatness of the SCSI/libata
> > stack, and its effects on performance, especially command transmission
> > via SAT, so I'm hoping they'll be supporting the effort.
> 
> I really don't see this as being a big driver for this move. If you look 
> at the code that does the translation of SCSI commands to ATA commands, 
> there really is not much there at all of any consequence to CPU usage. 
> Compared to any kind of hardware/controller interactions I wouldn't say 
> it's likely to be a significant bottleneck at all. In oprofile runs I've 
> done with heavy ATA activity, the top time consumers are the interrupt 
> handlers, command issue paths, code that actually is poking IO 
> registers. The libata-scsi code hasn't even shown up on the radar in my 
> experience.

Been there, said that and got the nicely embroidered polo shirt to prove
it.

The point is, it doesn't really matter what I say or believe, it matters
what they do ... and they believe fat stacks impede the performance of
their SSDs.

James


