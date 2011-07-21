From: Roland Dreier <roland@purestorage.com>
Subject: Re: [PATCH 005/103] loopback: Only build tcm_loop as module
Date: Thu, 21 Jul 2011 14:18:02 -0700
Message-ID: <CAL1RGDVfP7zjbw_tAwskui_BbQHDxoH0K6SaOtsi8_UeRHfh9A@mail.gmail.com>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org> <1311231979-6631-6-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog111.obsmtp.com ([74.125.245.90]:45764 "HELO
	na3sys010aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753902Ab1GUVSY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 17:18:24 -0400
In-Reply-To: <1311231979-6631-6-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>

Nick, please drop this patch.  It doesn't make any sense -- after my fi=
x that
you have later in your series, tcm_loop works perfectly well built-in (=
and in
fact is useful for quick debugging, along with "qemu -kernel").

 - R.

On Thu, Jul 21, 2011 at 12:04 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
>
> The tcm_loop must be built as a module. =A0It cannot be built in.
>
> Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
> Signed-off-by: Nicholas A. Bellinger <nab@risingtidesystems.com>
> ---
> =A0drivers/target/loopback/Kconfig | =A0 =A03 ++-
> =A01 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/target/loopback/Kconfig b/drivers/target/loopbac=
k/Kconfig
> index 57dcbc2..1bd6a65 100644
> --- a/drivers/target/loopback/Kconfig
> +++ b/drivers/target/loopback/Kconfig
> @@ -1,7 +1,8 @@
> =A0config LOOPBACK_TARGET
> =A0 =A0 =A0 =A0tristate "TCM Virtual SAS target and Linux/SCSI LDD fa=
bric loopback module"
> + =A0 =A0 =A0 depends on m
> =A0 =A0 =A0 =A0help
> - =A0 =A0 =A0 =A0 Say Y here to enable the TCM Virtual SAS target and=
 Linux/SCSI LLD
> + =A0 =A0 =A0 =A0 Say M here to enable the TCM Virtual SAS target and=
 Linux/SCSI LLD
> =A0 =A0 =A0 =A0 =A0fabric loopback module.
>
> =A0config LOOPBACK_TARGET_CDB_DEBUG
> --
> 1.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe target-deve=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
