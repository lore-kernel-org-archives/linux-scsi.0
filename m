Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=64.68.200.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793202389;
	b=UtHvDrd6/JrXCO+A+rc+SNdY1Xm9gw8oxSTpwdbU3aPZPsXJ7udGnI7gKkINhIOaB33L
	 ewMX0oDfaaDKdqRmf9omlAs7jT30btXfoI3MfF/6/9x5AFiQ6Z9kwLLMnVOOO4/WfWn4i
	 NKIkfSkVl73atvfuwJajM9R6yWGwJS52ngsLKaFc6tLxdIjFrzcvrsj1oo4aE1Rk2TvMC
	 nXgTQy3DR0p3/giQyoKJ0HsqnhTfIB4YL6O7QCgXwsLOwjib5aaT7+aZEV8l7cm6Bd9c8
	 RQMUrhvOIMA0JRSK9C6CZVs1MAAiHE9DEBi8TJ9Kjevh4tzfwTwbEyTHVV+f/X3jGmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793202389;
	h=DMARC-Filter:Received:Received:DKIM-Signature:X-Virus-Scanned:
	 Received:Received:DKIM-Signature:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Reply-To:Subject:To:Cc:References:From:
	 Content-Language:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=FFvbm0CIfZef2bMqTz1JYac3ohqjRDH7vlUE/d2PUuc=;
	b=UgiTxRYhd3fK7L49ypUoM+DraIl4R6pnf4+o2+8d+msDNfZs/T67MISciaHRgeIT4/Is
	 D+9RfFWxlEuK8m/F7neX1kCiCwKXlOyUlh+JVFXdeQPuadkLHQmeXIP0+8RBc8Nmw+uDP
	 jebGo7Azl6F5yweKfQAU+eP12GzOxkwR1FUltEqN63c1hdDiQ/n9BH7XazHGpgiy+vBm2
	 PCMmjaLMGO+xeU4tBmXdhkLXx1CWyEL+4bslfRU1QdX7UeXbS3PzzDm1tjOMxaEZaC9Lh
	 6PI6j5P2FrtW+6zXazSVEy3RsDkqkkA5Yr/A7wS7PHZ7Ay7l2WkEIEUTIu17y1K5C7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gonehiking.org;
	spf=pass smtp.mailfrom=gonehiking.org;
	dkim=pass header.d=gonehiking.org header.i=@gonehiking.org header.a=rsa-sha256 header.s=easymail header.b=EXxpsO8M;
	dkim=pass header.d=gonehiking.org header.i=@gonehiking.org header.a=rsa-sha256 header.s=easymail header.b=A3LOPOCG;
	arc=none smtp.remote-ip=64.68.200.34
