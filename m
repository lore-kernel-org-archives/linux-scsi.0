From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] scsi: Document generic scsi device attributes
Date: Sun, 21 Aug 2011 18:22:12 +0200
Message-ID: <20110821182212.118f188d@stein>
References: <20110819144427.15191.54676.stgit@beardog.cce.hp.com>
	<4E4E7F8B.7020502@interlog.com>
	<20110819154135.GF8422@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110819154135.GF8422@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: Douglas Gilbert <dgilbert@interlog.com>, james.bottomley@hansenpartnership.com, stephenmcameron@gmail.com, akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Aug 19 scameron@beardog.cce.hp.com wrote:
> On Fri, Aug 19, 2011 at 11:21:47AM -0400, Douglas Gilbert wrote:
> > On 11-08-19 10:44 AM, Stephen M. Cameron wrote:
> > >From: Stephen M. Cameron<scameron@beardog.cce.hp.com>
> > >
> > 
> > <snip>
> > 
> > >+What:           /sys/class/scsi_device/..../device/modalias
> > >+Date:           April, 2007
> > >+KernelVersion:  Unknown
> > >+Contact:        James Bottomley<James.Bottomley@HansenPartnership.com>
> > >+Description:
> > >+		This read only string value contains a string of the form
> > >+		"scsi:t-0xXX" where "XX" are two hex digits representing the
> > >+		SCSI device type.  See also the "type" attribute and table 47
> > >+		in section 8.2.5.1 "Standard INQUIRY data" of the SCSI-2
> > >+		specification.
> > 
> > My copy of SCSI-2 is draft 10b from 1989 and it doesn't have a
> > section 8.2.5.1 . Since SCSI-2 was withdrawn over 10 years
> > ago perhaps you could use a more recent reference. [I see
> > webstore.ansi.org still sells the SCSI-2 standard for $30 .]
> > 
> > SPC-3 is a standard [ANSI INCITS 408-2005; ISO/IEC 14776-453]
> > and the relevant section, judging from its last draft, would
> > be table 83 in section 6.4.2 . And it is now called the
> > "peripheral device type".
> 
> I knew it was a mistake for me to try to figure out what the
> proper reference should be.  If such things change, maybe 
> having a reference in there at all is a mistake.

The versions of the spec change, as do the chapter numbers and table
numbers.  But it is always "SCSI Primary Commands" ( <- the command
set specification), "INQUIRY data" ( <- the SCSI command response which
contains the data that we are talking about here), "Peripheral Device
Type" ( <- the number which is written into the modalias).

In the last draft revisions of SPC-3 and SPC-4 which were openly published
at ftp.t10.org, it is table 83 in section 6.4.2.  (Visit archive.org to
retrieve those drafts.)  But in the words of the same table:  "All
standards are subject to revision, and parties to agreements based on this
standard are encouraged to investigate the possibility of applying the
most recent editions of the listed standards." :-)

> Maybe it should just
> say something like, "the numbers correspond to the entries in
> the scsi_device_types[] array in drivers/scsi/scsi.c"

But
  - the values come from the target, not from the kernel,
  - their meaning is defined by ANSI/INCITS T10, not by the authors of
    linux/drivers/scsi/scsi.c.

> since that file is more likely to be close at hand than whichever
> spec we might refer to.

Maybe call it Peripheral Device Type (PDT, defined by SCSI Primary
Commands).
-- 
Stefan Richter
-=====-==-== =--- =-=-=
http://arcgraph.de/sr/
