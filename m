From: Girish K S <girish.shivananjappa@linaro.org>
Subject: Re: [RFC RESEND 0/4] Add support for pci/non-pci probing for UFS
Date: Tue, 15 May 2012 16:11:46 +0530
Message-ID: <CAGxe1ZEWDJMT-2w9Fsd=r0Fcpe77wCz+o69j+Z7ds6C-tRQUag@mail.gmail.com>
References: <1337074587-29021-1-git-send-email-girish.shivananjappa@linaro.org>
	<CAKYAXd-BSeryh7KRTVdOrt+othr7ioB6RbjHcJQ2e14YDoVrEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41574 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab2EOKls convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 May 2012 06:41:48 -0400
Received: by qcro28 with SMTP id o28so4004325qcr.19
        for <linux-scsi@vger.kernel.org>; Tue, 15 May 2012 03:41:47 -0700 (PDT)
In-Reply-To: <CAKYAXd-BSeryh7KRTVdOrt+othr7ioB6RbjHcJQ2e14YDoVrEw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, vinholikatti@gmail.com, santoshsy@gmail.com, patches@linaro.org

On 15 May 2012 16:08, Namjae Jeon <linkinjeon@gmail.com> wrote:
> Hi. Girish.
>
> Why have you not separated 3 modules ?
I didnt understand what u mean?
>
> Thanks.
>
> 2012/5/15, Girish K S <girish.shivananjappa@linaro.org>:
>> The existing UFS driver is tightly bound to only pci specific device=
s.
>> It cannot work for non-pci devices.
>>
>> "SCSI: UFS: remove all pci code from core driver" patch removes all =
the
>> pci specific code from the core driver to make it generic
>>
>> "SCSI: UFS: Add support for pci probe" patch adds a new file to supp=
ort
>> pci probing.
>>
>> "SCSI: UFS: Add platform support for ufs host controller" patch adds=
 a new
>> file to support platform device probe
>>
>> "SCSI: UFS: Added support of PCI/PLTFM for UFS" patch adds the menu =
option
>> in Kconfig and Makefile to enable/disable the specific option
>>
>> Girish K S (4):
>> =A0 SCSI: UFS: remove all pci code from core driver
>> =A0 SCSI: UFS: Add support for pci probe
>> =A0 SCSI: UFS: Add platform support for ufs host controller
>> =A0 SCSI: UFS: Added support of PCI/PLTFM for UFS
>>
>> =A0drivers/scsi/ufs/Kconfig =A0 =A0 =A0 =A0| =A0 32 +++-
>> =A0drivers/scsi/ufs/Makefile =A0 =A0 =A0 | =A0 =A02 +
>> =A0drivers/scsi/ufs/ufs.h =A0 =A0 =A0 =A0 =A0| =A0103 +++++++++++
>> =A0drivers/scsi/ufs/ufshcd-pci.c =A0 | =A0218 ++++++++++++++++++++++
>> =A0drivers/scsi/ufs/ufshcd-pltfm.c | =A0191 ++++++++++++++++++++
>> =A0drivers/scsi/ufs/ufshcd.c =A0 =A0 =A0 | =A0377
>> +++++++++------------------------------
>> =A06 files changed, 624 insertions(+), 299 deletions(-)
>> =A0create mode 100644 drivers/scsi/ufs/ufshcd-pci.c
>> =A0create mode 100644 drivers/scsi/ufs/ufshcd-pltfm.c
>>
>> --
>> 1.7.4.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
