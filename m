From: ygardi@codeaurora.org
Subject: Re: [PATCH v1 3/3] scsi: ufs-qcom: update configuration option of
 SCSI_UFS_QCOM component
Date: Thu, 21 May 2015 17:18:10 -0000
Message-ID: <4bb10330303f7911f480632ed26b1d03.squirrel@www.codeaurora.org>
References: <1432043231-31102-1-git-send-email-ygardi@codeaurora.org>
    <1432043231-31102-4-git-send-email-ygardi@codeaurora.org>
    <1432106479.21715.33.camel@x220> <1432110155.21715.45.camel@x220>
    <1432192570.21715.107.camel@x220>
    <13293a67c19b0c18d2c99386dcf159ea.squirrel@www.codeaurora.org>
    <1432203266.21715.148.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35457 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbbEURSL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2015 13:18:11 -0400
In-Reply-To: <1432203266.21715.148.camel@x220>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: ygardi@codeaurora.org, james.bottomley@hansenpartnership.com, kishon@ti.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, gbroner@codeaurora.org, dovl@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>

> On Thu, 2015-05-21 at 10:09 +0000, ygardi@codeaurora.org wrote:
>> > On Wed, 2015-05-20 at 10:22 +0200, Paul Bolle wrote:
>> > Am I missing something obvious here? Because ufs-qcom currently looks
>> > pointless to me, and I actually see little reason to even have it in
>> the
>> > mainline tree.
>> >
>>
>> we haven't uploaded yet the patch that binds qcom vops to the driver,
>> but
>> we will soon.
>
> Perhaps you could make that patch part of v2 of this series. I see
> little point in this series without that patch. Perhaps someone else
> still cares about it, but I'm not looking at it anymore.
>

fair enough. i will upload a V2 series soon. thanks for your inputs.

> Thanks,
>
>
> Paul Bolle
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


