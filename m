From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 005/103] loopback: Only build tcm_loop as module
Date: Thu, 21 Jul 2011 19:54:29 -0700
Message-ID: <1311303269.4474.2.camel@haakon2.linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
	 <1311231979-6631-6-git-send-email-nab@linux-iscsi.org>
	 <CAL1RGDVfP7zjbw_tAwskui_BbQHDxoH0K6SaOtsi8_UeRHfh9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45690 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab1GVDDv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2011 23:03:51 -0400
In-Reply-To: <CAL1RGDVfP7zjbw_tAwskui_BbQHDxoH0K6SaOtsi8_UeRHfh9A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>

On Thu, 2011-07-21 at 14:18 -0700, Roland Dreier wrote:
> Nick, please drop this patch.  It doesn't make any sense -- after my fix that
> you have later in your series, tcm_loop works perfectly well built-in (and in
> fact is useful for quick debugging, along with "qemu -kernel").
> 

Thanks Roland, dropping this patch now.

--nab

>  - R.
> 
> On Thu, Jul 21, 2011 at 12:04 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
> >
> > The tcm_loop must be built as a module.  It cannot be built in.
> >
> > Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
> > Signed-off-by: Nicholas A. Bellinger <nab@risingtidesystems.com>
> > ---
> >  drivers/target/loopback/Kconfig |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/target/loopback/Kconfig b/drivers/target/loopback/Kconfig
> > index 57dcbc2..1bd6a65 100644
> > --- a/drivers/target/loopback/Kconfig
> > +++ b/drivers/target/loopback/Kconfig
> > @@ -1,7 +1,8 @@
> >  config LOOPBACK_TARGET
> >        tristate "TCM Virtual SAS target and Linux/SCSI LDD fabric loopback module"
> > +       depends on m
> >        help
> > -         Say Y here to enable the TCM Virtual SAS target and Linux/SCSI LLD
> > +         Say M here to enable the TCM Virtual SAS target and Linux/SCSI LLD
> >          fabric loopback module.
> >
> >  config LOOPBACK_TARGET_CDB_DEBUG
> > --
> > 1.7.6
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe target-devel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >

