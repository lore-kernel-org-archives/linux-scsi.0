From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH 1/1] scsi: retrieve cache mode using ATA_16 if normal
 routine fails
Date: Tue, 13 Dec 2011 17:45:47 +0530
Message-ID: <CADDb1s1-bvwMBNh8k7MYDcWjgk694zFhFd5=6XZC8WgKJccyLQ@mail.gmail.com>
References: <1323688722-25400-1-git-send-email-amit.sahrawat83@gmail.com>
	<1323694267.20451.5.camel@dabdike>
	<CAKYAXd-3LYJUWbAqaT4XfbNXJ_F0L1Lxu1evUxLyu=poHLMFug@mail.gmail.com>
	<1323766382.8163.12.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36805 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752611Ab1LMMPt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Dec 2011 07:15:49 -0500
In-Reply-To: <1323766382.8163.12.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, Nam-Jae Jeon <namjae.jeon@samsung.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 2:23 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Tue, 2011-12-13 at 09:20 +0900, Namjae Jeon wrote:
>> > This whole patch looks like a layering violation. =A0Why not just =
update
>> > the SAT layer to translate the MODE SENSE correctly?
>> Would plz you explain more ? I didn't clearly understand your point =
yet.
>
> The ATA layer does translation for SCSI commands. =A0Just translate t=
he
> mode sense correctly to use IDENTIFY word 85. =A0It's a smaller patch=
 and
> no need for any changes in SCSI.
I have a confusion to this, can you please guide where exactly to look =
for this.
Is there any existing solution to this problem? I did a lot of
analysis and actually tried to make use of a number of USB HDD's from
different vendors to be very sure of my observations. Our's is a
target where-in we connect our HDD through the USB interface.
Do you mean that putting code changes at this place would have impact
on SATA HDD?
Please help more on this.
>
> Actually, looking at it, it seems to be correct ... why is it not
> working for you?
Again, if possible please share that code point, We can again check if
that is hitting in our case.
If need be I can provide the list of all the HDDs with their
manufaturer ID's - on which we tested.
Please let me know for this.
>
> James
>
>
Thanks & Regards,
Amit Sahrawat
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
