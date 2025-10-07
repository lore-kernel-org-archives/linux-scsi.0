Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6F735972;
	Tue,  7 Oct 2025 11:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759838035; cv=none; b=LKvJhtpAA1XYpj2yvp/EFq0pt5Ug9fgfywszdBQtBoEJXsaZMAvZyR7CwYyl7V/T4bWw65SWd0OISSyYKMM2IqgRJdqZHkdCoKslwNH4EKtKvCa9vOz6bFjQ5EAvAbnZLqpWDbOi26II90e+TGCbVWp8wLdGiJXNfmw66THqbyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759838035; c=relaxed/simple;
	bh=xAmtcSiYneGYrEA5MVX3I4DmoITVa1if+HoK67nb8iU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=XAD4W3eMX+rnaLUdoSL+t3U/Yrujz+4bDrmzYmqRpJRC13fd4BJQU2TEz2Zan/E+Hu7j5W1iZ5q0KqHggg+20wT9Mcudl5uJEcFEnxdNf9zyV/8XTyBCm5ASdZeIJ+9PQ43RpZ7oDCBZiCjc5auzw/aP2u6//APRN3j22DQHz3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=wgfAny9c; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="wgfAny9c"
Received: from eig-obgw-6006b.ext.cloudfilter.net ([10.0.30.211])
	by cmsmtp with ESMTPS
	id 65QKvUJzyjzfw66GNvyVP4; Tue, 07 Oct 2025 11:53:51 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id 66GLvKAikMem566GLvsC2L; Tue, 07 Oct 2025 11:53:50 +0000
X-Authority-Analysis: v=2.4 cv=bZtrUPPB c=1 sm=1 tr=0 ts=68e4ff4f
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=4oHATN8Nx7vVUZJYxp75bA==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=7T7KSl7uo7wA:10 a=VwQbUJbxAAAA:8
 a=23AC6A14qyjZoQxIM3kA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=xYX6OU9JNrHFPr8prv8u:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:References:Cc:To:From:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=GzqhRhaEEqzGyTEdmrMO2YaMzjaRRo6FU0EtpB0R+I4=; b=wgfAny9c9uHp2QMHZUmUBGzZtq
	PJHE1aUvl6+rQqx3r+Zym55nNZFCcLQO/c/1weLQE3KmWS/Q5VSEl//4gWlU7jM8nLdEhgBvxACDJ
	WgKRNkjTAfxk+DbFEHbK5Po41VNtJLEZu3e4pfVtI++mYc07kTRK/scNgAKo2KqatCg2i7gCROBj6
	HZS6Bl6Qujyd7eZEL9jCNXJnD0EDWUke1J5Cr2BwFexI492W7PdWfzpfL/TpBr+IhOojnQeiNjBLo
	HkZkXxP1Zk09AkyKQy2l5LWXIR1sWlS6av4D1LeKto9o2afVHs3pSB2+qMAA6rh9PZrrqQFHGhNSw
	H/Fh5r6A==;
Received: from [185.134.146.81] (port=42034 helo=[10.21.53.44])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1v65Ku-00000000WlI-05NZ;
	Tue, 07 Oct 2025 05:54:28 -0500
Message-ID: <0e46139a-bb80-4684-977d-aaacc653840b@embeddedor.com>
Date: Tue, 7 Oct 2025 11:54:23 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] scsi: hisi_sas: Avoid a couple
 -Wflex-array-member-not-at-end warnings
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Yihang Li <liyihang9@h-partners.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
References: <aM1J5UemZFgdso3F@kspp>
 <9e0613bf-17ae-407a-a3ab-cbeac09c3a17@embeddedor.com>
Content-Language: en-US
In-Reply-To: <9e0613bf-17ae-407a-a3ab-cbeac09c3a17@embeddedor.com>
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
X-Exim-ID: 1v65Ku-00000000WlI-05NZ
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([10.21.53.44]) [185.134.146.81]:42034
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 0
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfPnB0vJFVvvAWyWfTSQaBQ7nwBQ22x5ULp3zJlE9ziS/yRF8wdB6hh3VhoJPyjFJ/XZXEN441F+i1javQVNA2Zfq/KXhdxWFCFcO0WiZNFpQmsnYUgLh
 03WTo+nLHzol1NvWyYhu5rfnxO0IZ8xAoI8fnjkOBUfnjT919znifjtysB28BqRxYWVg9nwHOCf3Rf+lcKTkd1bAxan6cb4s0bAG9q8PUgds9JhKX7+BxNGE
 yx53MU9vxbZelvhrZUpeVaRDWpmmjaoEC0vvhvtGk63sTYKqt/ILV7me6YHbBP7Kwnqn3ELfD0mj9z9trOZw1Q==



On 10/7/25 11:45, Gustavo A. R. Silva wrote:
> Hi all,
> 
> Friendly ping: who can take this, please?
> 
> Thanks!
> -Gustavo
> 
> On 9/19/25 13:17, Gustavo A. R. Silva wrote:
>> -Wflex-array-member-not-at-end was introduced in GCC-14, and we are
>> getting ready to enable it, globally.
>>
>> Move the conflicting declarations to the end of the corresponding
>> structures (and in a union). Notice that `struct ssp_command_iu`
>> is a flexible structure, this is a structure that contains a
>> flexible-array member.
>>
>> With these changes fix the following warnings:
>>
>> drivers/scsi/hisi_sas/hisi_sas.h:639:38: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member- 
>> not-at-end]
>> drivers/scsi/hisi_sas/hisi_sas.h:616:47: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member- 
>> not-at-end]
>>
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>> ---
>>   drivers/scsi/hisi_sas/hisi_sas.h | 10 +++++++---
>>   1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
>> index 1323ed8aa717..55c638dd58b1 100644
>> --- a/drivers/scsi/hisi_sas/hisi_sas.h
>> +++ b/drivers/scsi/hisi_sas/hisi_sas.h
>> @@ -613,8 +613,8 @@ struct hisi_sas_command_table_ssp {
>>       struct ssp_frame_hdr hdr;
>>       union {
>>           struct {
>> -            struct ssp_command_iu task;
>>               u32 prot[PROT_BUF_SIZE];
>> +            struct ssp_command_iu task;
>>           };

Actually, I have a question here:

is u32 prot[PROT_BUF_SIZE]; intended to overlap flex array task.add_cdb[]
at some point?

if not, this change is just fine. Otherwise, I'd need to update this
patch to account for the overlap.

Could someone provide some feedback here? :)

Thanks!
-Gustavo

>>           struct ssp_tmf_iu ssp_task;
>>           struct xfer_rdy_iu xfer_rdy;
>> @@ -636,13 +636,17 @@ struct hisi_sas_status_buffer {
>>   struct hisi_sas_slot_buf_table {
>>       struct hisi_sas_status_buffer status_buffer;
>> -    union hisi_sas_command_table command_header;
>>       struct hisi_sas_sge_page sge_page;
>> +
>> +    /* Must be last --ends in a flexible-array member. */
>> +    union hisi_sas_command_table command_header;
>>   };
>>   struct hisi_sas_slot_dif_buf_table {
>> -    struct hisi_sas_slot_buf_table slot_buf;
>>       struct hisi_sas_sge_dif_page sge_dif_page;
>> +
>> +    /* Must be last --ends in a flexible-array member. */
>> +    struct hisi_sas_slot_buf_table slot_buf;
>>   };
>>   extern struct scsi_transport_template *hisi_sas_stt;
> 

