From: Girish K S <girish.shivananjappa@linaro.org>
Subject: Re: [RFC PATCH 0/4] Add support for pci/non-pci probing for UFS
Date: Tue, 15 May 2012 08:23:11 +0530
Message-ID: <CAGxe1ZFbkRRuz93v5qfU7Am1N3briUMOxzxFybmv7k79cVp21Q@mail.gmail.com>
References: <1336993712-9111-1-git-send-email-girish.shivananjappa@linaro.org>
	<CAKYAXd-bng9OzQUVgrWXTkvdAMPXgHK6copKaAYwMCXFokhEWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:55658 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964856Ab2EOCxM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 May 2012 22:53:12 -0400
Received: by qadb17 with SMTP id b17so3292241qad.19
        for <linux-scsi@vger.kernel.org>; Mon, 14 May 2012 19:53:11 -0700 (PDT)
In-Reply-To: <CAKYAXd-bng9OzQUVgrWXTkvdAMPXgHK6copKaAYwMCXFokhEWA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, vinholikatti@gmail.com, santoshsy@gmail.com, patches@linaro.org

Sorry ,
I will rebase them to James' for-next treee. and resend

thanks and regards
Girish K S

On 15 May 2012 07:08, Namjae Jeon <linkinjeon@gmail.com> wrote:
> Hi. Girish.
>
> There are hunks when I try to patch.
> have you created patches on linux-next ?
>
> patching file drivers/scsi/ufs/ufs.h
> patching file drivers/scsi/ufs/ufshcd.c
> Hunk #10 FAILED at 826.
> Hunk #13 FAILED at 929.
> Hunk #15 succeeded at 1050 with fuzz 1 (offset 2 lines).
> Hunk #17 succeeded at 1193 (offset 2 lines).
> Hunk #19 succeeded at 1392 (offset 2 lines).
> Hunk #21 succeeded at 1571 (offset 2 lines).
> Hunk #23 succeeded at 1644 (offset 2 lines).
> Hunk #25 FAILED at 1724.
> 3 out of 25 hunks FAILED -- saving rejects to file drivers/scsi/ufs/u=
fshcd.c.rej
>
> And after testing, have you sent this patch ?
>
> Thanks.
>
> 2012/5/14, Girish K S <girish.shivananjappa@linaro.org>:
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
>> =A0drivers/scsi/ufs/ufshcd-pci.c =A0 | =A0217 ++++++++++++++++++++++
>> =A0drivers/scsi/ufs/ufshcd-pltfm.c | =A0191 ++++++++++++++++++++
>> =A0drivers/scsi/ufs/ufshcd.c =A0 =A0 =A0 | =A0377
>> +++++++++------------------------------
>> =A06 files changed, 623 insertions(+), 299 deletions(-)
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
