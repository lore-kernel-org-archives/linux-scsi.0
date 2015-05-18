From: Ursula Braun <ubraun@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: megaraid_sas: Prevent future %p disaster
Date: Mon, 18 May 2015 12:05:20 +0200
Message-ID: <1431943520.7490.6.camel@BR9GV9YG.de.ibm.com>
References: <OF651E5409.7FC1198E-ONC1257E49.0034C44E-C1257E49.0034D9A0@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:52620 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbbERKHt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 May 2015 06:07:49 -0400
Received: from /spool/local
	by e06smtp11.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ubraun@linux.vnet.ibm.com>;
	Mon, 18 May 2015 11:07:47 +0100
In-Reply-To: <OF651E5409.7FC1198E-ONC1257E49.0034C44E-C1257E49.0034D9A0@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Eugene Crosser <Eugene.Crosser@ru.ibm.com>, Ursula Braun <ursula.braun@de.ibm.com>


Joe,

thanks, we will add your qeth patch to our local library and submit it
with one of our next shipments.

Regards, Ursula Braun
> 
> From:        Joe Perches <joe@perches.com> 
> To:        Rasmus Villemoes <linux@rasmusvillemoes.dk>, Evgeny
> Cherkashin/Russia/IBM@IBMRU, Frank Blaschka
> <frank.blaschka@de.ibm.com>, Ursula Braun <ursula.braun@de.ibm.com> 
> Cc:        Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena
> <sumit.saxena@avagotech.com>, Uday Lingala
> <uday.lingala@avagotech.com>, "James E.J. Bottomley"
> <JBottomley@parallels.com>, "PDL,MEGARAIDLINUX"
> <megaraidlinux.pdl@avagotech.com>, linux-scsi@vger.kernel.org,
> linux-kernel@vger.kernel.org 
> Date:        05/12/2015 05:52 PM 
> Subject:        Re: [PATCH] scsi: megaraid_sas: Prevent future %p
> disaster 
> 
> ______________________________________________________________________
> 
> 
> 
> On Tue, 2015-05-12 at 16:04 +0200, Rasmus Villemoes wrote:
> > On Tue, Feb 10 2015, Kashyap Desai <kashyap.desai@avagotech.com>
> wrote:
> > 
> > > Acked-by: Kashyap Desai <kashyap.desai@avagotech.com>
> > >
> > >> -----Original Message-----
> > >> From: Rasmus Villemoes [mailto:linux@rasmusvillemoes.dk]
> > >> Sent: Friday, February 06, 2015 8:04 PM
> > >> To: Kashyap Desai; Sumit Saxena; Uday Lingala; James E.J.
> Bottomley
> > >> Cc: Rasmus Villemoes; megaraidlinux.pdl@avagotech.com; linux-
> > >> scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> > >> Subject: [PATCH] scsi: megaraid_sas: Prevent future %p disaster
> > >>
> > >> There is currently no %po format extension, so currently the
> letters
> > > "on" are
> > >> simply skipped and the pointer is printed as expected (while
> missing the
> > > word
> > >> on). However, it is probably only a matter of time before someone
> comes
> > > up
> > >> with a %po extension, at which point this is likely to fail
> > > spectacularly.
> > >>
> > >> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> > 
> > Any chance either this minimal fix or Joe's more thorough cleanup
> could
> > get applied? There's still no %po extension, but there's certainly a
> lot
> > of proposals for more %p extensions flying around LKML, so I still
> think
> > the "only a matter of time" holds.
> 
> There's also this one with %pM6:
> ---
> drivers/s390/net/qeth_l2_main.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/net/qeth_l2_main.c
> b/drivers/s390/net/qeth_l2_main.c
> index 0ea0869..dc783047 100644
> --- a/drivers/s390/net/qeth_l2_main.c
> +++ b/drivers/s390/net/qeth_l2_main.c
> @@ -1420,8 +1420,8 @@ static void qeth_bridge_emit_host_event(struct
> qeth_card *card,
>                                                    env[i] = str[i]; i
> ++;
>                                   }
>                                   if (code &
> IPA_ADDR_CHANGE_CODE_MACADDR) {
> -                                                   snprintf(str[i],
> sizeof(str[i]), "MAC=%pM6",
> -
>  &addr_lnid->mac);
> +                                                   snprintf(str[i],
> sizeof(str[i]), "MAC=%pM",
> +
>  addr_lnid->mac);
>                                                    env[i] = str[i]; i
> ++;
>                                   }
>                                   snprintf(str[i], sizeof(str[i]),
> "NTOK_BUSID=%x.%x.%04x",
> 
> 


