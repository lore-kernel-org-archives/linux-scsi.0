Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B691734BA34;
	Tue,  7 Oct 2025 17:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759857403; cv=none; b=p7yHd4rvmORoE9l2nU4YOhE4JTFnf0CbHKBSEayqZzqI1NDghN8vgS7JLVAyRNOwd4/ccbB9gQxsVTF7yDZYTcXgxrG7GOiUpGXIXwGG4i3MvwUSZ2seW3KSNHhhJ9OpbzT15eotxypLzfiIpJ/Vdg1H5H9mP5buewKgD73/Dk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759857403; c=relaxed/simple;
	bh=DJtZSdCijPbQbaB6CVjS9lgp06ac4tI/pgBmbGCdqLg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VZNGAFWTsMDztsj9jkQWI+VPUF83H9pj+FynYvHhpshEH8oX4AKmlUwnD5YZEzETSTkG7U/dqjxu7Nn9Fv9fmE2SczNp3ysM8Q7WMxFbtyLeLRW28xC1zfy9YFoTubpS4+ANmKg/nWvXpfuYBpn/uuGYF561b/g7W9TupkoFdUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=SgXeFwx1; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="SgXeFwx1"
Received: from eig-obgw-6005b.ext.cloudfilter.net ([10.0.30.162])
	by cmsmtp with ESMTPS
	id 692WvC42geNqi6BIgv7Q3V; Tue, 07 Oct 2025 17:16:34 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id 6BIfvkA0uLidY6BIgvklnz; Tue, 07 Oct 2025 17:16:34 +0000
X-Authority-Analysis: v=2.4 cv=bq1MBFai c=1 sm=1 tr=0 ts=68e54af2
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=4oHATN8Nx7vVUZJYxp75bA==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=7T7KSl7uo7wA:10
 a=vrm2DYtl0a66eygLWCQA:9 a=QEXdDO2ut3YA:10 a=xYX6OU9JNrHFPr8prv8u:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=k/RQCbk5TNZtW25tKPudmPz+XPlOL4k+2HIoGg8Wmrs=; b=SgXeFwx1/TNoyhrIv/+05jHO4j
	JOfaWjWYUSCsNofzRqCxyS3IYzkVypY3V3ulpnWUYXYsK2KanWd/Acl3t+NpMAT8nxuhHKpk0z7sZ
	BlGiKkXpY/88lFgkadHkLp9gnkHBhISlVVu7E3xb/PeQtNaur/moLzBgBcSGb7ju1ScpKgJWS3V5g
	Uh4JGuNBot+whOESBVoKTByOCZHPvChXQX8ta0qC0Kay6ucy366slpWUZKAeXivAS6mkb8FZdWvqw
	5HTLoZ1zdi2WnyrNpTmeJ4ilmZil8uoapxbNpJu+8KtK+c/NBLzzlPi2OFZw9qhukr2/U5LwgXDey
	hH+WW4Tg==;
Received: from [185.134.146.81] (port=39130 helo=[10.21.53.44])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1v68WM-00000004Ij5-3a69;
	Tue, 07 Oct 2025 09:18:31 -0500
Message-ID: <5b23ae5a-bd47-49c7-bca7-7019abc631f7@embeddedor.com>
Date: Tue, 7 Oct 2025 15:18:22 +0100
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
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <4cf727c56c4fda8d28df920214b3824c9739bc8f.camel@HansenPartnership.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 185.134.146.81
X-Source-L: No
X-Exim-ID: 1v68WM-00000004Ij5-3a69
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([10.21.53.44]) [185.134.146.81]:39130
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 0
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfGfy7KbgiuUIq3hS3QH+o6ct9JNHwov5sHq/kqKxxdb5fg+yXkDbV+xad4nsQqsMrNnQrZQ1xD9O6bP7hss5uk0GAXJHRqJtelNFENiBymZFwXhD44kA
 XLlFMVgmWejL9KJDFmvCEpQOd3f7LXP43hzjYooeNFSI0cIpWYNRL8wFT9LglmWxth6bi+EcCheru6ltn2hariLgjFUnvXxonrYOmUpG7ZLOKu7Xi4pxFFHN
 eDSWfrSZXT0XDcR2TrMeHv7HN1e1YVNaJsQcJkArsoo=



On 10/7/25 12:59, James Bottomley wrote:
> On Tue, 2025-10-07 at 11:43 +0100, Gustavo A. R. Silva wrote:
>> Hi all,
>>
>> Friendly ping: who can take this, please?
> 
> After what happened with the qla2xxx driver, everyone is a bit wary of
> these changes, particularly when they affect structures shared with the
> hardware. Megaraid is a broadcom acquisition so although maintained it
> might take them a while to check this.

I've been in constant communication with the people involved. So far,
none of them has expressed any concerns about this to me. However, I
appreciate your feedback.

In any case, I promptly submitted a bugfix minutes after getting the
report.

> 
> However, you could help us with this: as I understand it (there is a
> bit of a no documentation problem here), the TRAILING_OVERLAP formalism
> merely gets the compiler not to warn about the situation rather than
> actually changing anything in the layout of the structure?  In which
> case you should be able to demonstrate the binary produced before and
> after this patch is the same, which would very much reduce the risk of
> taking it.

This is quite simple. Here you go the pahole output before and after
changes.

BEFORE CHANGES:

pahole -C MR_FW_RAID_MAP_ALL drivers/scsi/megaraid/megaraid_sas_fp.o
struct MR_FW_RAID_MAP_ALL {
         struct MR_FW_RAID_MAP      raidMap;              /*     0 10408 */
         /* --- cacheline 162 boundary (10368 bytes) was 40 bytes ago --- */
         struct MR_LD_SPAN_MAP      ldSpanMap[64];        /* 10408 161792 */

         /* size: 172200, cachelines: 2691, members: 2 */
         /* last cacheline: 40 bytes */
};

AFTER CHANGES:

pahole -C MR_FW_RAID_MAP_ALL drivers/scsi/megaraid/megaraid_sas_fp.o
struct MR_FW_RAID_MAP_ALL {
         union {
                 struct MR_FW_RAID_MAP raidMap;           /*     0 10408 */
                 struct {
                         unsigned char __offset_to_FAM[10408]; /*     0 10408 */
                         /* --- cacheline 162 boundary (10368 bytes) was 40 bytes ago --- */
                         struct MR_LD_SPAN_MAP ldSpanMap[64]; /* 10408 161792 */
                 };                                       /*     0 172200 */
         };                                               /*     0 172200 */

         /* size: 172200, cachelines: 2691, members: 1 */
         /* last cacheline: 40 bytes */
};

As you can see, the size is exactly the same, as are the offsets for both
members raidMap and ldSpanMap. The trick is that, thanks to the union and
__offset_to_FAM, the flexible-array member raidMap.ldSpanMap[] now appears
as the last member instead of somewhere in the middle.

So both ldSpanMap and raidMap.ldSpanMap[] now cleanly overlap, as seems to
have been intended.

(Exactly the same applies for struct MR_DRV_RAID_MAP_ALL)

I can include this explanation to the changelog text if you'd like.

Thanks
-Gustavo


