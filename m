From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: target-pending/for-next patches
Date: Wed, 08 Nov 2017 01:37:01 -0800
Message-ID: <1510133821.29624.71.camel@haakon3.daterainc.com>
References: <1509844462.29624.14.camel@haakon3.daterainc.com>
         <1509897928.3899.9.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1509897928.3899.9.camel@HansenPartnership.com>
Sender: target-devel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Mike Christie <mchristi@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2017-11-05 at 08:05 -0800, James Bottomley wrote:
> On Sat, 2017-11-04 at 18:14 -0700, Nicholas A. Bellinger wrote:
> > Hi all,
> > 
> > Just a friendly email after catching up on patches this week, the
> > majority of those outstanding on the list have been merged into
> > target-pending/for-next.  Please see below.
> > 
> > For those who submitted patches, please have a look and let me know
> > if anything is else missing.  Note there are two exceptions that have
> > been left out for now that I'll be following up with separately.
> > 
> > Thus far it's all been either straight-forward bug-fixes, minor
> > cleanups, or small miscellaneous enhancements.  AFAICT, nothing looks
> > particularly concerning.
> 
> The concern would be you dumping a tree on the eve of a merge window,
> which you're presumably going to send to Linus in a week or so, when
> the last time you appeared was a fixes pull in 12 August, because it
> suggests this lot is just some randomly chosen selection to try to keep
> the tree alive.

No.  The tree contains outstanding bug-fixes and very minor
improvements.

Do you have an objection to a particular patch..?

>  I really wouldn't do it like this: I know Linus
> doesn't care too much for SCSI stuff and if you're lucky he may be too
> busy yelling at Jens to notice, but if not, you'll find yourself on the
> receiving end of his ire and that will damage the reputation of your
> tree a lot.

I'd rather target-pending/for-next be judged on patches, and not
preconceived fear of including bug-fixes that address end-user issues
close to a merge window.

> 
> If the work of running the target tree has got too much, get a patch
> wrangler who can help with the process stuff you're completely lacking,
> like reviews and testing and long incubation in linux-next for exposure
> to 0day.

The past release has been exceedingly slow in drivers/target/, with the
rate of incoming patches is down to ~2 per week.  Those queued are
specific to drivers/target/ and don't run afoul of linux-next and 0-day
builds.

Personally, I'm still focused on bug-fixing and ensuring patches make it
back to v4.x.y linux-stable.git.  However, there are still few people
working on bugs specific to host <-> fabric <-> target-core <-> backend
configurations, beyond individual components fixes.

> I'm sure we can find several volunteers.

Sure, a patch wrangler would be helpful.

Where things tend to run into trouble is when someone starts merging
subsystem changes, but aren't directly responsible for distro releases
or production users running linux-stable.git code.

That said, I'd prefer someone with 'skin in the game' and end-users they
support.
