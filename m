From: "S, Venkatraman" <svenkatr@ti.com>
Subject: Re: [RFC V4 0/2] Add support for pci/non-pci probing for UFS
Date: Wed, 23 May 2012 14:36:17 +0530
Message-ID: <CANfBPZ8K-jh4L04wrMbodjBTTAtWd8FraW1QZ4NXRSdsu39AzA@mail.gmail.com>
References: <1337686410-19206-1-git-send-email-girish.shivananjappa@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:55011 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752045Ab2EWJGk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 May 2012 05:06:40 -0400
Received: by bkcjc3 with SMTP id jc3so10369014bkc.39
        for <linux-scsi@vger.kernel.org>; Wed, 23 May 2012 02:06:38 -0700 (PDT)
In-Reply-To: <1337686410-19206-1-git-send-email-girish.shivananjappa@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Girish K S <girish.shivananjappa@linaro.org>
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, vinholikatti@gmail.com, santoshsy@gmail.com, hch@infradead.org, patches@linaro.org

On Tue, May 22, 2012 at 5:03 PM, Girish K S
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
> changes in v4:
> =A0 =A0 =A0 =A0-Rebased to the latest linux-next/master branch.
> =A0 =A0 =A0 =A0-Removed the Copyright string from the module probe fu=
nction and
> deleted redundant code from ufshcd-pltfm.c suspend/resume functions.
>
> changes in v3:
> =A0 =A0 =A0 =A0-Modified the ufshcd.c ufshcd-pci.c ufshcd0pltfm.c to =
follow the
> driver module initialization standard. suggested by venkatraman.
>
> changes in v2:
> =A0 =A0 =A0 =A0-Reduced the number of patches from 4 to 2. merged the=
 core and
> pci probing modules as single patch. suggested by Christoph Hellwig.
>
> changes in v1:
> =A0 =A0 =A0 =A0-Changes suggested by Namjae to split the driver as 3 =
independent
> modules and retain the author's name in the files created by me.
>
> Girish K S (2):
> =A0SCSI: UFS: Create separate UFS core and pci modules
> =A0SCSI: UFS: Add platform support for ufs host controller
>
> =A0drivers/scsi/ufs/Kconfig =A0 =A0 =A0 =A0| =A0 32 +++-
> =A0drivers/scsi/ufs/Makefile =A0 =A0 =A0 | =A0 =A02 +
> =A0drivers/scsi/ufs/ufs.h =A0 =A0 =A0 =A0 =A0| =A0103 +++++++++++
> =A0drivers/scsi/ufs/ufshcd-pci.c =A0 | =A0206 ++++++++++++++++++++++
> =A0drivers/scsi/ufs/ufshcd-pltfm.c | =A0176 +++++++++++++++++++
> =A0drivers/scsi/ufs/ufshcd.c =A0 =A0 =A0 | =A0367 ++++++++++---------=
--------------------
> =A06 files changed, 608 insertions(+), 278 deletions(-)
> =A0create mode 100644 drivers/scsi/ufs/ufshcd-pci.c
> =A0create mode 100644 drivers/scsi/ufs/ufshcd-pltfm.c
>
> --
> 1.7.4.1
>
Thanks Girish.
V4 looks ok to me. If it helps, you can add
Reviewed-by: Venkatraman S <svenkatr@ti.com>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
