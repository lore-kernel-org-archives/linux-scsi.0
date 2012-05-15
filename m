From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [RFC PATCH 0/4] Add support for pci/non-pci probing for UFS
Date: Tue, 15 May 2012 10:38:16 +0900
Message-ID: <CAKYAXd-bng9OzQUVgrWXTkvdAMPXgHK6copKaAYwMCXFokhEWA@mail.gmail.com>
References: <1336993712-9111-1-git-send-email-girish.shivananjappa@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:49019 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932402Ab2EOBiR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 May 2012 21:38:17 -0400
Received: by weyu7 with SMTP id u7so2165799wey.19
        for <linux-scsi@vger.kernel.org>; Mon, 14 May 2012 18:38:16 -0700 (PDT)
In-Reply-To: <1336993712-9111-1-git-send-email-girish.shivananjappa@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Girish K S <girish.shivananjappa@linaro.org>
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, vinholikatti@gmail.com, santoshsy@gmail.com, patches@linaro.org

Hi. Girish.

There are hunks when I try to patch.
have you created patches on linux-next ?

patching file drivers/scsi/ufs/ufs.h
patching file drivers/scsi/ufs/ufshcd.c
Hunk #10 FAILED at 826.
Hunk #13 FAILED at 929.
Hunk #15 succeeded at 1050 with fuzz 1 (offset 2 lines).
Hunk #17 succeeded at 1193 (offset 2 lines).
Hunk #19 succeeded at 1392 (offset 2 lines).
Hunk #21 succeeded at 1571 (offset 2 lines).
Hunk #23 succeeded at 1644 (offset 2 lines).
Hunk #25 FAILED at 1724.
3 out of 25 hunks FAILED -- saving rejects to file drivers/scsi/ufs/ufshcd.c.rej

And after testing, have you sent this patch ?

Thanks.

2012/5/14, Girish K S <girish.shivananjappa@linaro.org>:
> The existing UFS driver is tightly bound to only pci specific devices.
> It cannot work for non-pci devices.
>
> "SCSI: UFS: remove all pci code from core driver" patch removes all the
> pci specific code from the core driver to make it generic
>
> "SCSI: UFS: Add support for pci probe" patch adds a new file to support
> pci probing.
>
> "SCSI: UFS: Add platform support for ufs host controller" patch adds a new
> file to support platform device probe
>
> "SCSI: UFS: Added support of PCI/PLTFM for UFS" patch adds the menu option
> in Kconfig and Makefile to enable/disable the specific option
>
> Girish K S (4):
>   SCSI: UFS: remove all pci code from core driver
>   SCSI: UFS: Add support for pci probe
>   SCSI: UFS: Add platform support for ufs host controller
>   SCSI: UFS: Added support of PCI/PLTFM for UFS
>
>  drivers/scsi/ufs/Kconfig        |   32 +++-
>  drivers/scsi/ufs/Makefile       |    2 +
>  drivers/scsi/ufs/ufs.h          |  103 +++++++++++
>  drivers/scsi/ufs/ufshcd-pci.c   |  217 ++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd-pltfm.c |  191 ++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.c       |  377
> +++++++++------------------------------
>  6 files changed, 623 insertions(+), 299 deletions(-)
>  create mode 100644 drivers/scsi/ufs/ufshcd-pci.c
>  create mode 100644 drivers/scsi/ufs/ufshcd-pltfm.c
>
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
