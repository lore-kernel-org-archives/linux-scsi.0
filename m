From: ygardi@codeaurora.org
Subject: Re: [PATCH v7 6/8] scsi: ufs: make the UFS variant a platform
 device
Date: Sun, 25 Oct 2015 10:50:42 -0000
Message-ID: <245c494679a40e4187287daa23e1e274.squirrel@www.codeaurora.org>
References: <1441205138-12664-1-git-send-email-ygardi@codeaurora.org>
    <1441205138-12664-7-git-send-email-ygardi@codeaurora.org>
    <2dce3d8d918e124eb29afa7a59607bca.squirrel@codeaurora.org>
    <4607478.zVSfzXyPzA@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37141 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbbJYKun (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Oct 2015 06:50:43 -0400
In-Reply-To: <4607478.zVSfzXyPzA@wuerfel>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: subhashj@codeaurora.org, Yaniv Gardi <ygardi@codeaurora.org>, robherring2@gmail.com, james.bottomley@hansenpartnership.com, pebolle@tiscali.nl, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, gbroner@codeaurora.org, draviv@codeaurora.org, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Sahitya Tummala <stummala@codeaurora.org>"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devic>

> On Thursday 22 October 2015 07:02:14 subhashj@codeaurora.org wrote:
>> >
>> >  Required properties:
>> > -- compatible        : compatible list, contains "jedec,ufs-1.1"
>> > +- compatible        : compatible list, contains "jedec,ufs-1.1" or
>> > +		      "qcom,msm8994-ufshc" or "qcom,msm8996-ufshc"
>>
>> Are we really using these "qcom,msm8994-ufshc" or "qcom,msm8996-ufshc"
>> compatible string anywhere?
>
> We should list them in either case, but it could be clarified as:
>
> compatible	: must contain "jedec,ufs-1.1", may also list one or more
> 		  of the following:
> 			"qcom,msm8994-ufshc"
> 			"qcom,msm8996-ufshc"
> 			"qcom,ufshc"
>
> 	Arnd
>

Shortly i will upload an updated v8.
Yaniv



