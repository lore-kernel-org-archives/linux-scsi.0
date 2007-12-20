From: Theodore Tso <tytso@mit.edu>
Subject: Re: INITIO scsi driver fails to work properly
Date: Thu, 20 Dec 2007 10:14:49 -0500
Message-ID: <20071220151449.GA27081@thunk.org>
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com> <20071217031841.f483e5ac.akpm@linux-foundation.org> <9f00bd9d0712170341u7fef1fc9pc9986dda1a0475cb@mail.gmail.com> <47666904.8060605@panasas.com> <9f00bd9d0712190048g60d79ma067ba85b5553459@mail.gmail.com> <20071219132918.GB26272@parisc-linux.org> <1198083040.5487.14.camel@localhost.localdomain> <20071219170542.GC26272@parisc-linux.org> <32209efe0712200132k68ba2b40gf6e3a103c216e57@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39349 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398AbXLTPPN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Dec 2007 10:15:13 -0500
Content-Disposition: inline
In-Reply-To: <32209efe0712200132k68ba2b40gf6e3a103c216e57@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Natalie Protasevich <protasnb@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@hansenpartnership.com>, Filippos Papadopoulos <psybases@gmail.com>, Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Dec 20, 2007 at 01:32:02AM -0800, Natalie Protasevich wrote:
> > The problem is that it appears to the casual observer as if they can
> > then add information to the bug through the web interface.  But that
> > information will never be forwarded to the mailing list.  Unless there's
> > a way of marking bugs as 'unchangable through the web interface' or 'all
> > messages appended to this bug need to be forwarded', Bugzilla just
> > doesn't fit our needs.
> >
> > The Debian BTS fits our way of working much better.  Perhaps somebody
> > should investigate a migration.
> 
> This is excellent observation by Matthew and James. There is no magic
> in bugzilla not being loved, it is just "not the right set of features
> for effective work on a problem". It doesn't support multiple
> developer' collaboration well.

Actually, Bugzilla *could* be configured so that, say, linux-scsi was
copied for all SCSI bugs (linux-scsi could just be added to the cc
list).  The problem though is that Bugzilla will then proceed to cc
linux-scsi for all the Bugzilla state change details which might annoy
the denizens of the linux-scsi list.   

But if new entries on the Bugzilla entry could be set to forward to
the appropriate mailing list with the messaging *looking* a lot more
like a mail message, I suspect it could be acceptable.  One of the
advantages of the Debian BTS is that it's much more integrated into
the e-mail workflow.  (Although it lacks the roll up and reporting
capabilities that are beloved by managers...)

But hey, it could be worse.  We could have chosen the Sourceforge bug
tracker.  :-)

						- Ted
