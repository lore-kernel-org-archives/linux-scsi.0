From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: INITIO scsi driver fails to work properly
Date: Wed, 19 Dec 2007 10:50:40 -0600
Message-ID: <1198083040.5487.14.camel@localhost.localdomain>
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>
	 <20071217031841.f483e5ac.akpm@linux-foundation.org>
	 <9f00bd9d0712170341u7fef1fc9pc9986dda1a0475cb@mail.gmail.com>
	 <47666904.8060605@panasas.com>
	 <9f00bd9d0712190048g60d79ma067ba85b5553459@mail.gmail.com>
	 <20071219132918.GB26272@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-76-243-235-52.dsl.chcgil.sbcglobal.net ([76.243.235.52]:58459
	"EHLO accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752885AbXLSQuq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Dec 2007 11:50:46 -0500
In-Reply-To: <20071219132918.GB26272@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Filippos Papadopoulos <psybases@gmail.com>, Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


On Wed, 2007-12-19 at 06:29 -0700, Matthew Wilcox wrote:
> On Wed, Dec 19, 2007 at 10:48:27AM +0200, Filippos Papadopoulos wrote:
> > Would it be better to open a bug report at bugzilla?
> 
> No, it wouldn't.  Bugzilla is a place where bug reports go to be
> ignored.  Witness 9370 where despite my best efforts to move discussion
> to the mailing list, it's been thoroughly ignored because the original
> reporte insists on posting additional information there instead of to
> the mailing list.

That's a bit harsh on bugzilla.  It is of use to people whose job it is
to track outstanding bugs.

However, Matthew is completely correct, it's useless for getting bugs
fixed *if* the information isn't on the mailing list.  The reason for
using mailing list is the more eyes principle:  if you email linux-scsi,
all the SCSI experts will see it, not just the one email listed as owner
in bugzilla.  Likewise, as the bug goes through analysis, if it turns
out to be in a different area, that areas mailing list can be added to
the Cc list.

So, to get the best of both worlds, file a bugzilla and note the bugid.
Then email a complete report to the relevant list, but add [BUG <bugid>]
to the subject line and cc bugme-daemon@bugzilla.kernel.org  If you do
this, bugzilla will keep track of the entire discussion as it progresses
and allow those who track bugs through bugzilla to get a pretty accurate
idea of the status.  You should never need to touch bugzilla again once
the initial bug report is filed: all future information flow is via the
mailing lists.

James


