From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [RFC RESEND 0/4] Add support for pci/non-pci probing for UFS
Date: Tue, 15 May 2012 19:51:34 +0900
Message-ID: <CAKYAXd9ymY=P7-ury2wn7divB+SKCAv7Gj0TqSKfq_pT3GGegQ@mail.gmail.com>
References: <1337074587-29021-1-git-send-email-girish.shivananjappa@linaro.org>
	<CAKYAXd-BSeryh7KRTVdOrt+othr7ioB6RbjHcJQ2e14YDoVrEw@mail.gmail.com>
	<CAGxe1ZEWDJMT-2w9Fsd=r0Fcpe77wCz+o69j+Z7ds6C-tRQUag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:41770 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575Ab2EOKvf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 May 2012 06:51:35 -0400
Received: by weyu7 with SMTP id u7so2386704wey.19
        for <linux-scsi@vger.kernel.org>; Tue, 15 May 2012 03:51:34 -0700 (PDT)
In-Reply-To: <CAGxe1ZEWDJMT-2w9Fsd=r0Fcpe77wCz+o69j+Z7ds6C-tRQUag@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Girish K S <girish.shivananjappa@linaro.org>
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, vinholikatti@gmail.com, santoshsy@gmail.com, patches@linaro.org

2012/5/15, Girish K S <girish.shivananjappa@linaro.org>:
> On 15 May 2012 16:08, Namjae Jeon <linkinjeon@gmail.com> wrote:
>> Hi. Girish.
>>
>> Why have you not separated 3 modules ?
> I didnt understand what u mean?
You told me that you will try to divide ufshcd.ko, ufshcd_pci.ko and
ufshcd_pltm.ko.
Thanks.
>>
>> Thanks.
>>
>> 2012/5/15, Girish K S <girish.shivananjappa@linaro.org>:
>>> The existing UFS driver is tightly bound to only pci specific devices.
>>> It cannot work for non-pci devices.
>>>
>>> "SCSI: UFS: remove all pci code from core driver" patch removes all the
>>> pci specific code from the core driver to make it generic
>>>
>>> "SCSI: UFS: Add support for pci probe" patch adds a new file to support
>>> pci probing.
>>>
>>> "SCSI: UFS: Add platform support for ufs host controller" patch adds a
>>> new
>>> file to support platform device probe
>>>
>>> "SCSI: UFS: Added support of PCI/PLTFM for UFS" patch adds the menu
>>> option
>>> in Kconfig and Makefile to enable/disable the specific option
>>>
>>> Girish K S (4):
>>>   SCSI: UFS: remove all pci code from core driver
>>>   SCSI: UFS: Add support for pci probe
>>>   SCSI: UFS: Add platform support for ufs host controller
>>>   SCSI: UFS: Added support of PCI/PLTFM for UFS
>>>
>>>  drivers/scsi/ufs/Kconfig        |   32 +++-
>>>  drivers/scsi/ufs/Makefile       |    2 +
>>>  drivers/scsi/ufs/ufs.h          |  103 +++++++++++
>>>  drivers/scsi/ufs/ufshcd-pci.c   |  218 ++++++++++++++++++++++
>>>  drivers/scsi/ufs/ufshcd-pltfm.c |  191 ++++++++++++++++++++
>>>  drivers/scsi/ufs/ufshcd.c       |  377
>>> +++++++++------------------------------
>>>  6 files changed, 624 insertions(+), 299 deletions(-)
>>>  create mode 100644 drivers/scsi/ufs/ufshcd-pci.c
>>>  create mode 100644 drivers/scsi/ufs/ufshcd-pltfm.c
>>>
>>> --
>>> 1.7.4.1
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>
