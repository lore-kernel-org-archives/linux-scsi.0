From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Subject: RE: [PATCH v3 0/2] mpt2sas/mpt3sas resource cleanup fixes
Date: Wed, 14 Aug 2013 18:39:47 +0530
Message-ID: <DCD177647606E9419ED923E0C8C4AA723006D280A8@inbmail02.lsi.com>
References: <1375994739-11146-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-db9lp0250.outbound.messaging.microsoft.com ([213.199.154.250]:2447
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932282Ab3HNNJ4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Aug 2013 09:09:56 -0400
In-Reply-To: <1375994739-11146-1-git-send-email-joe.lawrence@stratus.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi James,

This patch set seem to be fine. Please consider these patches.

Regards,
Sreekanth.

>-----Original Message-----
>From: Joe Lawrence [mailto:joe.lawrence@stratus.com]
>Sent: Friday, August 09, 2013 2:16 AM
>To: linux-scsi@vger.kernel.org
>Cc: Reddy, Sreekanth; Joe Lawrence
>Subject: [PATCH v3 0/2] mpt2sas/mpt3sas resource cleanup fixes
>
>Hi Sreekanth,
>
>Here are the patches that address your offlist feedback and testing of earlier
>patchset versions.
>
>I tested with as many early exits as I could think of inside of
>mpt2sas_base_map_resources to verify, so I believe all error paths should be
>safe and message-log-friendly.
>
>Regards,
>
>Joe
>
>---
>
>Changes from v2 (offlist):
>  - Clear ioc->bars if pci_enable_device_mem fails.
>  - pci_release_selected_regions verifies non-zero bar pointer, so as
>    long as it's cleared when not actually enabled, we don't need to
>    check it first.
>
>Changes from v1:
>  - Verify that the PCI device is enabled before disabling it.
>  - Verify that the PCI BARs have been enabled before releasing them.
>
>Joe Lawrence (2):
>  mpt2sas: fix cleanup on controller resource mapping failure
>  mpt3sas: fix cleanup on controller resource mapping failure
>
> drivers/scsi/mpt2sas/mpt2sas_base.c  | 27 +++++++++++++++++----------
>drivers/scsi/mpt2sas/mpt2sas_scsih.c |  1 +
>drivers/scsi/mpt3sas/mpt3sas_base.c  | 27 +++++++++++++++++----------
>drivers/scsi/mpt3sas/mpt3sas_scsih.c |  1 +
> 4 files changed, 36 insertions(+), 20 deletions(-)
>
>--
>1.8.3.1
>


