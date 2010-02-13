From: "Caspar Smit" <c.smit@truebit.nl>
Subject: Re: Patch for MVSAS
Date: Sat, 13 Feb 2010 10:17:18 +0100 (CET)
Message-ID: <1088.62.195.29.195.1266052638.squirrel@ketsers.dhs.org>
References: <loom.20100210T002935-813@post.gmane.org>
    <73e903671002110150h3c4ae0dcq17625f6d9b545bf4@mail.gmail.com>
    <1265914540.13197.57.camel@mulgrave.site>
    <6B62480106F2B34D8404CF2FDAA4D9EF71F637D6DB@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN-99D05D88-A0F3-0C58-BFB2-2F138E38F61D>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 80-69-81-65.colo.transip.net ([80.69.81.65]:37951 "EHLO
	ns1.emsolutions.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab0BMJRp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Feb 2010 04:17:45 -0500
In-Reply-To: <6B62480106F2B34D8404CF2FDAA4D9EF71F637D6DB@CHN-HCLT-EVS06.HCLT.CORP.H
     CL.IN-99D05D88-A0F3-0C58-BFB2-2F138E38F61D>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech" <satyasrinivasp@hcl.in>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Thanks!

I will test this patch monday or tuesday with 3x 6480 controllers.
I'll let you know the results.

Kind regards,
Caspar


> Hi,
> The attached patch contains the fixes for SATA hot plugging, hot plug
> in/out of drives (SAS/SATA) from Expander while IO is going on and ta=
pe
> issues.
> Try with attached patch and let me know the results.
> Note: I have tested with only 64xx chipset.
>
> Srinivas.
>
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of James Bottomle=
y
> Sent: Friday, February 12, 2010 12:26 AM
> To: Kristleifur Da=F0ason
> Cc: Orion Poplawski; linux-scsi@vger.kernel.org
> Subject: Re: MVSAS status
>
> On Thu, 2010-02-11 at 09:50 +0000, Kristleifur Da=F0ason wrote:
>> On Tue, Feb 9, 2010 at 11:32 PM, Orion Poplawski <orion@cora.nwra.co=
m>
>> wrote:
>> >
>> > What's the status of the MVSAS patches posted in November '09?  I'=
m
>> just trying
>> > to get started with mvsas and running into the mvs_abort_task issu=
e.
>> At least
>> > one person has reported that stability improved, but it looks like
>> there were
>> > some other issues with the patches.  Any chance on seeing this in =
the
>> mainline
>> > kernel soon?  Are there updated versions?  A git tree to pull from=
?
>> >
>>
>> As far as I know, the patches from November were rejected because th=
e
>> patches themselves weren't solid enough - meaning there were some
>> cross-references between each of the seven patches, things like that=
=2E
>> The functionality was fine, at least a definite improvement. Ideally=
,
>> there would have been another set of patches to top things up and
>> really get everything running smoothly.
>
> There were two reasons for the reject.  The first was that the series
> just wasn't bisectable.  This is annoying but not completely fatal, a=
nd
> if it were a required bug fix I can just squash all the patches toget=
her
> to apply to make a single commit.  I hate doing this but I've done it
> before with problem vendor patch series.
>
> The bigger problem was there were several reports of the rate of kern=
el
> panics increasing with this patch series applied.  If the patch serie=
s
> is going to decrease stability, it's not worth applying.
>
> I can fix the first if someone can do a solid comparison and assure m=
e
> that the patch series does actually increase not decrease stability.
>
>> I haven't come across any patch traffic for the card after that Nove=
mber
>> batch.
>
> Yes, Marvell has gone radio silent.
>
>> In the interests of getting these amazingly cheap and effective card=
s
>> running properly on Linux, it would be extremely good if someone
>> experienced with Linux patches would get involved in the matter with
>> Mr. Andy Yan from Marvell, straighten things out, get the ball rolli=
ng
>> and make the driver stick in mainline. When I emailed him, Mr. Yan w=
as
>> very helpful and sent me the patches and some info. I tried to fix t=
he
>> patches myself but was in over my head. And had no time. Etc.
>
> OK, I'll try 1:1 email with Marvell and Andy and see what comes out.
>
> James
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> DISCLAIMER:
> ---------------------------------------------------------------------=
--------------------------------------------------
>
> The contents of this e-mail and any attachment(s) are confidential an=
d
> intended for the named recipient(s) only.
> It shall not attach any liability on the originator or HCL or its
> affiliates. Any views or opinions presented in
> this email are solely those of the author and may not necessarily ref=
lect
> the opinions of HCL or its affiliates.
> Any form of reproduction, dissemination, copying, disclosure,
> modification, distribution and / or publication of
> this message without the prior written consent of the author of this
> e-mail is strictly prohibited. If you have
> received this email in error please delete it and notify the sender
> immediately. Before opening any mail and
> attachments please check them for viruses and defect.
>
> ---------------------------------------------------------------------=
--------------------------------------------------
>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
