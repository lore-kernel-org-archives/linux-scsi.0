Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E7116E863;
	Tue,  7 Oct 2025 19:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759866513; cv=none; b=fiTyRRTfHgvVMLTeNkjk+Zd+xaYokKc7FN2UDbi7If7vochLzAplZGFbRp30KuY3Qq36gMtNXeH4Kxay4J+bBSIqPG3x7NHV5acVgCTwnyJlNPWruOl9+vZ3YJuiZeegE4sR11ZEki/M0bDVPJR/YIgJy/htk7D35ODB5voPWLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759866513; c=relaxed/simple;
	bh=vMtXbq1KgnSFelCHvUhZ2kgM7oOGT+RSFcTakW+bbUQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=emFOB4agXJIKvKZ/IszM/orn0uPSNGP6zXcYi4d3IrchAB5QdjL0DIPHapdGyKOs1odT4wIm8jv/spSRbPb0p1uTF37lSrv4ioAczvbBwYsHcUquMHRzMZye+XuIGpZYbrJvnlARlm2pswl1tPid9uNzEtlL4fNeyYv7gTwB7/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=rq3ofEwu; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="rq3ofEwu"
Received: from eig-obgw-5005b.ext.cloudfilter.net ([10.0.29.189])
	by cmsmtp with ESMTPS
	id 6BR1vxE44KXDJ6DfcvpKpW; Tue, 07 Oct 2025 19:48:24 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id 6DfbvD9cRfjrX6Dfbv0Zuc; Tue, 07 Oct 2025 19:48:23 +0000
X-Authority-Analysis: v=2.4 cv=ItcecK/g c=1 sm=1 tr=0 ts=68e56e87
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=4oHATN8Nx7vVUZJYxp75bA==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=7T7KSl7uo7wA:10 a=VwQbUJbxAAAA:8
 a=4e8un5K37ZRR6lRcyOEA:9 a=QEXdDO2ut3YA:10 a=xYX6OU9JNrHFPr8prv8u:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=LfPENtYO9yg3I6QdDZRxM3kYJOjt9kvB6+tlT/9JDY4=; b=rq3ofEwuaf/LsUbXFiBonuvEIq
	RxMqKlBHPQKE0AuTVNDJsDVj75ymDtYqNiO3fAmFt23hkENte81TdQlr0GsFdMRMi+jxjh7V6kyQm
	KcNtwlIx4JaWgVdTILImYMmfZi0n9Tcp2+NWz0buuxHBboNkW3OgHiBMWnrgIhfxRQXcxzTSDUg4E
	7vD4ODepcDwimuFZSvt52p73eFkiipi/Od1bLKyXhZUrIYk44Mtqu8xE5JygdISuIbDsZXNRThfcK
	wsCrSSbbFFBayQ02/LatGp5Lg7Zv4mVKo6SSOElviL/eO/ILdtdEUzs/OeSN7r8ZItL53YbdKnPd0
	/qv0cLQQ==;
Received: from [185.134.146.81] (port=48322 helo=[10.21.53.44])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1v65C3-00000000Luf-35FH;
	Tue, 07 Oct 2025 05:45:19 -0500
Message-ID: <9e0613bf-17ae-407a-a3ab-cbeac09c3a17@embeddedor.com>
Date: Tue, 7 Oct 2025 11:45:15 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] scsi: hisi_sas: Avoid a couple
 -Wflex-array-member-not-at-end warnings
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Yihang Li <liyihang9@h-partners.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
References: <aM1J5UemZFgdso3F@kspp>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <aM1J5UemZFgdso3F@kspp>
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
X-Exim-ID: 1v65C3-00000000Luf-35FH
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([10.21.53.44]) [185.134.146.81]:48322
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 0
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNbSc0c0lJ7nQ1ngLk0019RGqvP+k6LOj9TRdVd/TY9QoFlp8hNAX6gfALSAzF4P2FwTb/3e/q7kexPAlqe54tLUMV8vfkcW49mz7pk3pbM/7FHaH7oA
 yKXcuXr1Tu+nq3HcoNx90EAz/JsDxWUedtBghBVGa3aMy5K9NtJ0ZZLjVTNlmMtiEkIZZwJvNSVIbdUnnWpLAMVp4Cj0bRvh1Zrp3RHZRB/3hIa73uvhvn6c
 Zb1Lik/Jmg3Q+GjHi6rC86gcIVcYcAmM22tULX6XLgI0uedIgAgqMTuG3Wed9+d+teesOM2+HXb8xD2jsKKN+A==

Hi all,

Friendly ping: who can take this, please?

Thanks!
-Gustavo

On 9/19/25 13:17, Gustavo A. R. Silva wrote:
> -Wflex-array-member-not-at-end was introduced in GCC-14, and we are
> getting ready to enable it, globally.
> 
> Move the conflicting declarations to the end of the corresponding
> structures (and in a union). Notice that `struct ssp_command_iu`
> is a flexible structure, this is a structure that contains a
> flexible-array member.
> 
> With these changes fix the following warnings:
> 
> drivers/scsi/hisi_sas/hisi_sas.h:639:38: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> drivers/scsi/hisi_sas/hisi_sas.h:616:47: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>   drivers/scsi/hisi_sas/hisi_sas.h | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
> index 1323ed8aa717..55c638dd58b1 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas.h
> +++ b/drivers/scsi/hisi_sas/hisi_sas.h
> @@ -613,8 +613,8 @@ struct hisi_sas_command_table_ssp {
>   	struct ssp_frame_hdr hdr;
>   	union {
>   		struct {
> -			struct ssp_command_iu task;
>   			u32 prot[PROT_BUF_SIZE];
> +			struct ssp_command_iu task;
>   		};
>   		struct ssp_tmf_iu ssp_task;
>   		struct xfer_rdy_iu xfer_rdy;
> @@ -636,13 +636,17 @@ struct hisi_sas_status_buffer {
>   
>   struct hisi_sas_slot_buf_table {
>   	struct hisi_sas_status_buffer status_buffer;
> -	union hisi_sas_command_table command_header;
>   	struct hisi_sas_sge_page sge_page;
> +
> +	/* Must be last --ends in a flexible-array member. */
> +	union hisi_sas_command_table command_header;
>   };
>   
>   struct hisi_sas_slot_dif_buf_table {
> -	struct hisi_sas_slot_buf_table slot_buf;
>   	struct hisi_sas_sge_dif_page sge_dif_page;
> +
> +	/* Must be last --ends in a flexible-array member. */
> +	struct hisi_sas_slot_buf_table slot_buf;
>   };
>   
>   extern struct scsi_transport_template *hisi_sas_stt;

