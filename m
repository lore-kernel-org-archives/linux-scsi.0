From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: LSF Papers online?
Date: Wed, 15 Apr 2009 10:28:29 +0100
Message-ID: <20090415102829.7fec55f2@lxorguk.ukuu.org.uk>
References: <49E335BA.3020103@panasas.com>
	<200904141654.24067.bzolnier@gmail.com>
	<20090414175441.5ce1f59d@lxorguk.ukuu.org.uk>
	<200904150009.06539.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200904150009.06539.bzolnier@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Jonathan Corbet <corbet@lwn.net>, Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Zach Brown <zach.brown@oracle.com>, Chris Mason <chris.mason@oracle.com>, Tejun Heo <tj@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linux IDE mailing list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> I just wanted to have clear vision of the process instead of "lets merge
> it now and worry about real users later".

There was a simple vision which was to provide full coverage for all the
relevant ATA controllers using the libata core ASAP and leave the old IDE
code "as is". That was what was done.

> Every uncomfortable technical issue raised was addressed with direct
> "IDE is teh crap" shouting 

Sorry but you are re-inventing history here. The old IDE layer was crap,
and for sound technical reasons including the error handling and the
horrible locking problems from the design level up caused by the
reset/error/timeout handling paths and the polled speed change on CRC
error change down.

I spent years working on that stuff. Throwing it all away was not my idea
of fun, but it was clearly the right technical decision. I'm very happy
with the state of libata PATA.

Alan
