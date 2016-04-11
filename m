From: Rameshwar Sahu <rsahu-qTEPVZfXA3Y@public.gmane.org>
Subject: Re: [PATCH] arm64: dts: apm: Fix compatible string for X-Gene 2 SATA
 controller DTS node
Date: Mon, 11 Apr 2016 14:44:43 +0530
Message-ID: <CAFd313y-VV1Kk754b=fV0-kToMz=7Y=COqwSJQh=agYaLjUzyw@mail.gmail.com>
References: <1459245294-22678-1-git-send-email-rsahu@apm.com>
	<CADaLNDnU7UJOOFs9euPP035iJX5b1-p7jLoKB5f0Sn==Ec3sYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADaLNDnU7UJOOFs9euPP035iJX5b1-p7jLoKB5f0Sn==Ec3sYA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Duc Dang <dhdang-qTEPVZfXA3Y@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devicetree List <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arm <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Jon Masters <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, patches <patches-qTEPVZfXA3Y@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi Olof,

On Wed, Mar 30, 2016 at 12:41 AM, Duc Dang <dhdang-qTEPVZfXA3Y@public.gmane.org> wrote:
>
> On Tue, Mar 29, 2016 at 2:54 AM, Rameshwar Prasad Sahu <rsahu-qTEPVZfXA3Y@public.gmane.org> wrote:
> > Fix X-Gene SATA controller compatible string for Merlin board.
> >
> > Signed-off-by: Rameshwar Prasad Sahu <rsahu-qTEPVZfXA3Y@public.gmane.org>
> > Acked-by: Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
>
> I will queue this patch into xgene-next tree.
>
> > ---
> >  arch/arm64/boot/dts/apm/apm-shadowcat.dtsi |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/boot/dts/apm/apm-shadowcat.dtsi b/arch/arm64/boot/dts/apm/apm-shadowcat.dtsi
> > index 5d87a3d..74d971e 100644
> > --- a/arch/arm64/boot/dts/apm/apm-shadowcat.dtsi
> > +++ b/arch/arm64/boot/dts/apm/apm-shadowcat.dtsi
> > @@ -524,7 +524,7 @@
> >                 };
> >
> >                 sata1: sata@1a000000 {
> > -                       compatible = "apm,xgene-ahci";
> > +                       compatible = "apm,xgene-ahci-v2";
> >                         reg = <0x0 0x1a000000 0x0 0x1000>,
> >                               <0x0 0x1f200000 0x0 0x1000>,
> >                               <0x0 0x1f20d000 0x0 0x1000>,
> > @@ -534,7 +534,7 @@
> >                 };
> >
> >                 sata2: sata@1a200000 {
> > -                       compatible = "apm,xgene-ahci";
> > +                       compatible = "apm,xgene-ahci-v2";
> >                         reg = <0x0 0x1a200000 0x0 0x1000>,
> >                               <0x0 0x1f210000 0x0 0x1000>,
> >                               <0x0 0x1f21d000 0x0 0x1000>,
> > @@ -544,7 +544,7 @@
> >                 };
> >
> >                 sata3: sata@1a400000 {
> > -                       compatible = "apm,xgene-ahci";
> > +                       compatible = "apm,xgene-ahci-v2";
> >                         reg = <0x0 0x1a400000 0x0 0x1000>,
> >                               <0x0 0x1f220000 0x0 0x1000>,
> >                               <0x0 0x1f22d000 0x0 0x1000>,
> > --
> > 1.7.1
> >


Any comments on this patch ??
>
>
> Regards,
> Duc Dang.
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
