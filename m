From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH -mmotm] scsi: fix the wrong position of the comment
Date: Sun, 10 Mar 2013 21:10:19 -0700
Message-ID: <20130311041019.GB37523@n8021av7gqvyn1.qlogic.org>
References: <1362902990-25137-1-git-send-email-akinobu.mita@gmail.com>
 <1362903765.3003.2.camel@dabdike.int.hansenpartnership.com>
 <20130310005718.2d6579ea.akpm@linux-foundation.org>
 <1362905945.3003.4.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:24771
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750912Ab3CKEKb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Mar 2013 00:10:31 -0400
Content-Disposition: inline
In-Reply-To: <1362905945.3003.4.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Akinobu Mita <akinobu.mita@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>

On Sun, 10 Mar 2013, James Bottomley wrote:

> On Sun, 2013-03-10 at 00:57 -0800, Andrew Morton wrote:
> > On Sun, 10 Mar 2013 08:22:47 +0000 James Bottomley <jbottomley@parallels.com> wrote:
> >
> > > [missing SCSI cc added]
> > > On Sun, 2013-03-10 at 17:09 +0900, Akinobu Mita wrote:
> > > > This fixes the wrong position of the comment introduced by
> > > > scsi-rename-random32-to-prandom_u32.patch in the -mm tree.
> > > >
> > > > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > > > Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> > > > Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
> > > > ---
> > > >  drivers/scsi/qla2xxx/qla_attr.c | 6 +++---
> > > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> > > > index 04bf7b8..e44d47e 100644
> > > > --- a/drivers/scsi/qla2xxx/qla_attr.c
> > > > +++ b/drivers/scsi/qla2xxx/qla_attr.c
> > > > @@ -1939,13 +1939,13 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
> > > >         }
> > > >
> > > >         /* No pending activities shall be there on the vha now */
> > > > -       if (ql2xextended_error_logging & ql_dbg_user)
> > > > -               msleep(prandom_u32() % 10);
> > > > +       if (ql2xextended_error_logging & ql_dbg_user) {
> > > >                 /*
> > > >                  * Just to see if something falls on the net we have placed
> > > >                  * below
> > > >                  */
> > > > -
> > > > +               msleep(prandom_u32() % 10);
> > > > +       }
> > >
> > > I don't git a toss if it's random or prandom: Andrew: get rid of it; we
> > > do not sleep in kernel for random intervals whatever the provocation ...
> > > if this is supposed to be a warning or error condition then print
> > > something.
> >
> > That msleep was added by
> >
> > commit feafb7b1714cf599a6d0fed45801ab3f66046cbd
> > Author:     Arun Easi <arun.easi@qlogic.com>
> > AuthorDate: Fri Sep 3 14:57:00 2010 -0700
> > Commit:     James Bottomley <James.Bottomley@suse.de>
> > CommitDate: Sun Sep 5 15:13:12 2010 -0300
> >
> >     [SCSI] qla2xxx: Fix vport delete issues
>
> Sorry, I didn't notice multiple Andrews on the cc list.  I meant Andrew
> Vasquez (or other member of the qla team) remove this, please (and
> preferably do something correct).
>

James,

We'll take a look at this, yes.  Adding Giri and Co. to the CC.

Thanks, AV

________________________________

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

