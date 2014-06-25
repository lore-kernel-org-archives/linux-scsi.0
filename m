From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH 0/7] mptfusion static checker fixups
Date: Wed, 25 Jun 2014 10:18:11 -0400
Message-ID: <20140625101811.44a7313a@jlaw-desktop.mno.stratus.com>
References: <1401900589-19672-1-git-send-email-joe.lawrence@stratus.com>
	<20140625110150.GA19181@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c11o147.mxlogic.net ([208.65.144.80]:35250 "EHLO
	p02c11o147.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757159AbaFYOSP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 10:18:15 -0400
In-Reply-To: <20140625110150.GA19181@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>

Hi Christoph, Sreekanth,

Would it be easier to combine this set with the mpt2/mpt3 changes and
repost a V2?  There were a few changes Christoph request in each set,
so I can post those up later today.

-- Joe

On Wed, 25 Jun 2014 13:01:50 +0200
Christoph Hellwig <hch@infradead.org> wrote:

> Can I get another review for this series?
> 
> On Wed, Jun 04, 2014 at 12:49:42PM -0400, Joe Lawrence wrote:
> > While reviewing the mpt2/mpt3 static checker fixup patchset, Christoph
> > inquired about mptfusion.  None of the sparse / smatch warnings from the
> > earlier patchset directly apply to fusion, but there were a few easy to
> > fix warnings (compile tested only).
> > 
> > The patchset is ordered from the smallest/easiest change up to the last
> > three, which are bit more involved and should be reviewed by LSI,
> > especially the last one "mptfusion: tweak null pointer checks".  See the
> > commentary in those patches after the signed-off-by line.
> > 
> > Cc: Christoph Hellwig <hch@infradead.org>
> > Cc: Dan Carpenter <dan.carpenter@oracle.com>
> > Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
> > 
> > Joe Lawrence (7):
> >   mptfusion: mark file-private functions as static
> >   mptfusion: remove redundant kfree checks
> >   mptfusion: initChainBuffers should return errno
> >   mptfusion: zero kernel-space source of copy_to_user
> >   mptfusion: make adapter prod_name[] a pointer
> >   mptfusion: combine fw_event_work and its event_data
> >   mptfusion: tweak null pointer checks
> > 
> >  drivers/message/fusion/mptbase.c  |   29 +++++++++----------
> >  drivers/message/fusion/mptbase.h  |    2 +-
> >  drivers/message/fusion/mptctl.c   |    2 +-
> >  drivers/message/fusion/mptfc.c    |    3 +-
> >  drivers/message/fusion/mptsas.c   |   57 +++++++++++++++++++------------------
> >  drivers/message/fusion/mptsas.h   |    2 +-
> >  drivers/message/fusion/mptscsih.c |    7 +++--
> >  drivers/message/fusion/mptspi.c   |    5 ++--
> >  8 files changed, 52 insertions(+), 55 deletions(-)
> > 
> > -- 
> > 1.7.10.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> ---end quoted text---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

