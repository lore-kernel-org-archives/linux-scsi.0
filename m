From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: target-pending/for-next patches
Date: Sun, 05 Nov 2017 08:05:28 -0800
Message-ID: <1509897928.3899.9.camel@HansenPartnership.com>
References: <1509844462.29624.14.camel@haakon3.daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1509844462.29624.14.camel@haakon3.daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mike Christie <mchristi@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2017-11-04 at 18:14 -0700, Nicholas A. Bellinger wrote:
> Hi all,
> 
> Just a friendly email after catching up on patches this week, the
> majority of those outstanding on the list have been merged into
> target-pending/for-next.  Please see below.
> 
> For those who submitted patches, please have a look and let me know
> if anything is else missing.  Note there are two exceptions that have
> been left out for now that I'll be following up with separately.
> 
> Thus far it's all been either straight-forward bug-fixes, minor
> cleanups, or small miscellaneous enhancements.  AFAICT, nothing looks
> particularly concerning.

The concern would be you dumping a tree on the eve of a merge window,
which you're presumably going to send to Linus in a week or so, when
the last time you appeared was a fixes pull in 12 August, because it
suggests this lot is just some randomly chosen selection to try to keep
the tree alive.  I really wouldn't do it like this: I know Linus
doesn't care too much for SCSI stuff and if you're lucky he may be too
busy yelling at Jens to notice, but if not, you'll find yourself on the
receiving end of his ire and that will damage the reputation of your
tree a lot.

If the work of running the target tree has got too much, get a patch
wrangler who can help with the process stuff you're completely lacking,
like reviews and testing and long incubation in linux-next for exposure
to 0day.  I'm sure we can find several volunteers.

James
