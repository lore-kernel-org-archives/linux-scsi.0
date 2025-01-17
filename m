Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD9F1F63DA;
	Fri, 17 Jan 2025 05:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737093479; cv=none; b=taMIjqe08fyRMvy1W10MAY4x2HqbSnNutDi8l3GGYlhYfKT65/nfieKmSwOBuSpZQWSwbiQTH1l4Tgv3vCuIkbvkxdc8yXdyg3qVQLSwpe7JHOzTTUQMXf1csl+PcoJ6zu9XA9v74e2Deu6l/zHDjzXouHiOcjb+Ce64zHlV1No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737093479; c=relaxed/simple;
	bh=flLZFqgT23RWMVdyLvhClp7ZWuOZy+UUWnj2z11ITAU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=qYO4031XQkuC/3BdiYvRNo42lal9AuW6smqz3LTTZJTqOPTijaxYw1tvjCvCuir3HgGy3j8g//zCCKuR5VQB1kxh2k5HO8tOiaFXXs+wN5DZM2/M6gc1+eQxgj4JIWCCT68Hh7VTHmJNHxU9A4BS2OTwVvB76+/D13Y8bppdeVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Z8xpeNWQ; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Z8xpeNWQ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1737093468; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=Q7oxCHPvrlD1lyZCU7eHs+mrqH16FXh/KtPA/I594Wc=;
	b=Z8xpeNWQpjz6oQppNGzTLo1wv7Of4PxJaz3XbJqIx11yAm3tFE8iUuvogcNke4u1gpxvaQ3qVbBX6Zf4Xog59vx8eQrdqPuA3XBbBA3aGqnEpPtmIg1d4CaX9oMLTcpY8d0C0U0Dcw19DfTBGkcStwxztJkBdBtQ5IGB300FzXs=
Received: from 30.178.82.3(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0WNnoPI3_1737093467 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 17 Jan 2025 13:57:47 +0800
Message-ID: <21654373-2bf7-4e30-a7eb-928419677af9@linux.alibaba.com>
Date: Fri, 17 Jan 2025 13:57:45 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: =?UTF-8?B?TW96aWxsYSBUaHVuZGVyYmlyZCDmtYvor5XniYg=?=
Subject: Re: [PATCH] scsi: target: core: add line break to status show
From: Guixin Liu <kanie@linux.alibaba.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20250114025041.97301-1-kanie@linux.alibaba.com>
In-Reply-To: <20250114025041.97301-1-kanie@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

gentle ping...

Best Regards,

Guixin Liu

在 2025/1/14 10:50, Guixin Liu 写道:
> To ensure the output is not tangled with the shell prompt, add a
> line break to clearly display the status.
>
> Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
> ---
>   drivers/target/target_core_stat.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
> index c42cbde8a31b..210648a0092e 100644
> --- a/drivers/target/target_core_stat.c
> +++ b/drivers/target/target_core_stat.c
> @@ -117,9 +117,9 @@ static ssize_t target_stat_tgt_status_show(struct config_item *item,
>   		char *page)
>   {
>   	if (to_stat_tgt_dev(item)->export_count)
> -		return snprintf(page, PAGE_SIZE, "activated");
> +		return snprintf(page, PAGE_SIZE, "activated\n");
>   	else
> -		return snprintf(page, PAGE_SIZE, "deactivated");
> +		return snprintf(page, PAGE_SIZE, "deactivated\n");
>   }
>   
>   static ssize_t target_stat_tgt_non_access_lus_show(struct config_item *item,
