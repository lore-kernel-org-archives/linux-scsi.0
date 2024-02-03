Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E031714F8C;
	Sat,  3 Feb 2024 04:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933496; cv=none; b=b5h+cEIWzehUqwryoC0c3u1gZHLyYcLQN0kN6NceyfhLjXDIoVoOOowEutA9zIUbHo/0XHMvtHUkKHURLLDqP3iTPMplvzJrz4rx6CpTII4GW6VsKcYKcrIozI7NANQ2aVC3vILDG4duClTPrTqT2YbBTraCfBFmZuInpqw6960=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933496; c=relaxed/simple;
	bh=B/CO6BWQJAUUY+ERXajfKk0gMicjG6ssUvDWGMYRyIU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OIWDqEyzQ+ds4bknur7xiW75WvZZh6XstmXv9CthaMWOnqCC3ZxK9yInMnMylRKciDrNFYj3ldDtFDkaCotH7c57236dKu3aP9SwOJGdi0MdkXj4csdNpAg38YzvNPgb8FoEgoNlyoUgfLsgzgYtu7wi2Vd+T9PE/XwO7P2b0Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6ddb129350cso2090133b3a.3;
        Fri, 02 Feb 2024 20:11:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706933494; x=1707538294;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yQr/DlZ+2VCTsXdSflVpS2G3BtwxEe3N/+eH1UzREmI=;
        b=EA0p1CtUGep09705E0R6whtzLoxwx4r1dZsK5QzSYg35LB8UmIKPb4jgj+eWDcqnqK
         62r/b694ccClctYLiia1efNuAZg33a89EZFVTbKDz87skQbR1TYu2kdV6J6jdIVPwdeY
         dvp/K8LkzIPVBGz31cwYYSDyp3xhLaoxvLhobrXiAqaZABC5+9ATDp3PiZsMVTrdL9Fz
         rN/0dpOtNGKCQS5n73qZiGFoithvnihOddt2bha0B/7rjceuXBjfWVQFvh9vMCN4xm15
         K5Q5l372S53awygw7Ac0ZuyLJwDPTCB2gr9yP/s0Qho/6to++9kxCqz0oPnFfC5V3LqW
         /BDQ==
X-Gm-Message-State: AOJu0Ywqr/7qxxUgva6YcX9eKlU+KhIP5EH0fjfUa0E7o0wmBSCmKRUV
	Bgrn7NzXx7Pb3oXDX4CWmLumV3Z9KhPUW+MPbolnxR++5wsM3V73UohKbzO4
X-Google-Smtp-Source: AGHT+IHX5Et9x7nMIgkyTbDegGPONZwCy1F8OPHEVc8Y90kiF7mcWWw4mUUPoSUNvHkeIxHnvdTqoA==
X-Received: by 2002:a05:6a20:9398:b0:19e:3a8e:e723 with SMTP id x24-20020a056a20939800b0019e3a8ee723mr10189182pzh.17.1706933494124;
        Fri, 02 Feb 2024 20:11:34 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXIs2ElHxFvwnd4vV50hYTNDvH0W61loC2pvhjAQg9c6g2HdEcZg5VvfZa0czX3V1LtbqZB7znG2V58sFLz5KTipScqQTsrtZxf+zPa/oaHDZ7HWmFXf5SlwjnX6JGmwBmLa0T1ZasR/AxKy5Bdbu8yBaX+vE0OBex39Zf3nMJWGm13LQ7A/2NhEmSAsrxBuPXnOUy9c0vKOVtjiIv+R/cdnxzfxHzAbtaEsCNgL+EjbcgtOMsCrip6LCWXN1R5c2QT5g==
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id pm14-20020a17090b3c4e00b00295f900f38fsm865716pjb.11.2024.02.02.20.11.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Feb 2024 20:11:33 -0800 (PST)
Message-ID: <a0158ca3-b908-44b5-a6ea-117b1f8ca1e7@acm.org>
Date: Fri, 2 Feb 2024 20:11:32 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/26] block: Allow using bio_attempt_back_merge()
 internally
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-6-dlemoal@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240202073104.2418230-6-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/1/24 23:30, Damien Le Moal wrote:
> Remove the static definition of bio_attempt_back_merge() to allow using
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
To me this suggests that the function definition is removed entirely but
that is not what this patch does ...

Otherwise this patch looks good to me.

Thanks,

Bart.
