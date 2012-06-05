From: Girish K S <girish.shivananjappa@linaro.org>
Subject: Re: [PATCH V4 0/2] Add support for pci/non-pci probing for UFS
Date: Tue, 5 Jun 2012 18:49:35 +0530
Message-ID: <CAGxe1ZEwBLapzfK+2MeSqjDt55bJSLgo_7FAvicJKRmmW6X+eQ@mail.gmail.com>
References: <1338810188-30248-1-git-send-email-girish.shivananjappa@linaro.org>
	<CAGxe1ZGOrVaQNT=Bm9cdAoXc4vYLAaXCqV=TKOv3Oe39VhxqHg@mail.gmail.com>
	<CANfBPZ_OV7iY4Wg9N8m50jYEh-oypbMEaS5U7WN6H9459CsJjQ@mail.gmail.com>
	<CAGxe1ZHGW4-=PoXvYMPZfdGeoLQ5jSwUE7mZEaGDin3J98bLfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:63203 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934134Ab2FENTh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jun 2012 09:19:37 -0400
Received: by qabj40 with SMTP id j40so3327655qab.1
        for <linux-scsi@vger.kernel.org>; Tue, 05 Jun 2012 06:19:36 -0700 (PDT)
In-Reply-To: <CAGxe1ZHGW4-=PoXvYMPZfdGeoLQ5jSwUE7mZEaGDin3J98bLfg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "S, Venkatraman" <svenkatr@ti.com>
Cc: vinayak holikatti <vinholikatti@gmail.com>, Jej B <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, santoshsy@gmail.com, hch@infradead.org, patches@linaro.org

On 5 June 2012 18:32, Girish K S <girish.shivananjappa@linaro.org> wrot=
e:
> On 5 June 2012 15:11, S, Venkatraman <svenkatr@ti.com> wrote:
>> On Mon, Jun 4, 2012 at 5:15 PM, Girish K S
>> <girish.shivananjappa@linaro.org> wrote:
>>> Hi maintainers,
>>> pls add
>>> Reviewed-by: Venkatraman S <svenkatr@ti.com>
>>> when you accept this patch
>>>
>> Girish,
>> Now that you have resent the patches, you could have added the
>> "Reviewed-by" tag yourself.
>> Anyway, there seems to be some problems with your mailer and the
>> patches have a lot of trailing ^M characters.
>> I also get this checkpatch warning:
>> WARNING: please write a paragraph that describes the config symbol f=
ully
>> #29: FILE: drivers/scsi/ufs/Kconfig:45:
>> =A0config SCSI_UFSHCD
> i checked the patch again. This line is not modified by my patch.
> unable to understand the reason for it.
The checkpatch mandates the Kconfig's config option's description to
be min 4 lines.
I added 2 more lines of description to remove the warning.
will resend the patches
>>
>> James,
>> =A0These patched depend on some cleanups that I posted to the same
>> files a few weeks ago and now they are in Andrew Morton's queue. I'm
>> not very familiar with the process but I assumed it will get into
>> 3.5-rc1 as part of Andrew's pull request or equivalent. =A0Should I
>> resend them to you and ask it to be dropped from Andrew Morton's tre=
e
>> ?
>>
>> Thanks,
>> Venkat.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
