From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [2.6 patch] dpt_i2o fix for deadlock condition
Date: Tue, 29 Nov 2005 19:53:36 +0100
Message-ID: <20051129185336.GJ31395@stusta.de>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01E3DD6C@otce2k03.adaptec.com> <20051129180437.GB3803@csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932347AbVK2Sxi@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20051129180437.GB3803@csclub.uwaterloo.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 29, 2005 at 01:04:37PM -0500, Lennart Sorensen wrote:
> On Tue, Nov 29, 2005 at 11:51:25AM -0500, Salyzyn, Mark wrote:
> > Miquel van Smoorenburg <miquels@cistron.nl> forwarded me this fix to
> > resolve a deadlock condition that occurs due to the API change in
> > 2.6.13+ kernels dropping the host locking when entering the error
> > handling. They all end up calling adpt_i2o_post_wait(), which if you
> > call it unlocked, might return with host_lock locked anyway and that
> > causes a deadlock.
> > 
> > Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
> > 
> >  drivers/scsi/dpt_i2o.c |    25 ++++++++++++++++++++-----
> >  1 file changed, 20 insertions(+), 5 deletions(-)
> > 
> > Patch attached to email due to Outlook corrupting content when inlined.
> 
> There must still be a way to tell outlook to make the type something
> useful, rather than application/octet-stream.  maybe if the extension
> was .patch.txt it would do something smarter.

Patches in Attachments aren't nice, but better than corrupted patches.

It's unfortunate, but bitching on the people who are somehow forced to 
use crappy email clients is IMHO not a good idea.

> Len Sorensen

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
