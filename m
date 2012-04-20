From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [RESEND PATCH 0/2]: Use correct DMA device in SCSI/libata
Date: Fri, 20 Apr 2012 13:17:47 +0800
Message-ID: <CAF1ivSaCKUdp6cswhwG0qsWe=0Qo+7rtY07Ynr8VmC_gPmXdUA@mail.gmail.com>
References: <1334209839-21978-1-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47459 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab2DTFRs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Apr 2012 01:17:48 -0400
In-Reply-To: <1334209839-21978-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: =?ISO-8859-1?Q?J=F6rg_Sommer?= <joerg@alea.gnuu.de>, Jeff Garzik <jgarzik@redhat.com>, Sergei Shtylyov <sshtylyov@mvista.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Thu, Apr 12, 2012 at 1:50 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> Hi,
>
> RESEND: add Jeff's ACK.

James, ping?

Lin Ming

>
> These 2 patches fix bug report at:
>
> http://marc.info/?l=3Dlinux-ide&m=3D133177818318187&w=3D2
>
> Please see the patches for more detail.
>
> [PATCH 1/2] [SCSI] scsi_lib: use correct DMA device in __scsi_alloc_q=
ueue
> [PATCH 2/2] libata: Pass correct DMA device to scsi host
>
> =A0drivers/ata/libata-scsi.c | =A0 =A03 ++-
> =A0drivers/scsi/scsi_lib.c =A0 | =A0 =A02 +-
> =A02 files changed, 3 insertions(+), 2 deletions(-)
>
> Thanks,
> Lin Ming
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
