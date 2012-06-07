From: vinayak holikatti <vinholikatti@gmail.com>
Subject: Re: [RFC PATCH 0/4] Add support for pci/non-pci probing for UFS
Date: Thu, 7 Jun 2012 09:52:44 +0530
Message-ID: <CAKVbJB-C1XvTBRcrU0n3KStq4JHhzqV4AhJiQsw+o8f8JBRg1g@mail.gmail.com>
References: <1336993712-9111-1-git-send-email-girish.shivananjappa@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63306 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933312Ab2FGEWo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jun 2012 00:22:44 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so478700pbb.19
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jun 2012 21:22:44 -0700 (PDT)
In-Reply-To: <1336993712-9111-1-git-send-email-girish.shivananjappa@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Girish K S <girish.shivananjappa@linaro.org>
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, santoshsy@gmail.com, patches@linaro.org

Hi Girish,

It was already communicated to you internally that the the platform
support for UFSHCD has been implemented, PCI and Platform code has
been segregated and we are in the final stages of testing. We would
send the code for internal review before posting the patches to SCSI
mailing list. So the reason for posting your untested patches within
few days after you were informed is not clear. We don't want to put
effort reviewing and testing these patch again, since we already have
working code. Working platform patches for UFSHCD will be posted soon.


On Mon, May 14, 2012 at 4:38 PM, Girish K S
<girish.shivananjappa@linaro.org> wrote:
> The existing UFS driver is tightly bound to only pci specific devices=
=2E
> It cannot work for non-pci devices.
>
> "SCSI: UFS: remove all pci code from core driver" patch removes all t=
he
> pci specific code from the core driver to make it generic
>
> "SCSI: UFS: Add support for pci probe" patch adds a new file to suppo=
rt
> pci probing.
>
> "SCSI: UFS: Add platform support for ufs host controller" patch adds =
a new
> file to support platform device probe
>
> "SCSI: UFS: Added support of PCI/PLTFM for UFS" patch adds the menu o=
ption
> in Kconfig and Makefile to enable/disable the specific option
>
> Girish K S (4):
> =A0SCSI: UFS: remove all pci code from core driver
> =A0SCSI: UFS: Add support for pci probe
> =A0SCSI: UFS: Add platform support for ufs host controller
> =A0SCSI: UFS: Added support of PCI/PLTFM for UFS
>
> =A0drivers/scsi/ufs/Kconfig =A0 =A0 =A0 =A0| =A0 32 +++-
> =A0drivers/scsi/ufs/Makefile =A0 =A0 =A0 | =A0 =A02 +
> =A0drivers/scsi/ufs/ufs.h =A0 =A0 =A0 =A0 =A0| =A0103 +++++++++++
> =A0drivers/scsi/ufs/ufshcd-pci.c =A0 | =A0217 ++++++++++++++++++++++
> =A0drivers/scsi/ufs/ufshcd-pltfm.c | =A0191 ++++++++++++++++++++
> =A0drivers/scsi/ufs/ufshcd.c =A0 =A0 =A0 | =A0377 +++++++++----------=
--------------------
> =A06 files changed, 623 insertions(+), 299 deletions(-)
> =A0create mode 100644 drivers/scsi/ufs/ufshcd-pci.c
> =A0create mode 100644 drivers/scsi/ufs/ufshcd-pltfm.c
>
> --
> 1.7.4.1
>



--=20
Regards,
Vinayak Holikatti
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
