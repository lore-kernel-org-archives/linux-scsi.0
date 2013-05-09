From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: RE: [PATCH v4 1/6] scsi: ufs: wrap the i/o access operations
Date: Thu, 09 May 2013 10:59:49 +0900
Message-ID: <000201ce4c58$e3bc3b00$ab34b100$%jun@samsung.com>
References: <1366812872-26331-1-git-send-email-sthumma@codeaurora.org>
 <001e01ce4105$ab4e2430$01ea6c90$%jun@samsung.com>
 <000b01ce48a3$ad7072e0$085158a0$%jun@samsung.com>
 <002401ce4bc7$cda068a0$68e139e0$%jun@samsung.com>
 <CALMYJDtFA9PTu++4ijuUujOU=N9Sw=+=pH4KpTCVqLQmL6uE7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:54835 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab3EIB7w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 May 2013 21:59:52 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MMI004GKDJMG4C0@mailout4.samsung.com> for
 linux-scsi@vger.kernel.org; Thu, 09 May 2013 10:59:50 +0900 (KST)
In-reply-to: <CALMYJDtFA9PTu++4ijuUujOU=N9Sw=+=pH4KpTCVqLQmL6uE7A@mail.gmail.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>

On Thursday, May 09, 2013, Santosh Y wrote:
> On Wed, May 8, 2013 at 2:11 PM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> > Simplify operations with hiding mmio_base.
> >
> > Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> > Tested-by: Maya Erez <merez@codeaurora.org>
> > ---
> >  drivers/scsi/ufs/ufshcd.c |  105 +++++++++++++++++++--------------------------
> >  drivers/scsi/ufs/ufshcd.h |    7 +++-
> >  2 files changed, 50 insertions(+), 62 deletions(-)
> >
> Hi Seungwon,
> I could apply your test patch without any issues but I still get
> "fatal: cannot convert from ks_c_5601-1987 to UTF-8" with V4 patch
> series.
> At this point I'm confused :-| not sure if the problem is the
> character set or something else...
Hi Santosh,
You got a pass with my test one before v4. It's strange.

Hi James,
Please let me know, if you have a same problem.
I guess I should change mail sender.

> 
> 
> Hi James,
> Please consider Acked-by: Santosh Y <santoshsy@gmail.com>, if you are
> able to apply the patches.
Thank you for your ack.
There are two patches remained. These are applied with your final comments.
Do you have any idea?
[PATCH v4 5/6] scsi: ufs: add dme configuration primitives
[PATCH v4 6/6] scsi: ufs: add dme control primitives

Thanks,
Seungwon Jeon

