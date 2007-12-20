From: "Natalie Protasevich" <protasnb@gmail.com>
Subject: Re: INITIO scsi driver fails to work properly
Date: Thu, 20 Dec 2007 01:32:02 -0800
Message-ID: <32209efe0712200132k68ba2b40gf6e3a103c216e57@mail.gmail.com>
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>
	 <20071217031841.f483e5ac.akpm@linux-foundation.org>
	 <9f00bd9d0712170341u7fef1fc9pc9986dda1a0475cb@mail.gmail.com>
	 <47666904.8060605@panasas.com>
	 <9f00bd9d0712190048g60d79ma067ba85b5553459@mail.gmail.com>
	 <20071219132918.GB26272@parisc-linux.org>
	 <1198083040.5487.14.camel@localhost.localdomain>
	 <20071219170542.GC26272@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:25855 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780AbXLTJcE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Dec 2007 04:32:04 -0500
Received: by fg-out-1718.google.com with SMTP id e21so570546fga.17
        for <linux-scsi@vger.kernel.org>; Thu, 20 Dec 2007 01:32:02 -0800 (PST)
In-Reply-To: <20071219170542.GC26272@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Filippos Papadopoulos <psybases@gmail.com>, Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Dec 19, 2007 9:05 AM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Wed, Dec 19, 2007 at 10:50:40AM -0600, James Bottomley wrote:
> > So, to get the best of both worlds, file a bugzilla and note the bugid.
> > Then email a complete report to the relevant list, but add [BUG <bugid>]
> > to the subject line and cc bugme-daemon@bugzilla.kernel.org  If you do
> > this, bugzilla will keep track of the entire discussion as it progresses
> > and allow those who track bugs through bugzilla to get a pretty accurate
> > idea of the status.  You should never need to touch bugzilla again once
> > the initial bug report is filed: all future information flow is via the
> > mailing lists.
>
> The problem is that it appears to the casual observer as if they can
> then add information to the bug through the web interface.  But that
> information will never be forwarded to the mailing list.  Unless there's
> a way of marking bugs as 'unchangable through the web interface' or 'all
> messages appended to this bug need to be forwarded', Bugzilla just
> doesn't fit our needs.
>
> The Debian BTS fits our way of working much better.  Perhaps somebody
> should investigate a migration.

This is excellent observation by Matthew and James. There is no magic
in bugzilla not being loved, it is just "not the right set of features
for effective work on a problem". It doesn't support multiple
developer' collaboration well.
This distaste is not universal, since some people don't have a problem
with bugzilla as is, maybe those who tend to work on problems
"alone"...
But making it to be a workable tool for everyone is definitely worth it.
Any other favorite bugzillas that are nice to work with and that have
the advantage above?

>
> --
> Intel are signing my paycheques ... these opinions are still mine
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
> --
>
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
