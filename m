Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31F976023;
	Mon, 25 Mar 2024 22:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711405774; cv=none; b=KJSJknnrBGfEU6Ju3lCFgL+0sZOwoHrn3dCue91+JQ7BEhEPSJFTXPQoS8ZtWy1c9lKe8ZMjxdJJBEV412WNWurfIDL2mvhweVMIjIYUyttJhRm3iKYo82qs4OjUrL1zCh3/7+MkI88MYCxKltLs+zKA8cLao7E82UWkiyaQdek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711405774; c=relaxed/simple;
	bh=1Ay2rHYFemB44J5xEVkTil+N75NLcE4PSSkIx8V5G5I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CtTn/ZPcbv0r3nnOyjRoZSxFvtJKqfe4cFqvdbvomhVwIj+LeI8azikrhhMb+usgbaI/6n7elk+J6mLlNLKN3m/L0+gxG6Mq7hp37EqcdpTsdwwPOtKcJs0rqw56Q5AjyYVlX9DGW+jeaIADv6nFrZfFJDQiDU/AoovKNhJ+cPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1e0025ef1efso29862105ad.1;
        Mon, 25 Mar 2024 15:29:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711405773; x=1712010573;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Ay2rHYFemB44J5xEVkTil+N75NLcE4PSSkIx8V5G5I=;
        b=O2gJrHOlFL+Hmx7+9yzrAW4Y+W/ts49wkK8VF/jBf7AuCw9z3hA+oICM3RIRRHw/qG
         uNG2nRc/vnbaU2GNtlFXHZGq9Aay6JJeL6+nzqm7nm6gAlPCT9gLla+EC4BtFT8n/gc+
         f+pfZnSvol4iuIANvPThB1t2xzseMwNX7PVtAIA0IWpHqX7FN5wtXi5FKhXXqKGiFco+
         UTXx2QUpTzd7Tp6IPiAf2OUvs+9Wys9innd0cJw3gKnpiPa36b1ZZo91lW5mo58zX5Cc
         dEPGJ7ChTys/apvuqMPDuoMXYc7sBfio8ZhKTx3gd1ZILEqpvk+TKiFvy/YbNiAHGJ8I
         KRpw==
X-Forwarded-Encrypted: i=1; AJvYcCXKAfHFxgibx/P027c1SfBHJddf4aNm9vr8/t3Sz879WiZyFdEpA1VaZIRhR/gyBT2LxXiMBTR2BfOfsW2bg31YmakwHJdvAsUlbfg2qJm1RZkH5SewPhjz8tesh6p9XzOOrW8QgPhe
X-Gm-Message-State: AOJu0Yy2GPv2WT92adHE6om8BTJ01Hs7xIt5XwUagWLjA1EU+/YRpTDx
	Fi2srnmJkOcn1Lm4dqOgYMbSQIsXYROAxrPGNbYX0jWJqek9Iqj+
X-Google-Smtp-Source: AGHT+IFk182OYI6LXsNe0+MNjqoaDZsE8bBJFlK6xMQloJ2JRx+dYFgULmW3i9PiYaDZOKxsC0Ecmw==
X-Received: by 2002:a17:902:e752:b0:1e0:b5d4:9f60 with SMTP id p18-20020a170902e75200b001e0b5d49f60mr5829559plf.28.1711405772921;
        Mon, 25 Mar 2024 15:29:32 -0700 (PDT)
Received: from ?IPV6:2620:0:1000:8411:262:e41e:a4dd:81c6? ([2620:0:1000:8411:262:e41e:a4dd:81c6])
        by smtp.gmail.com with ESMTPSA id p1-20020a1709027ec100b001e0d6cd042bsm936742plb.303.2024.03.25.15.29.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Mar 2024 15:29:32 -0700 (PDT)
Message-ID: <efd36ac0-daa7-437a-be55-a3379632739c@acm.org>
Date: Mon, 25 Mar 2024 15:29:30 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 27/28] block: Do not force select mq-deadline with
 CONFIG_BLK_DEV_ZONED
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-28-dlemoal@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240325044452.3125418-28-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/24/24 21:44, Damien Le Moal wrote:
> Now that zone block device write ordering control does not depend
> anymore on mq-deadline and zone write locking, there is no need to force
> select the mq-deadline scheduler when CONFIG_BLK_DEV_ZONED is enabled.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
