From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [RFC V1 0/4] Add support for pci/non-pci probing for UFS
Date: Wed, 16 May 2012 10:48:18 +0900
Message-ID: <CAKYAXd91z1obe+QjEsp8Bzjore-7jMCdMg-K4DgO8c6a7=8j8A@mail.gmail.com>
References: <1337083436-4204-1-git-send-email-girish.shivananjappa@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46207 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab2EPBsU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 May 2012 21:48:20 -0400
Received: by wibhj8 with SMTP id hj8so3419328wib.1
        for <linux-scsi@vger.kernel.org>; Tue, 15 May 2012 18:48:19 -0700 (PDT)
In-Reply-To: <1337083436-4204-1-git-send-email-girish.shivananjappa@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Girish K S <girish.shivananjappa@linaro.org>
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, vinholikatti@gmail.com, santoshsy@gmail.com, patches@linaro.org

Hi. Girish.

There still are hunks on james git.

patching file drivers/scsi/ufs/ufs.h
patching file drivers/scsi/ufs/ufshcd.c
Hunk #13 FAILED at 929.
Hunk #25 succeeded at 1724 with fuzz 2.
1 out of 25 hunks FAILED -- saving rejects to file drivers/scsi/ufs/ufshcd.c.rej

There are new ufs 3 patches pushed by andrew on linux-next.
I think that you should make patch-set on linux-next again.

Thanks.

2012/5/15, Girish K S <girish.shivananjappa@linaro.org>:
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
> changes in v1:
> 		Changes suggested by Namjae to split the existing driver as 3 independent
> modules and retain the author's name in the files created by me.
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
>  drivers/scsi/ufs/ufshcd-pltfm.c |  191 +++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.c       |  383
> ++++++++++-----------------------------
>  6 files changed, 637 insertions(+), 291 deletions(-)
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
