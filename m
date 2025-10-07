Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED5B3A1D2;
	Tue,  7 Oct 2025 22:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759877676; cv=none; b=X++W06Fa/4qYpDAQOoRcW+Hg/iwmGgoc2sehCy5VcqDDrUrCVkkSH3CBRyBTLeRTFAP+ZqKNin1tkN7jKbGXInhtKC1AelZE36AMz0Fn0SKJXm2Gw6sG1wZOwKXm1sgDUCDsBc8IpDMMpqN6SRdDn3Jzc0Ev2++BjrUNNOh7b7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759877676; c=relaxed/simple;
	bh=9n9+el5uxGfJFE5RJ0pKeBUahXL3HLSEdWqB7UJO5J8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vEssJ1ksH/cGgGdQfJiuTXhP0KJV0lxcHyG0rm5vL1LdbD4NnSZHKyW6qaeMy7Ycb6PuvlFsz7OzQBMeseiRmiBksXVkyqU6qMurw7niqnjL2Mo2MBpeKKVdv45eSV611Cz6/X0F4aupqT5Bg3dicNIPQBEf3L2LO0TRCinsvOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=EES0uHao; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="EES0uHao"
Received: from eig-obgw-5007b.ext.cloudfilter.net ([10.0.29.167])
	by cmsmtp with ESMTPS
	id 6BdwvYijsSkcf6GZfvma8r; Tue, 07 Oct 2025 22:54:27 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id 6GZevRIW2FT7u6GZevn660; Tue, 07 Oct 2025 22:54:26 +0000
X-Authority-Analysis: v=2.4 cv=Du5W+H/+ c=1 sm=1 tr=0 ts=68e59a22
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=4oHATN8Nx7vVUZJYxp75bA==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=7T7KSl7uo7wA:10 a=VwQbUJbxAAAA:8
 a=CpFGIHgWpZrg6UVlTl0A:9 a=QEXdDO2ut3YA:10 a=xYX6OU9JNrHFPr8prv8u:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=YACEB57SMrwoDJ7rsRkpJbGOJ2CMq7ZJl+occjNF87I=; b=EES0uHaoNmy0Lay8IW3gefytaL
	eAPc1doO45kiYQpbaNgtzCnQPXu2TPvu1OkL/KWdISXvQKSX9W0syvTUaHwvaKZTb+fJ3OJQ0sUFC
	PMrbHqAIv1xYIznBBhM5vrobJeOx+cRVxhBOxC6rdRfSAfoVlvyELF++c0hzgxd1GBd9K/cI2KP7G
	z1sDmnwc3s+KXjUn2qipEr/ZgYRDHk3mbDtDafHbyvt4qBVlZDbNuEm0+uOvbj1qJoPXSaefp1DHa
	i+SfLpGraw8GJZ/W8R9/36nY+mguSWqNXylj+XGU+Et9lCJ10EBnA0C9KTizWhOwvHUTHHfM0yl8c
	oJCpqpsA==;
Received: from [185.134.146.81] (port=51714 helo=[10.21.53.44])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1v65AY-00000000KkB-06mO;
	Tue, 07 Oct 2025 05:43:46 -0500
Message-ID: <729db47f-ac08-4390-a6c2-f0bf01da64c0@embeddedor.com>
Date: Tue, 7 Oct 2025 11:43:42 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] scsi: isci: Avoid -Wflex-array-member-not-at-end
 warning
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
References: <aM09bpl1xj9KZSZl@kspp>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <aM09bpl1xj9KZSZl@kspp>
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
X-Exim-ID: 1v65AY-00000000KkB-06mO
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([10.21.53.44]) [185.134.146.81]:51714
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 0
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCKUtZXcrPxeoBp2ykLjWU3vfs0vXhmEjDS+0otxmCxztWS4lfLo4k1mkiR5+SS2eTpKDLydo7AyEu3WUBZ+05pdvh51tcYR8iFop7gBgt1PL87JcF6e
 WwcR/23avRyh63zh+IZT7xlsYrBgO6HqrfHv39S709kwlYMiFepPsy9yAXR5yhNuW9ySpxHWgEBC4RWTQp7Lk9nh4UI6KnoQLlUC6AcY36BiXqTAuEjjjjIM
 BpwniEmePslq6iPMUVFoG128gYqX+WbvbYqFA9kZXUs/YNCbugYQLCzFLILA5LGzIMec1auO6nAY3CiuZtJ9Kw==

Hi all,

Friendly ping: who can take this, please?

Thanks!
-Gustavo

On 9/19/25 12:24, Gustavo A. R. Silva wrote:
> -Wflex-array-member-not-at-end was introduced in GCC-14, and we are
> getting ready to enable it, globally.
> 
> Move the conflicting declaration (which happens to be in a union,
> so we're moving the entire union) to the end of the corresponding
> structure. Notice that `struct ssp_response_iu` is a flexible
> structure, this is a structure that contains a flexible-array member.
> 
> With these changes fix the following warning:
> 
> drivers/scsi/isci/task.h:92:11: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>   drivers/scsi/isci/task.h | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/isci/task.h b/drivers/scsi/isci/task.h
> index f96633fa6939..d05d09c1263d 100644
> --- a/drivers/scsi/isci/task.h
> +++ b/drivers/scsi/isci/task.h
> @@ -85,15 +85,17 @@ struct isci_tmf {
>   
>   	struct completion *complete;
>   	enum sas_protocol proto;
> +	unsigned char lun[8];
> +	u16 io_tag;
> +	enum isci_tmf_function_codes tmf_code;
> +	int status;
> +
> +	/* Must be last --ends in a flexible-array member. */
>   	union {
>   		struct ssp_response_iu resp_iu;
>   		struct dev_to_host_fis d2h_fis;
>   		u8 rsp_buf[SSP_RESP_IU_MAX_SIZE];
>   	} resp;
> -	unsigned char lun[8];
> -	u16 io_tag;
> -	enum isci_tmf_function_codes tmf_code;
> -	int status;
>   };
>   
>   static inline void isci_print_tmf(struct isci_host *ihost, struct isci_tmf *tmf)

