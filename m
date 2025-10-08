Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666C71758B;
	Wed,  8 Oct 2025 12:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759925425; cv=none; b=IMQWC4VowIkMJllePPEXXPfTTK4UWwBD/L0Zm6p3BYepGyvt6+jFv3La0dUH7LXbnruxRSRLc4Z1WlEkzfyVCgoTAuneqDieGjFS5hYO8cmUIubXJpB5dxSrcs73q01AMv34I9ZAZWwoO5QepcGFlITqpOJ3JYHdcfw7cISSS9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759925425; c=relaxed/simple;
	bh=jXnx8JiSjcT/CZMMwzNBjBGmLVfuIY1yxMSER2if6dM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ny9QqlM6MStjoh6PV3gO3iTPtXoK8g/M/xWAIQDfHKmHQ02ciQRglSCP5GMnOpSxARGKLzjhKMIt6fZG3sXbvraOfgiloiQlrh5jF5+qTFM56SFkDnzEYujOyekcRG0qAjLY+cn9gR+q/rEcADChkS9exMcvSa++EFEYF3lk/gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=Jjm8kFud; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="Jjm8kFud"
Received: from eig-obgw-6002b.ext.cloudfilter.net ([10.0.30.203])
	by cmsmtp with ESMTPS
	id 6Bf7vVYRxZx2i6SzovAB3F; Wed, 08 Oct 2025 12:10:16 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id 6SzmvxVFZwoI26SznvkbEA; Wed, 08 Oct 2025 12:10:15 +0000
X-Authority-Analysis: v=2.4 cv=PZX/hjhd c=1 sm=1 tr=0 ts=68e654a8
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=4oHATN8Nx7vVUZJYxp75bA==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=7T7KSl7uo7wA:10
 a=EQC9fkTS1saQ4aXz80UA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=xYX6OU9JNrHFPr8prv8u:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Uhm8m3dm0cws/aSg7uFXy6zdQFIsZg9S5XN1svy4Fdc=; b=Jjm8kFud2QXOpJjo4z2+vsEsyj
	5JibvFMUGXCvyd5kxn/H1LfbjfmLf5WApujShjuhZ0VzG+eAV1UtR3VaNP7iIu/ZBQu8fKm2e7YH5
	Wy6hD5neDgAbQEi38PYqiRtGDKXjOG3XyPFq3XljmgBeprne01ZLKNcn/PbNZJzvZVkKfGgWPdm3c
	Pyh0+rL7iFE3nkFfmzezLJ54px5sIL496OtzBO9cOVJBMDzs+JHrOiu46Gr3W4eah/8pJo5cADB7q
	XfafQSVnDUItQOMv20ZGYWZvHS5RorE5ZGfnMhxCJkVrSlx8AN6Kza1eQCaGSyJ76ieTzj13X4KWj
	7ZJPb/tA==;
Received: from [185.134.146.81] (port=50916 helo=[10.21.53.44])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1v6QTp-00000001r6Z-1KKv;
	Wed, 08 Oct 2025 04:29:06 -0500
Message-ID: <a157b190-74f4-443b-b52f-1fe0280f9bb3@embeddedor.com>
Date: Wed, 8 Oct 2025 10:28:38 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2][next] scsi: megaraid_sas: Avoid a couple
 -Wflex-array-member-not-at-end warnings
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <aM1E7Xa8qYdZ598N@kspp>
 <3a80fd1d-5a05-4db3-9dda-3ad38bedfb38@embeddedor.com>
 <4cf727c56c4fda8d28df920214b3824c9739bc8f.camel@HansenPartnership.com>
 <5b23ae5a-bd47-49c7-bca7-7019abc631f7@embeddedor.com>
 <ca77643eab8e10319db31690baaf031b8bfd32ae.camel@HansenPartnership.com>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <ca77643eab8e10319db31690baaf031b8bfd32ae.camel@HansenPartnership.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 185.134.146.81
X-Source-L: No
X-Exim-ID: 1v6QTp-00000001r6Z-1KKv
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([10.21.53.44]) [185.134.146.81]:50916
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 0
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfHIUrGjW2W/NYkwQQqEHn4Twd5RLi2aaug9otpg/Y9Pi38ogs8Xdo1DjY+dj6Sj1R48+Guc2GNVu3oSTXiLZhAfL8c1kWMCgQW2yPfIKrOnWtqw7qf6B
 nMEyDqiBiyPqYkxfNmxSN4WAAlq/bpwj+tiopSVK1c3Vzn8e7PXgYsdTOWV92aWMHQugBxNgBMvGSFglfklyOG6Ag8JPmxdNISXbbaFXC9Mj3qjNhscs0sWG
 DAZXV6/FYvRsk7zTtL1kYVgEG1ykQqLiYm6ZccKDw+8=



