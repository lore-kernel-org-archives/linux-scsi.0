From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH 1/1] scsi: retrieve cache mode using ATA_16 if normal
 routine fails
Date: Wed, 14 Dec 2011 09:14:14 +0530
Message-ID: <CADDb1s1JwTbeFMsL4Vcz99PhgZKAMG05rgqankYCNeJLFRQSMg@mail.gmail.com>
References: <1323688722-25400-1-git-send-email-amit.sahrawat83@gmail.com>
	<1323694267.20451.5.camel@dabdike>
	<CAKYAXd-3LYJUWbAqaT4XfbNXJ_F0L1Lxu1evUxLyu=poHLMFug@mail.gmail.com>
	<1323766382.8163.12.camel@dabdike>
	<4EE7B7B9.7060700@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36682 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753515Ab1LNDoP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Dec 2011 22:44:15 -0500
In-Reply-To: <4EE7B7B9.7060700@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Namjae Jeon <linkinjeon@gmail.com>, Nam-Jae Jeon <namjae.jeon@samsung.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Jeff/James,

Just to add a thought - this issues is not related with ATA, this is
primarily related with HDD's with a USB interface i.e., SCSI <-> USB.
And, when I check my kernel config, CONFIG_ATA is not selected,
libata-scsi - this gets compiled only in case CONFIG_ATA is on.
Are these two things inter-related?

Please let us know.

Thanks & Regards,
Amit Sahrawat

On Wed, Dec 14, 2011 at 2:08 AM, Jeff Garzik <jeff@garzik.org> wrote:
> On 12/13/2011 03:53 AM, James Bottomley wrote:
>>
>> On Tue, 2011-12-13 at 09:20 +0900, Namjae Jeon wrote:
>>>>
>>>> This whole patch looks like a layering violation. =A0Why not just =
update
>>>> the SAT layer to translate the MODE SENSE correctly?
>>>
>>> Would plz you explain more ? I didn't clearly understand your point=
 yet.
>>
>>
>> The ATA layer does translation for SCSI commands. =A0Just translate =
the
>> mode sense correctly to use IDENTIFY word 85. =A0It's a smaller patc=
h and
>> no need for any changes in SCSI.
>
>
> Correct.
>
>
>> Actually, looking at it, it seems to be correct ... why is it not
>> working for you?
>
>
> Indeed -- the patch attempts to address a problem that the libata-scs=
i
> translation module already handles.
>
> I would look at why the device is not properly reporting that already=
=2E If
> necessary, we would update libata not SCSI.
>
> =A0 =A0 =A0 =A0Jeff
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
