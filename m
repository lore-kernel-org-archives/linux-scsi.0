From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/1] [SCSI] tcm_qla2xxx: Remove duplicate header file
 inclusion
Date: Wed, 11 Jul 2012 14:41:26 -0700
Message-ID: <1342042886.18004.26.camel@haakon2.linux-iscsi.org>
References: <1340366038-12722-1-git-send-email-sachin.kamat@linaro.org>
	 <CAK9yfHw=V3SHrAZD=wZkkG=ZgA9Dv+VWAm6uLtLBR1NZRpYt9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:46938 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab2GKVl3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jul 2012 17:41:29 -0400
In-Reply-To: <CAK9yfHw=V3SHrAZD=wZkkG=ZgA9Dv+VWAm6uLtLBR1NZRpYt9g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, patches@linaro.org, target-devel <target-devel@vger.kernel.org>

On Wed, 2012-07-11 at 16:23 +0530, Sachin Kamat wrote:
> Any comments about this patch?
> 

Hi Sachin,

Applied to target-pending.git/for-next, + queued up for-3.6.

Thanks!

--nab

> On 22/06/2012, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> > ctype.h and string.h header files were included more than once.
> >
> > Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> > ---
> >  drivers/scsi/qla2xxx/tcm_qla2xxx.c |    2 --
> >  1 files changed, 0 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> > b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> > index 6e64314..dd0a0df 100644
> > --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> > +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> > @@ -38,8 +38,6 @@
> >  #include <linux/string.h>
> >  #include <linux/configfs.h>
> >  #include <linux/ctype.h>
> > -#include <linux/string.h>
> > -#include <linux/ctype.h>
> >  #include <asm/unaligned.h>
> >  #include <scsi/scsi.h>
> >  #include <scsi/scsi_host.h>
> > --
> > 1.7.4.1
> >
> >
> 
> 


