From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC][PATCH] libata: enable SATA disk fua detection on default
Date: Wed, 4 Jul 2012 10:47:15 +0800
Message-ID: <20120704024715.GA17095@gmail.com>
References: <1336447443-4685-1-git-send-email-wenqing.lz@taobao.com>
 <20120703090441.GA4804@gmail.com>
 <4FF351F8.1000003@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4FF351F8.1000003@msgid.tls.msk.ru>
Sender: linux-ide-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
List-Id: linux-scsi@vger.kernel.org

Hi Michael,

On Wed, Jul 04, 2012 at 12:11:36AM +0400, Michael Tokarev wrote:
> On 03.07.2012 13:04, Zheng Liu wrote:
> > Hi Jeff,
> > 
> > Sorry for bothering you.  Could you please review this patch, or give me
> > some feedbacks.  If this patch can be applied, I can rebase it to the
> > lastest version of mainline kernel.  Thank you.
> []
> >> -int libata_fua = 0;
> >> +int libata_fua = 1;
> 
> I guess it can be enabled after LOTS of testing of various drives out
> there, which shows that no current drives have issues with FUA anymore,
> and after building a black-list of devices which misbehave.  It is quite
> a big project, I think.  But what it gives us in return?
> 
> (I've no idea if this is the right answer, speaking of myself only)

Thanks for the reply.  Indeed it is quite a big project but we enable
FUA feature for SAS disk.  Is there any differences?

Regards,
Zheng
