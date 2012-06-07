From: vinayak holikatti <vinholikatti@gmail.com>
Subject: Re: [RFC PATCH 0/4] Add support for pci/non-pci probing for UFS
Date: Thu, 7 Jun 2012 20:05:44 +0530
Message-ID: <CAKVbJB8h14AkxdEHG1oT0z_p_cXM-q=ekYVdhJ=Epo1ikwHh9A@mail.gmail.com>
References: <1336993712-9111-1-git-send-email-girish.shivananjappa@linaro.org>
	<CAKVbJB9Gqosh8T-vVeMgetNrmNhAYCYhG4R3JqWksFbyyqgQOw@mail.gmail.com>
	<CAGxe1ZHPHomNk8Dw_jroqLuxKxsoJi+r--xBKptm+0YY_DSv-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63220 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab2FGOfo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jun 2012 10:35:44 -0400
Received: by dady13 with SMTP id y13so956844dad.19
        for <linux-scsi@vger.kernel.org>; Thu, 07 Jun 2012 07:35:44 -0700 (PDT)
In-Reply-To: <CAGxe1ZHPHomNk8Dw_jroqLuxKxsoJi+r--xBKptm+0YY_DSv-Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Girish K S <girish.shivananjappa@linaro.org>
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, santoshsy@gmail.com, patches@linaro.org, vinayak holikatti <vinholikatti@gmail.com>

On Thu, Jun 7, 2012 at 12:15 PM, Girish K S
<girish.shivananjappa@linaro.org> wrote:
> On 7 June 2012 10:21, vinayak holikatti <vinholikatti@gmail.com> wrot=
e:
>> On Mon, May 14, 2012 at 4:38 PM, Girish K S
>> <girish.shivananjappa@linaro.org> wrote:
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
>>> Girish K S (4):
>>> =A0SCSI: UFS: remove all pci code from core driver
>>> =A0SCSI: UFS: Add support for pci probe
>>> =A0SCSI: UFS: Add platform support for ufs host controller
>>> =A0SCSI: UFS: Added support of PCI/PLTFM for UFS
>>>
>>> =A0drivers/scsi/ufs/Kconfig =A0 =A0 =A0 =A0| =A0 32 +++-
>>> =A0drivers/scsi/ufs/Makefile =A0 =A0 =A0 | =A0 =A02 +
>>> =A0drivers/scsi/ufs/ufs.h =A0 =A0 =A0 =A0 =A0| =A0103 +++++++++++
>>> =A0drivers/scsi/ufs/ufshcd-pci.c =A0 | =A0217 +++++++++++++++++++++=
+
>>> =A0drivers/scsi/ufs/ufshcd-pltfm.c | =A0191 ++++++++++++++++++++
>>> =A0drivers/scsi/ufs/ufshcd.c =A0 =A0 =A0 | =A0377 +++++++++--------=
----------------------
>>> =A06 files changed, 623 insertions(+), 299 deletions(-)
>>> =A0create mode 100644 drivers/scsi/ufs/ufshcd-pci.c
>>> =A0create mode 100644 drivers/scsi/ufs/ufshcd-pltfm.c
>>>
>>> --
>>> 1.7.4.1
>>>
>>
>> Hi Girish,
>>
>> It was already communicated to you internally that the the platform
>> support for UFSHCD has been implemented, PCI and Platform code has
> Only informed after i had sent the initial code internally. After
> effort has been spent
> on making the draft copy.
I had informed you about the work on platform support before you sent t=
he
patches internally.
>> been segregated and we are in the final stages of testing. We would
>> send the code for internal review before posting the patches to SCSI
> waited for more than 2 months time. when there was no reply, i did th=
e
> above mentioned draft and sent.
Reply to what? as I have mentioned above I had already informed you abo=
ut
the work on platform support.Also you are well aware of the internal
review process before posting the patches. If not, then read the mail
that was sent, even you are in the CC.
> But still i didnt get reply for that internal mail.
Immediate reply was sent to your mail. Stop covering the facts.
I still have the email records.
> Why didnt you object on the 1st RFC. Why did you wait for 4 revisions=
=2E
We had informed you before posting the patches itself  this is the
result of your negligence.
>> mailing list. So the reason for posting your untested patches within
> pls test this patch and then claim that it doesnt work. And the RFC
> was to push the
> pci and non pci separate framework. Hope its clear.
>> few days after you were informed is not clear. We don't want to put
>> effort reviewing and testing these patch again, since we already hav=
e
> Above statement shows the negligence of not testing the patch.
> I can post all the log messages of the test.
still the intent of the reply doesn't seem clear to you. Its simple,
since every one is busy, we don't want to do the same work twice.
We don't have any hidden agenda for not accepting your patches.
If some one without the knowledge of the internal work had posted the
patches it would make sense.
>> working code. Working platform patches for UFSHCD will be posted soo=
n.
> waiting for the same. and let experts in this list decide on that (fo=
r
> pci/non pci) framework
>>
>>
>> --
>> Regards,
>> Vinayak Holikatti
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
