From: Benny Halevy <bhalevy@gmail.com>
Subject: Re: [PATCH, RFC] MAINTAINERS: update OSD entries
Date: Wed, 3 May 2017 20:01:33 +0300
Message-ID: <CA+isNRLxSEXhEaysjGGkChakocK87C7t2JhOnfOBbDfskSUjWQ@mail.gmail.com>
References: <20170502075720.23570-1-hch@lst.de> <1493724812.2715.1.camel@redhat.com>
 <f3320b22-060f-2c57-77a9-513747a148f4@electrozaur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:34019 "EHLO
        mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751394AbdECRCF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 May 2017 13:02:05 -0400
In-Reply-To: <f3320b22-060f-2c57-77a9-513747a148f4@electrozaur.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <ooo@electrozaur.com>
Cc: Jeff Layton <jlayton@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Wed, May 3, 2017 at 1:08 PM, Boaz Harrosh <ooo@electrozaur.com> wrote:
>
> On 05/02/2017 02:33 PM, Jeff Layton wrote:
> > On Tue, 2017-05-02 at 09:57 +0200, Christoph Hellwig wrote:
> >> The open-osd domain doesn't exist anymore, and mails to the list lead
> >> to really annoying bounced that repeat every day.
> >>
> >> Also the primarydata address for Benny bounces, and while I have a new
> >> one for him he doesn't seem to be maintaining the OSD code any more.
> >>
> >> Which beggs the question:  should we really leave the Supported status
> >> in MAINTAINERS given that the code is barely maintained?
> >>
> >> Signed-off-by: Christoph Hellwig <hch@lst.de>
> >> ---
> >>  MAINTAINERS | 4 ----
> >>  1 file changed, 4 deletions(-)
> >>
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> >> index 1bb06c5f7716..28dd83a1d9e2 100644
> >> --- a/MAINTAINERS
> >> +++ b/MAINTAINERS
> >> @@ -9418,10 +9418,6 @@ F:    drivers/net/wireless/intersil/orinoco/
> >>
> >>  OSD LIBRARY and FILESYSTEM
> >>  M:  Boaz Harrosh <ooo@electrozaur.com>
> >> -M:  Benny Halevy <bhalevy@primarydata.com>
> >> -L:  osd-dev@open-osd.org
> >> -W:  http://open-osd.org
> >> -T:  git git://git.open-osd.org/open-osd.git
> >>  S:  Maintained
> >>  F:  drivers/scsi/osd/
> >>  F:  include/scsi/osd_*
> >
> > Hah, you beat me to it! I was going to spin up a patch for this today.
> >
> > Acked-by: Jeff Layton <jlayton@redhat.com>
>
> Acked-by: Boaz Harrosh <ooo@electrozaur.com>

Acked-by: Benny Halevy <bhalevy@gmail.com>

>
> >
>
