From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] [SCSI] sd: make error handling more robust (v2)
Date: Mon, 4 Feb 2008 15:23:54 -0800 (PST)
Message-ID: <759986.17541.qm@web31806.mail.mud.yahoo.com>
References: <1202160128.3096.118.camel@localhost.localdomain>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31806.mail.mud.yahoo.com ([68.142.207.69]:31232 "HELO
	web31806.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752947AbYBDXXz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 18:23:55 -0500
In-Reply-To: <1202160128.3096.118.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tony Battersby <tonyb@cybernetics.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>

--- On Mon, 2/4/08, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Mon, 2008-02-04 at 01:11 -0800, Luben Tuikov wrote:
> > Looks good except that "End LBA" is usually
> defined
> > to be something of the sort of "the LBA of the
> last
> > logical block accessed by the command" or
> "the LBA
> > of the logical block on which the command
> failed".
> > 
> > A spec savvy editor of this code would be
> > "pleasantly" surprised if they had to use
> "end_lba",
> > and didn't pay attention that it was actually
> > "End LBA" + 1.
> 
> Heh, well, that's where spec people and programmers
> part company.  The
> universal expectation of a programmer in looping is
> 
> for (a = beginning; a < end; a++)
> 
> rather than <= if end were actually to point to last
> rather than last +
> 1.

For loop invariants that's true, although I didn't see
a loop in sd_done().

   Luben

