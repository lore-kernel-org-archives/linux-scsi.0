From: Girish K S <girish.shivananjappa@linaro.org>
Subject: Re: [RFC V1 0/4] Add support for pci/non-pci probing for UFS
Date: Wed, 16 May 2012 11:40:56 +0530
Message-ID: <CAGxe1ZGo-i2pNNteTh-Eo7G-9dmqF2tPwND3DHvpw7Se6_CTOg@mail.gmail.com>
References: <1337083436-4204-1-git-send-email-girish.shivananjappa@linaro.org>
	<CAKYAXd91z1obe+QjEsp8Bzjore-7jMCdMg-K4DgO8c6a7=8j8A@mail.gmail.com>
	<CAGxe1ZGhmM65KKyPQR12ZpZ4KHzb8NPTrJk9vQTaX8TN_idiBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:62927 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab2EPGLA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 May 2012 02:11:00 -0400
Received: by qabj40 with SMTP id j40so528757qab.1
        for <linux-scsi@vger.kernel.org>; Tue, 15 May 2012 23:10:59 -0700 (PDT)
In-Reply-To: <CAGxe1ZGhmM65KKyPQR12ZpZ4KHzb8NPTrJk9vQTaX8TN_idiBQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, vinholikatti@gmail.com, santoshsy@gmail.com, patches@linaro.org

Hi James / maintainers,
can you please confirm whether the patches have to be rebased to
James's for-next / Linux-next branch.

regards
Girish K S

On 16 May 2012 10:06, Girish K S <girish.shivananjappa@linaro.org> wrot=
e:
> On 16 May 2012 07:18, Namjae Jeon <linkinjeon@gmail.com> wrote:
>> Hi. Girish.
>>
>> There still are hunks on james git.
>>
>> patching file drivers/scsi/ufs/ufs.h
>> patching file drivers/scsi/ufs/ufshcd.c
>> Hunk #13 FAILED at 929.
>> Hunk #25 succeeded at 1724 with fuzz 2.
>> 1 out of 25 hunks FAILED -- saving rejects to file drivers/scsi/ufs/=
ufshcd.c.rej
>>
>> There are new ufs 3 patches pushed by andrew on linux-next.
>> I think that you should make patch-set on linux-next again.
> Ok i Will make patches on linux-next.
>>
>> Thanks.
>>
>> 2012/5/15, Girish K S <girish.shivananjappa@linaro.org>:
>>> The existing UFS driver is tightly bound to only pci specific devic=
es.
>>> It cannot work for non-pci devices.
>>>
>>> "SCSI: UFS: remove all pci code from core driver" patch removes all=
 the
>>> pci specific code from the core driver to make it generic
>>>
>>> "SCSI: UFS: Add support for pci probe" patch adds a new file to sup=
port
>>> pci probing.
>>>
>>> "SCSI: UFS: Add platform support for ufs host controller" patch add=
s a new
>>> file to support platform device probe
>>>
>>> "SCSI: UFS: Added support of PCI/PLTFM for UFS" patch adds the menu=
 option
>>> in Kconfig and Makefile to enable/disable the specific option
>>>
>>> changes in v1:
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 Changes suggested by Namjae to split th=
e existing driver as 3 independent
>>> modules and retain the author's name in the files created by me.
>>>
>>> Girish K S (4):
>>> =A0 SCSI: UFS: remove all pci code from core driver
>>> =A0 SCSI: UFS: Add support for pci probe
>>> =A0 SCSI: UFS: Add platform support for ufs host controller
>>> =A0 SCSI: UFS: Added support of PCI/PLTFM for UFS
>>>
>>> =A0drivers/scsi/ufs/Kconfig =A0 =A0 =A0 =A0| =A0 32 +++-
>>> =A0drivers/scsi/ufs/Makefile =A0 =A0 =A0 | =A0 =A02 +
>>> =A0drivers/scsi/ufs/ufs.h =A0 =A0 =A0 =A0 =A0| =A0103 +++++++++++
>>> =A0drivers/scsi/ufs/ufshcd-pci.c =A0 | =A0217 +++++++++++++++++++++=
+
>>> =A0drivers/scsi/ufs/ufshcd-pltfm.c | =A0191 +++++++++++++++++++
>>> =A0drivers/scsi/ufs/ufshcd.c =A0 =A0 =A0 | =A0383
>>> ++++++++++-----------------------------
>>> =A06 files changed, 637 insertions(+), 291 deletions(-)
>>> =A0create mode 100644 drivers/scsi/ufs/ufshcd-pci.c
>>> =A0create mode 100644 drivers/scsi/ufs/ufshcd-pltfm.c
>>>
>>> --
>>> 1.7.4.1
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-scs=
i" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
