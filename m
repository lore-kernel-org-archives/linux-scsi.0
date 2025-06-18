Received: from out203-205-221-239.mail.qq.com (out203-205-221-239.mail.qq.com [203.205.221.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574BC1891AB;
	Wed, 18 Jun 2025 06:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750228330; cv=none; b=cjZtq0xd9WW4z3zt2emQu7ky57cwB1ZIne3ll8MiQduOweRhtW3TiTVtvl6WqYAAiOS8HEnE/2JIlz1jMMwAPfwSKxFrU72Sa1bifxZz71EfgPDoZ7c24Q69Dv8HFcTR02KqE08QgB/QaNpJmobCNJ2+c0fsA8M/U81n322Z+/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750228330; c=relaxed/simple;
	bh=E7YKjrRDmlenARAqAx807YrnbV8LmJeT4G+LU7Mtm4M=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=XCgrcyCszly8fZbzBdnz2DUjsoUB0MpIKP19FAUlE+ac9u9+o9sHlmHejs9LPovDz+KbWpQhLzwx7BM8qQqq/cls8ylcnptqs4/UJY8eAv5WodO5g5SBwiLLN/BbOwlEQLWO7dYaFNZK2gJeTldPqQdUVPZR99aV/8K/4FOtkjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=cOk0JA4N; arc=none smtp.client-ip=203.205.221.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="cOk0JA4N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1750228322; bh=zZ5/lyBSnElje+Zi301ZoNFtaRtKmYgn2B2hHpqvEdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cOk0JA4N4MAjzTZeseiKdlXOPDOApxbqCv2ICGj9clM1pj3iywIHX26gCYqoGBeWp
	 xPo4rxba+71TyGhGCtkxmN6/EmYWGxjNS1JocH1eQDxGPRICTRQzhV7QjZa1qN/Av/
	 AoUDb0OvO3BraXSIyoBgc3RFq1N230WJwOc7e/GE=
Received: from VM-222-126-tencentos.localdomain ([14.116.239.36])
	by newxmesmtplogicsvrsza36-0.qq.com (NewEsmtp) with SMTP
	id 8009BA73; Wed, 18 Jun 2025 14:32:00 +0800
X-QQ-mid: xmsmtpt1750228320thwxg1sn2
Message-ID: <tencent_D9A0F9052526AD09F7FF76DD5F2529FDDD05@qq.com>
X-QQ-XMAILINFO: NT7dO8ok7FP2+4Q/xwnZNFiFZxVOuXHuhWGwf3ofos1US7wUs82qDUAuZkn8dx
	 SQGs04yti257mOgOhjEHx9Ou705M0tVpUrvilc3Yym7lex//A4JPN/6JiCAS60W+ORsmEBuNXA3P
	 ruOHZsYZVor0xeTHOPLPh/C2k2jE72OpIkInKo6GMIeddunP0xkPQ+MqbloX83YC8jFse0yD8ARl
	 s8joZQ+6qPrvuqDNZ60Tq/zEfUW+wEIZKnwwrvjZYDU7pCL73XYH+CA/dSL/2gTx8jBJulx+aY9s
	 MG0IuZlqmCWYFzeWqI4/KhlQVHAK4m8HnNJW+PfMBnoJJnDw1BlPWP7LWgxLtsIgIeVnULhGWpto
	 /t0aocJD1+z0+S8BHyIpDz0Oc0lNYpOW+rxopaYPoHP0X2YRYOCxpvr09sfYnmF6GrwGIasqbUzD
	 xRpl6NBTsS3barEuL5CP5qtyySQH/1obxifL2LQMir1E0rcsLGReBlrLqfZoX+CHqKr6PRDh4q9J
	 TtQC9i4MoZWiLDTfz04WJL8OvmmDvcDlqT6MfBd+kAlLSfHRvMmwS0ks6u752zpJb4HNblFLhb1B
	 eAYfXP2ZakgnarZGHSHWfAn+au1CRU0n73/UdSPGEgCKmxaC8Dva7sQexi8OpARV/2S1BwAMUEVn
	 +NN99xfwLpFhq2jLjPRDw7s1+PIPIprcQZfrPoUAe6vPr5VkLK0cVAgTeP3U7UOBNaox8dwVuH/4
	 Dyer7gsYrjsXuQoanrWzkT7eH2XZqDvmjgxvGRRYB9+/4Jz/LhsN+UAYFqVZqTQ3TIPeW+ARCBvm
	 uqtj1QYHIBbd0p2ErzIbKNekDTtMsA3RdGUwuma2bAM3ABYZ679cRnbTCeO3OSu8GmgycHLv9Wni
	 iEbNT1F0SL9NzRxsW6WVfdNpV8bdRXNcjuDmaTMZ+BmNOpzH2/hfEL+lpvcNxloyz26xF4Nx5hv0
	 pI9a/0Cvd6K2KlP3J9777eyZ6rul1SlyzjyiAMa7gCuyHrkGZUzwsEtj/u+aGLZC1Yvd52C3fCzZ
	 xCsk0OBY27xOgAQAPC+2AA1ow82cGlqBywA76spGx1ZmMCuT52
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
From: jackysliu <1972843537@qq.com>
To: bvanassche@acm.org
Cc: 1972843537@qq.com,
	James.Bottomley@HansenPartnership.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Subject: RE:[PATCH] scsi: fix out of bounds error in /drivers/scsi
Date: Wed, 18 Jun 2025 14:31:55 +0800
X-OQ-MSGID: <20250618063155.1587242-1-1972843537@qq.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <07c4c84d-0c52-4843-b32d-6806e58892fe@acm.org>
References: <07c4c84d-0c52-4843-b32d-6806e58892fe@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 6/17/25 2:03 AM, jackysliu wrote:
> Out-of-bounds vulnerability found in ./drivers/scsi/sd.c,
> sd_read_block_limits_ext Function Due to Unreasonable boundary checks.
> Out-of-bounds read vulnerability exists in the
> Linux kernel's SCSI disk driver (./drivers/scsi/sd.c).
> The flaw occurs in the sd_read_block_limits_ext function
>   when processing Vital Product Data (VPD) page B7 (Block Limits Extension)
>   responses from storage devices
> 
> Signed-off-by: jackysliu <1972843537@qq.com>
> ---
>   drivers/scsi/sd.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 3f6e87705b62..eeaa6af294b8 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3384,7 +3384,7 @@ static void sd_read_block_limits_ext(struct scsi_disk *sdkp)
>   
>   	rcu_read_lock();
>   	vpd = rcu_dereference(sdkp->device->vpd_pgb7);
> -	if (vpd && vpd->len >= 2)
> +	if (vpd && vpd->len >= 6)
>   		sdkp->rscs = vpd->data[5] & 1;
>   	rcu_read_unlock();
>   }

On 6/17/25 13:44 PM , Bart Van Assche wrote:
>Fixes: and Cc: stable tags are missing. Please add these.
>
>How has this been detected? Please mention this in the patch
>description. When I wrote the above code I was assuming that vpd->len
>represents the contents of the PAGE LENGTH field (bytes 2 and 3).
>Apparently vpd->len is the length in bytes of the entire VPD page.
>
>Thanks,
>
>Bart.

Sure,I'll explain in the patch later.
Can I know what kind of impact this vulnerability will have?
And is it possible to get a cve number?

Thanks,

Jackysliu

