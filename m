From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: (fwd) Bug#11922: I/O error on blank tapes
Date: Mon, 04 Feb 2008 15:56:53 -0600
Message-ID: <1202162213.3096.119.camel@localhost.localdomain>
References: <20080204142206.GB5532@stro.at>
	 <20080204212835.GA29286@gollum.tnic>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080204212835.GA29286@gollum.tnic>
Sender: linux-ide-owner@vger.kernel.org
To: petkovbb@gmail.com
Cc: maximilian attems <max@stro.at>, linux-ide@vger.kernel.org, Stephen Kitt <steve@sk2.org>, bzolnier@gmail.com, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On Mon, 2008-02-04 at 22:28 +0100, Borislav Petkov wrote:
> On Mon, Feb 04, 2008 at 03:22:06PM +0100, maximilian attems wrote:
> 
> (Added Bart to CC)
> 
> > hello borislav,
> > 
> > may i forward you that *old* Debian kernel bug,
> > have seen you working on ide-tape:
> > http://bugs.debian.org/11922
> > no we don't carry any ide patches anymore.
> > 
> > maybe you've already fixed it in latest?
> > 
> > thanks
> > 
> > -- 
> > maks
> > 
> > ----- Forwarded message from Stephen Kitt <steve@sk2.org> -----
> > 
> > Subject: Bug#11922: I/O error on blank tapes
> > Date: Sat, 1 Dec 2007 19:06:18 +0100
> > From: Stephen Kitt <steve@sk2.org>
> > To: 11922@bugs.debian.org
> > 
> > Hi,
> > 
> > This does still occur with 2.6.22; with a blank tape in my HP DDS-4 drive:
> > 
> > $ tar tzvf /dev/nst0
> > tar: /dev/nst0: Cannot read: Input/output error

That's a SCSI tape, not an IDE one.  I cc'd the SCSI list

James

> > tar: At beginning of tape, quitting now
> > tar: Error is not recoverable: exiting now
> > 
> > gzip: stdin: unexpected end of file
> > tar: Child returned status 2
> > tar: Error exit delayed from previous errors
> > 
> > Nothing gets logged anywhere, which fits the original bug description.
> > 
> > This is a well-known issue: see for example
> > http://www.sibbald.com/bacula/html-manual/Bacula_Console.html (search for
> > "blank tape").
> > 
> > Regards,
> > 
> > Stephen
> > 
> > 
> > 
> > -- 
> > To UNSUBSCRIBE, email to debian-kernel-REQUEST@lists.debian.org
> > with a subject of "unsubscribe". Trouble? Contact listmaster@lists.debian.org
> > 
> > 
> > ----- End forwarded message -----
> 
> Hi Maks,
> 
> we're currently in the process of aggressively cleaning up ide-tape. However,
> this brings (almost) no functional changes to the driver and we haven't looked
> at any bugs that might exist. Actually, I wanted to probe the community to see
> whether anyone is using ide-tape at all, and if not, to remove it completely.
> 
> Since i don't have the hardware, i'm gonna have to ask you (or Stephen) to wait
> until all changes have entered mainline and then to try to reproduce the bug again
> after having enabled debugging (IDETAPE_DEBUG_LOG) and send me the syslog
> output.
> 
> Thanks.
> 

