From: Girish K S <girish.shivananjappa@linaro.org>
Subject: Re: [PATCH V4 0/2] Add support for pci/non-pci probing for UFS
Date: Tue, 5 Jun 2012 18:32:59 +0530
Message-ID: <CAGxe1ZHGW4-=PoXvYMPZfdGeoLQ5jSwUE7mZEaGDin3J98bLfg@mail.gmail.com>
References: <1338810188-30248-1-git-send-email-girish.shivananjappa@linaro.org>
	<CAGxe1ZGOrVaQNT=Bm9cdAoXc4vYLAaXCqV=TKOv3Oe39VhxqHg@mail.gmail.com>
	<CANfBPZ_OV7iY4Wg9N8m50jYEh-oypbMEaS5U7WN6H9459CsJjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:44187 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757929Ab2FENDA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jun 2012 09:03:00 -0400
Received: by qadb17 with SMTP id b17so2018922qad.19
        for <linux-scsi@vger.kernel.org>; Tue, 05 Jun 2012 06:03:00 -0700 (PDT)
In-Reply-To: <CANfBPZ_OV7iY4Wg9N8m50jYEh-oypbMEaS5U7WN6H9459CsJjQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "S, Venkatraman" <svenkatr@ti.com>
Cc: vinayak holikatti <vinholikatti@gmail.com>, Jej B <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, santoshsy@gmail.com, hch@infradead.org, patches@linaro.org

On 5 June 2012 15:11, S, Venkatraman <svenkatr@ti.com> wrote:
> On Mon, Jun 4, 2012 at 5:15 PM, Girish K S
> <girish.shivananjappa@linaro.org> wrote:
>> Hi maintainers,
>> pls add
>> Reviewed-by: Venkatraman S <svenkatr@ti.com>
>> when you accept this patch
>>
> Girish,
> Now that you have resent the patches, you could have added the
> "Reviewed-by" tag yourself.
> Anyway, there seems to be some problems with your mailer and the
> patches have a lot of trailing ^M characters.
> I also get this checkpatch warning:
> WARNING: please write a paragraph that describes the config symbol fu=
lly
> #29: FILE: drivers/scsi/ufs/Kconfig:45:
> =A0config SCSI_UFSHCD
i checked the patch again. This line is not modified by my patch.
unable to understand the reason for it.
>
> James,
> =A0These patched depend on some cleanups that I posted to the same
> files a few weeks ago and now they are in Andrew Morton's queue. I'm
> not very familiar with the process but I assumed it will get into
> 3.5-rc1 as part of Andrew's pull request or equivalent. =A0Should I
> resend them to you and ask it to be dropped from Andrew Morton's tree
> ?
>
> Thanks,
> Venkat.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