On 10/7/25 23:56, James Bottomley wrote:
> On Tue, 2025-10-07 at 15:18 +0100, Gustavo A. R. Silva wrote:
>>
>>
>> On 10/7/25 12:59, James Bottomley wrote:
>>> On Tue, 2025-10-07 at 11:43 +0100, Gustavo A. R. Silva wrote:
>>>> Hi all,
>>>>
>>>> Friendly ping: who can take this, please?
>>>
>>> After what happened with the qla2xxx driver, everyone is a bit wary
>>> of these changes, particularly when they affect structures shared
>>> with the hardware. Megaraid is a broadcom acquisition so although
>>> maintained it might take them a while to check this.
>>
>> I've been in constant communication with the people involved. So far,
>> none of them has expressed any concerns about this to me. However, I
>> appreciate your feedback.
>>
>> In any case, I promptly submitted a bugfix minutes after getting the
>> report.
> 
> I'm not criticizing the response, just saying that problems like this
> cause me to think that someone who understands and can test the
> hardware needs to look at this.  However ...

That's true. I agree.

> 
>>> However, you could help us with this: as I understand it (there is
>>> a bit of a no documentation problem here), the TRAILING_OVERLAP
>>> formalism merely gets the compiler not to warn about the situation
>>> rather than actually changing anything in the layout of the
>>> structure?  In which case you should be able to demonstrate the
>>> binary produced before and after this patch is the same, which
>>> would very much reduce the risk of taking it.
>>
>> This is quite simple. Here you go the pahole output before and after
>> changes.
>>
>> BEFORE CHANGES:
>>
>> pahole -C MR_FW_RAID_MAP_ALL drivers/scsi/megaraid/megaraid_sas_fp.o
>> struct MR_FW_RAID_MAP_ALL {
>>           struct MR_FW_RAID_MAP      raidMap;              /*     0
>> 10408 */
>>           /* --- cacheline 162 boundary (10368 bytes) was 40 bytes ago
>> --- */
>>           struct MR_LD_SPAN_MAP      ldSpanMap[64];        /* 10408
>> 161792 */
>>
>>           /* size: 172200, cachelines: 2691, members: 2 */
>>           /* last cacheline: 40 bytes */
>> };
>>
>> AFTER CHANGES:
>>
>> pahole -C MR_FW_RAID_MAP_ALL drivers/scsi/megaraid/megaraid_sas_fp.o
>> struct MR_FW_RAID_MAP_ALL {
>>           union {
>>                   struct MR_FW_RAID_MAP raidMap;           /*     0
>> 10408 */
>>                   struct {
>>                           unsigned char __offset_to_FAM[10408]; /*
>> 0 10408 */
>>                           /* --- cacheline 162 boundary (10368 bytes)
>> was 40 bytes ago --- */
>>                           struct MR_LD_SPAN_MAP ldSpanMap[64]; /*
>> 10408 161792 */
>>                   };                                       /*     0
>> 172200 */
>>           };                                               /*     0
>> 172200 */
>>
>>           /* size: 172200, cachelines: 2691, members: 1 */
>>           /* last cacheline: 40 bytes */
>> };
>>
>> As you can see, the size is exactly the same, as are the offsets for
>> both members raidMap and ldSpanMap.
> 
> ... this is good enough to prove that the binary before and after is
> identical and thus there's no change to the structures, which means the
> risk of accepting the patch is significantly lower.
> 
>>   The trick is that, thanks to the union and __offset_to_FAM, the
>> flexible-array member raidMap.ldSpanMap[] now appears as the last
>> member instead of somewhere in the middle.
>>
>> So both ldSpanMap and raidMap.ldSpanMap[] now cleanly overlap, as
>> seems to have been intended.
>>
>> (Exactly the same applies for struct MR_DRV_RAID_MAP_ALL)
>>
>> I can include this explanation to the changelog text if you'd like.
> 
> I'll leave it up to Martin, but I think going forwards it would be
> helpful if you could indicate that you've checked that the binary
> layout before and after is unchanged and thus the risk of merging the
> patch is low.

Absolutely. I'll do that.

Thanks for the feedback.
-Gustavo

