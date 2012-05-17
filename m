From: "S, Venkatraman" <svenkatr@ti.com>
Subject: Re: [RFC V2 0/2] Add support for pci/non-pci probing for UFS
Date: Thu, 17 May 2012 17:47:17 +0530
Message-ID: <CANfBPZ90AWDiGd1CrB=4V_THhfAbX57EgqriLM+v08kDbaTTSA@mail.gmail.com>
References: <1337253726-2666-1-git-send-email-girish.shivananjappa@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:46701 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755429Ab2EQMRk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 May 2012 08:17:40 -0400
Received: by bkwj10 with SMTP id j10so1653363bkw.4
        for <linux-scsi@vger.kernel.org>; Thu, 17 May 2012 05:17:37 -0700 (PDT)
In-Reply-To: <1337253726-2666-1-git-send-email-girish.shivananjappa@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Girish K S <girish.shivananjappa@linaro.org>
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, vinholikatti@gmail.com, santoshsy@gmail.com, hch@infradead.org, patches@linaro.org

On Thu, May 17, 2012 at 4:52 PM, Girish K S
<girish.shivananjappa@linaro.org> wrote:
> The existing UFS driver is tightly bound to only pci specific devices=
=2E
> It cannot work for non-pci devices.
>
> "SCSI: UFS: Create separate UFS core and pci modules" patch splits th=
e
> ufs driver into core driver and pci probe driver.
>
> "SCSI: UFS: Add platform support for ufs host controller" patch adds
> support for the platform probing for non-pci devices
>
> changes in v2:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Reduced the number of patches from 4 t=
o 2. merged the core and
> pci probing modules as single patch. suggested by Christoph Hellwig.
>
> changes in v1:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Changes suggested by Namjae to split t=
he existing driver as 3 independent
> modules and retain the author's name in the files created by me.
>
> Girish K S (2):
> =A0SCSI: UFS: Create separate UFS core and pci modules
> =A0SCSI: UFS: Add platform support for ufs host controller
>
> =A0drivers/scsi/ufs/Kconfig =A0 =A0 =A0 =A0| =A0 32 +++-
> =A0drivers/scsi/ufs/Makefile =A0 =A0 =A0 | =A0 =A01 +
> =A0drivers/scsi/ufs/ufs.h =A0 =A0 =A0 =A0 =A0| =A0103 +++++++++++
> =A0drivers/scsi/ufs/ufshcd-pci.c =A0 | =A0217 +++++++++++++++++++++++
> =A0drivers/scsi/ufs/ufshcd-pltfm.c | =A0191 ++++++++++++++++++++
> =A0drivers/scsi/ufs/ufshcd.c =A0 =A0 =A0 | =A0374 ++++++++++---------=
-------------------
> =A06 files changed, 640 insertions(+), 278 deletions(-)
> =A0create mode 100644 drivers/scsi/ufs/ufshcd-pci.c
> =A0create mode 100644 drivers/scsi/ufs/ufshcd-pltfm.c
>
> --
> 1.7.4.1

While not directly related to your changes, the macro UFS_MASK is used
in several places in ufshci.h, but there is no definition. Care to fix
that ?
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