Received: from outbound.easymail.ca (outbound.easymail.ca [64.68.200.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14709606A326
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 15:46:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14709606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gonehiking.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gonehiking.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gonehiking.org header.i=@gonehiking.org header.a=rsa-sha256 header.s=easymail header.b=EXxpsO8M;
	dkim=pass (2048-bit key) header.d=gonehiking.org header.i=@gonehiking.org header.a=rsa-sha256 header.s=easymail header.b=A3LOPOCG
Received: from mailout.easymail.ca (pco.easydns.net [64.68.203.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by outbound.easymail.ca (Postfix) with ESMTPS id 3582020A91;
	Wed, 28 Oct 2026 15:46:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mailout.easymail.ca (Postfix) with ESMTP id 18094E0729;
	Wed, 28 Oct 2026 15:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gonehiking.org;
	s=easymail; t=1793202388;
	bh=FFvbm0CIfZef2bMqTz1JYac3ohqjRDH7vlUE/d2PUuc=;
	h=Date:Reply-To:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EXxpsO8MsT1xgv2MgNXyX1gLzcss+Y7Y6ocfX2dp45VftkMMoQi1QCCIHemjmkOeT
	 tbhKT2tPP1sVRZNK4Ob7LYcQ/HyqJ4KW8OSS10Tg5KLfSjvV8CrBfziSWNao3junbI
	 tSM/GWNfX9QekhM9IdoFs31tkSoXmFzcm3cwcDWC8TJtJgP8OAL4gFzK0k0ilsyRks
	 Euc2Gm3Q0CyCFSfth9PMNE73CmUsp+3uM+qecEwMV+l1yTUKYBA9lBG5ebwm0K8HEZ
	 JqEht0VEN88ihY0ZwILH7vNWyNdvaVsJafhsNT2RoV7WPeRM5i8VUwFjnFXc9oXtk3
	 7Msbdgl6BPlBw==
X-Virus-Scanned: Debian amavisd-new at emo08-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
	by localhost (emo08-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zrwneT5MbAgp; Wed, 28 Oct 2026 15:46:27 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by mailout.easymail.ca (Postfix) with ESMTPSA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gonehiking.org;
	s=easymail; t=1793202387;
	bh=FFvbm0CIfZef2bMqTz1JYac3ohqjRDH7vlUE/d2PUuc=;
	h=Date:Reply-To:Subject:To:Cc:References:From:In-Reply-To:From;
	b=A3LOPOCGFxq+yKDjQlK1DyU7Wx41yngiIWozf/TUJGOtuhFPOcYmEywMkhW4I6pyh
	 BkVHr3HYbQ1D4mEMA6iMKXguud6mlj1Ew18QXuJUPEt/mbQM4MGiDr7cASnozJ+ypo
	 WILSZTnkvA12Z8pqPaZxYTWIxQDTPgeOc+ispnEuZgVI7wuqCZ5cID2OJDfjxLHWZr
	 Hot8nea37JygtwVgh0rh5JuzmWngQZy8SEUglBGpwuSeCewv7efMTRT4EbAl5p/Jfn
	 IXgNLlY/W6V1LuozuAfbC9PJuuDACE4SZz1Aj9oAYFBvoonVWhTqyv8DyJ8BMzy5oA
	 RoGBS47ehTMgw==
Received: from [127.0.0.1] (localhost [127.0.0.1]) by mailout.easymail.ca (Postfix) with ESMTPSA
Message-ID: <00cba76a-ae92-40a7-8680-9775762bc7fa@gonehiking.org>
Date: Wed, 28 Oct 2026 09:46:27 -0600
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: khalid@gonehiking.org
Subject: Re: [PATCH v4 05/54] scsi: BusLogic: Prepare for enabling lock
 context analysis
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
References: <cover.1790360262.git.bvanassche@acm.org>
 <abe0bc09b63eb55f278a883b65b881b94ce1c31b.1790360262.git.bvanassche@acm.org>
From: Khalid Aziz <khalid@gonehiking.org>
Content-Language: en-US
Autocrypt: addr=khalid@gonehiking.org; keydata=
 xsFNBFA5V58BEADa1EDo4fqJ3PMxVmv0ZkyezncGLKX6N7Dy16P6J0XlysqHZANmLR98yUk4
 1rpAY/Sj/+dhHy4AeMWT/E+f/5vZeUc4PXN2xqOlkpANPuFjQ/0I1KI2csPdD0ZHMhsXRKeN
 v32eOBivxyV0ZHUzO6wLie/VZHeem2r35mRrpOBsMLVvcQpmlkIByStXGpV4uiBgUfwE9zgo
 OSZ6m3sQnbqE7oSGJaFdqhusrtWesH5QK5gVmsQoIrkOt3Al5MvwnTPKNX5++Hbi+SaavCrO
 DBoJolWd5R+H8aRpBh5B5R2XbIS8ELGJZfqV+bb1BRKeo0kvCi7G6G4X//YNsgLv7Xl0+Aiw
 Iu/ybxI1d4AtBE9yZlyG21q4LnO93lCMJz/XqpcyG7DtrWTVfAFaF5Xl1GT+BKPEJcI2NnYn
 GIXydyh7glBjI8GAZA/8aJ+Y3OCQtVxEub5gyx/6oKcM12lpbztVFnB8+S/+WLbHLxm/t8l+
 Rg+Y4jCNm3zB60Vzlz8sj1NQbjqZYBtBbmpy7DzYTAbE3P7P+pmvWC2AevljxepR42hToIY0
 sxPAX00K+UzTUwXb2Fxvw37ibC5wk3t7d/IC0OLV+X29vyhmuwZ0K1+oKeI34ESlyU9Nk7sy
 c1WJmk71XIoxJhObOiXmZIvWaOJkUM2yZ2onXtDM45YZ8kyYTwARAQABzSNLaGFsaWQgQXpp
 eiA8a2hhbGlkQGdvbmVoaWtpbmcub3JnPsLBegQTAQgAJAIbAwULCQgHAwUVCgkICwUWAgMB
 AAIeAQIXgAUCUDlYcgIZAQAKCRDNWKGxftAz+mCdD/4s/LpQAYcoZ7TwwQnZFNHNZmVQ2+li
 3sht1MnFNndcCzVXHSWd/fh00z2du3ccPl51fXU4lHbiG3ZyrjX2Umx48C20Xg8gbmdUBzq4
 9+s12COrgwgsLyWZAXzCMWYXOn9ijPHeSQSq1XYj8p2w4oVjMa/QfGueKiJ5a14yhCwye2AM
 f5o8uDLf+UNPgJIYAGJ46fT6k5OzXGVIgIGmMZCbYPhhSAvLKBfLaIFd5Bu6sPjp0tJDXJd8
 pG831Kalbqxk7e08FZ76opzWF9x/ZjLPfTtr4xiVvx+f9g/5E83/A5SvgKyYHdb3Nevz0nvn
 MqQIVfZFPUAQfGxdWgRsFCudl6i9wEGYTcOGe00t7JPbYolLlvdn+tA+BCE5jW+4cFg3HmIf
 YFchQtp+AGxDXG3lwJcNwk0/x+Py3vwlZIVXbdxXqYc7raaO/+us8GSlnsO+hzC3TQE2E/Hy
 n45FDXgl51rV6euNcDRFUWGE0d/25oKBXGNHm+l/MRvV8mAdg3iTiy2+tAKMYmg0PykiNsjD
 b3P5sMtqeDxr3epMO+dO6+GYzZsWU2YplWGGzEKI8sn1CrPsJzcMJDoWUv6v3YL+YKnwSyl1
 Q1Dlo+K9FeALqBE5FTDlwWPh2SSIlRtHEf8EynUqLSCjOtRhykmqAn+mzIQk+hIy6a0to9iX
 uLRdVc7BTQRQOVefARAAsdGTEi98RDUGFrxK5ai2R2t9XukLLRbRmwyYYx7sc7eYp7W4zbnI
 W6J+hKv3aQsk0C0Em4QCHf9vXOH7dGrgkfpvG6aQlTMRWnmiVY99V9jTZGwK619fpmFXgdAt
 WFPMeNKVGkYzyMMjGQ4YbfDcy04BSH2fEok0jx7Jjjm0U+LtSJL8fU4tWhlkKHtO1oQ9Y9HH
 Uie/D/90TYm1nh7TBlEn0I347zoFHw1YwRO13xcTCh4SL6XaQuggofvlim4rhwSN/I19wK3i
 YwAm3BTBzvJGXbauW0HiLygOvrvXiuUbyugMksKFI9DMPRbDiVgCqe0lpUVW3/0ynpFwFKeR
 FyDouBc2gOx8UTbcFRceOEew9eNMhzKJ2cvIDqXqIIvwEBrA+o92VkFmRG78PleBr0E8WH2/
 /H/MI3yrHD4F4vTRiPwpJ1sO/JUKjOdfZonDF6Hu/Beb0U5coW6u7ENKBmaQ/nO1pHrsqZp+
 2ErG02yOHF5wDWxxgbd4jgcNTKJiY9F1cdKP+NbWW/rnJgem8qYI3a4VkIkFT5BE2eYLvZlR
 cIzWc/ve/RoQh6jzXD0T08whoajZ1Y3yFQ8oyLSFt8ybxF0b5XryL2RVeHQTkE8NKwoGVYTn
 ER+o7x2sUGbIkjHrE4Gq2cooEl9lMv6I5TEkvP1E5hiZFJWYYnrXa/cAEQEAAcLBXwQYAQgA
 CQUCUDlXnwIbDAAKCRDNWKGxftAz+reUEACQ+rz2AlVZZcUdMxWoiHqJTb5JnaF7RBIBt6Ia
 LB9triebZ7GGW+dVPnLW0ZR1X3gTaswo0pSFU9ofHkG2WKoYM8FbzSR031k2NNk/CR0lw5Bh
 whAUZ0w2jgF4Lr+u8u6zU7Qc2dKEIa5rpINPYDYrJpRrRvNne7sj5ZoWNp5ctl8NBory6s3b
 bXvQ8zlMxx42oF4ouCcWtrm0mg3Zk3SQQSVn/MIGCafk8HdwtYsHpGmNEVn0hJKvUP6lAGGS
 uDDmwP+Q+ThOq6b6uIDPKZzYSaa9TmL4YIUY8OTjONJ0FLOQl7DsCVY9UIHF61AKOSrdgCJm
 N3d5lXevKWeYa+v6U7QXxM53e1L+6h1CSABlICA09WJP0Fy7ZOTvVjlJ3ApO0Oqsi8iArScp
 fbUuQYfPdk/QjyIzqvzklDfeH95HXLYEq8g+u7nf9jzRgff5230YW7BW0Xa94FPLXyHSc85T
 E1CNnmSCtgX15U67Grz03Hp9O29Dlg2XFGr9rK46Caph3seP5dBFjvPXIEC2lmyRDFPmw4yw
 KQczTkg+QRkC4j/CEFXw0EkwR8tDAPW/NVnWr/KSnR/qzdA4RRuevLSK0SYSouLQr4IoxAuj
 nniu8LClUU5YxbF57rmw5bPlMrBNhO5arD8/b/XxLx/4jGQrcYM+VrMKALwKvPfj20mB6A==
In-Reply-To: <abe0bc09b63eb55f278a883b65b881b94ce1c31b.1790360262.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/25/26 12:25 PM, Bart Van Assche wrote:
> Document locking requirements with __must_hold() annotations to
> prepare the BusLogic driver for enabling compiler-based lock context
> analysis.
> 
> Cc: Khalid Aziz <khalid@gonehiking.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/BusLogic.c | 6 ++++++
>   drivers/scsi/BusLogic.h | 3 ++-
>   2 files changed, 8 insertions(+), 1 deletion(-)
> 

Looks good to me.

Acked-by: Khalid Aziz <khalid@gonehiking.org>

--
Khalid

> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index 75aaf35383a9..4179f29b3066 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c
> @@ -277,6 +277,7 @@ static void blogic_create_addlccbs(struct blogic_adapter *adapter,
>   */
>   
>   static struct blogic_ccb *blogic_alloc_ccb(struct Scsi_Host *host)
> +	__must_hold(&host->host_lock)
>   {
>   	struct blogic_adapter *adapter = (void *)host->hostdata;
>   	static unsigned long serial;
> @@ -310,6 +311,7 @@ static struct blogic_ccb *blogic_alloc_ccb(struct Scsi_Host *host)
>   
>   static void blogic_dealloc_ccb(struct Scsi_Host *host, struct blogic_ccb *ccb,
>   			       int dma_unmap)
> +	__must_hold(&host->host_lock)
>   {
>   	struct blogic_adapter *adapter = ccb->adapter;
>   
> @@ -2599,6 +2601,7 @@ static void blogic_scan_inbox(struct blogic_adapter *adapter)
>   */
>   
>   static void blogic_process_ccbs(struct Scsi_Host *host)
> +	__must_hold(&host->host_lock)
>   {
>   	struct blogic_adapter *adapter = (void *)host->hostdata;
>   
> @@ -2830,6 +2833,7 @@ static irqreturn_t blogic_inthandler(int irq_ch, void *devid)
>   
>   static bool blogic_write_outbox(struct Scsi_Host *host,
>   		enum blogic_action action, struct blogic_ccb *ccb)
> +	__must_hold(&host->host_lock)
>   {
>   	struct blogic_adapter *adapter = (void *)host->hostdata;
>   	struct blogic_outbox *next_outbox;
> @@ -2884,6 +2888,7 @@ static int blogic_hostreset(struct scsi_cmnd *SCpnt)
>   */
>   
>   static enum scsi_qc_status blogic_qcmd_lck(struct Scsi_Host *shost, struct scsi_cmnd *command)
> +	__must_hold(&shost->host_lock)
>   {
>   	void (*comp_cb)(struct scsi_cmnd *) = scsi_done;
>   	struct blogic_adapter *adapter =
> @@ -3194,6 +3199,7 @@ static int blogic_abort(struct scsi_cmnd *command)
>   */
>   
>   static int blogic_resetadapter(struct Scsi_Host *host, bool hard_reset)
> +	__must_hold(&host->host_lock)
>   {
>   	struct blogic_adapter *adapter = (void *)host->hostdata;
>   	struct blogic_ccb *ccb;
> diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
> index 6ace3c307a90..455d442525f6 100644
> --- a/drivers/scsi/BusLogic.h
> +++ b/drivers/scsi/BusLogic.h
> @@ -1279,7 +1279,8 @@ static int blogic_sdev_configure(struct scsi_device *,
>   				 struct queue_limits *lim);
>   static void blogic_qcompleted_ccb(struct blogic_ccb *);
>   static irqreturn_t blogic_inthandler(int, void *);
> -static int blogic_resetadapter(struct Scsi_Host *host, bool hard_reset);
> +static int blogic_resetadapter(struct Scsi_Host *host, bool hard_reset)
> +	__must_hold(&host->host_lock);
>   static void blogic_msg(enum blogic_msglevel, char *, struct blogic_adapter *, ...);
>   static int __init blogic_setup(char *);
>   

