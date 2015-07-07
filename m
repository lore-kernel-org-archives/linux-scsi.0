From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH] megaraid:Remove no longer required variable ret from the
 function megasas_sync_map_info
Date: Tue, 7 Jul 2015 16:34:51 +0530
Message-ID: <c379ae3f27d2ffc8cdc6b9e3cf2b989a@mail.gmail.com>
References: <1436199198-16415-1-git-send-email-xerofoify@gmail.com>
	<3970836098e4580f9199a91daa257c48@mail.gmail.com> <CAH6sp9P4giamp-AQ_Ec3g-x8dcSXhgZo-1Wt8R7P2-p0-8Bbsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:36154 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbbGGLEy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2015 07:04:54 -0400
Received: by lagc2 with SMTP id c2so189114458lag.3
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jul 2015 04:04:53 -0700 (PDT)
In-Reply-To: <CAH6sp9P4giamp-AQ_Ec3g-x8dcSXhgZo-1Wt8R7P2-p0-8Bbsw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frans Klaver <fransklaver@gmail.com>
Cc: Nicholas Krause <xerofoify@gmail.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, JBottomley@odin.com, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Frans Klaver [mailto:fransklaver@gmail.com]
> Sent: Tuesday, July 07, 2015 3:37 PM
> To: Sumit Saxena
> Cc: Nicholas Krause; Kashyap Desai; Uday Lingala; JBottomley@odin.com;
> PDL,MEGARAIDLINUX; linux-scsi@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] megaraid:Remove no longer required variable ret from
> the
> function megasas_sync_map_info
>
> Can't seem to find the original, so here's a reply to the ack mail.
>
> On Tue, Jul 7, 2015 at 10:49 AM, Sumit Saxena <sumit.saxena@avagotech.com>
> wrote:
> > -----Original Message-----
> > From: Nicholas Krause [mailto:xerofoify@gmail.com]
> > Sent: Monday, July 06, 2015 9:43 PM
> > To: kashyap.desai@avagotech.com
> > Cc: sumit.saxena@avagotech.com; uday.lingala@avagotech.com;
> > JBottomley@odin.com; megaraidlinux.pdl@avagotech.com;
> > linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: [PATCH] megaraid:Remove no longer required variable ret from
> > the function megasas_sync_map_info
>
> Isn't something shorter like
>
>   [PATCH] megaraid: remove pointless variable
>
> much more readable?
>
>
> > This removes the no longer required variable ret due to this variable
> > only ever being used at the end of the function megasas_sync_map_info
> > without changing it's value from the orginal setting of its value to
> > zero due to this just remove the variable ret and just return the
> > value of zero directly here in order to indicate to the caller the
> > call to this function has run successfully without any non recoverable
> > issues.
>
> No interpunction?
>
>
> > Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> > ---
> >  drivers/scsi/megaraid/megaraid_sas_fusion.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > index 46a0f8f..b5a8c65 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > @@ -836,7 +836,7 @@ megasas_get_map_info(struct megasas_instance
> > *instance)  int  megasas_sync_map_info(struct megasas_instance
> > *instance) {
> > -       int ret = 0, i;
> > +       int i;
> >         struct megasas_cmd *cmd;
> >         struct megasas_dcmd_frame *dcmd;
> >         u32 size_sync_info, num_lds;
> > @@ -906,7 +906,7 @@ megasas_sync_map_info(struct megasas_instance
> > *instance)
> >
> >         instance->instancet->issue_dcmd(instance, cmd);
> >
> > -       return ret;
> > +       return 0;
> >  }
> >
> > Acked-by: Sumit Saxena <sumit.saxena@avagotech.com>
>
> This ack in an outlook-style response confused the hell out of me ;).
Sorry for confusion. I just got new laptop with default outlook settings so
last message sent was in outlook-style, configured it now.

Thanks,
Sumit
>
> Thanks,
> Frans
