From: adam radford <aradford@gmail.com>
Subject: Re: [PATCH 6/7] scsi/megaraid: fix sparse warnings
Date: Fri, 11 May 2012 15:29:56 -0700
Message-ID: <CAHtARFFnLrk0zQ7GeoiPX3Cyso9zq-05q+RyyeGN0v7q=Dm1gQ@mail.gmail.com>
References: <1336774168-26577-1-git-send-email-mathieu.poirier@linaro.org>
	<1336774168-26577-7-git-send-email-mathieu.poirier@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49878 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946334Ab2EKW35 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 May 2012 18:29:57 -0400
In-Reply-To: <1336774168-26577-7-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mathieu.poirier@linaro.org
Cc: JBottomley@parallels.com, megaraidlinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de

On Fri, May 11, 2012 at 3:09 PM,  <mathieu.poirier@linaro.org> wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
=2E..
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/sc=
si/megaraid/megaraid_sas_fusion.c
> index bfd87fa..234ad74 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -51,55 +51,16 @@
> =A0#include <scsi/scsi_device.h>
> =A0#include <scsi/scsi_host.h>
>
> +#include "mega_common.h"

Do not include mega_common.h in the megaraid_sas driver.  It has
nothing to do with this driver.  It is for the older Parallel SCSI
megaraid drivers.

-Adam
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
