Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30844193409;
	Tue, 24 Dec 2024 10:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735037070; cv=none; b=a6iuZKpqO/dV51c7FLIeMHmxJXGL9a5PiCUfxFE2sP5jPfI232U2LIE5Wx+A4XdEm0y8sVy/sCTrxCEV5Pg62JaW/Roi8Ne81kqbQ3oT0BfwYEZb3mm83SgIUDbeTbgIwfixfyqXWIq22AGx81qUC8TivTEEnKRfsTMm5xKaxM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735037070; c=relaxed/simple;
	bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KzWhr2C3bZlLWL7n+Y7Z4CJBtpgj/+gskB4IaIs7JdVLXha6ghR72G/QJ3DNrez6g3BgxkdeaMDjpFc0R8lwqDAtDO03PwAh5UHbCWk6hbVsm1RnIBGJxL5WHi6e8cmMjkfXo5re6JpUxd4AeH1hMdAYta3Y5RksPBK14F4XoFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43618283d48so36934035e9.1;
        Tue, 24 Dec 2024 02:44:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735037067; x=1735641867;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=TFHGpDpHOYWirYFSDDp7RZmTrpnTugdGQb644NNm2JG+fOLTRNaGJQsDuowJ07gvNt
         0r9YCnYOAp3Vz7/DbpZKJKpflOFo7wJprHikhJQuUfdUUbJEONO2aa1BUfoWXPyRARHc
         VL66AtnRiRvWN1gWH2PZRuCFo5494WscY24Lk8yDy1ojn1tFsFhXuqYcbZS5cfs3daCh
         gvbF2Xxd6Zt65ZLXsMC3xotrw1bnMkJnUycCnYD4KwOuNrPG10mxpi0hummDuaMtSqDq
         JmQYvKYr8PEDrbnKI6rFA6mkuPL5rBsVTKT0sVE5CX3UyoZVt/r0+VGDd/I4c4TPGkwb
         aRfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWn6oEshrCt6/sAOnYRTLZlmg9c+zNH/pQLjYwJknbf0nDBkNZzMb9FQb8ihM8UYAEqM6632CAIHluvuhv8OM=@vger.kernel.org, AJvYcCUf6+fPIjuQEnMCYnXN/PR3oUzpruCixVcHyyogf8c2hZO+oZURnuGEXRzSTNxyhCfVIZzNJgVrkkNJwOZc@vger.kernel.org, AJvYcCWrmcvPqzlP5TbQpOqik/+iWqYqh2qS1HMoZnRxb+dfDS7ykErrrlQJQOJbImX5qE9zw1vNNwTZfRH5tT25@vger.kernel.org, AJvYcCXZqK14tTrykui+BldsS+8YKPp2uXpgPKe5aljHBZpthwKiGbAXFTeR8ST++bSGCUgvMtf6tSAg@vger.kernel.org, AJvYcCXtnvXj0y5ViqhqeIlt8EVLohRpQiEX9l8R+p7M3RVIDpnBV0kVOR2fF8X1/Ye0dYAda9RNmuTMRhmG2g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyJlDbLfzB4hzK+xBPzvl073NLk1Yw94xYdgmw9EFOjHLPFmSh7
	sloM2wLJf8vrcrn4z8I9DUOPZ1Sb4krJUmnji2FQxPCXDBKhYbbC
X-Gm-Gg: ASbGnctRxHDEEXpi3HWF+uhAuaUxd5qxsYoqHc/FMjjs04MKVPLIwHHWrxYF6mQB75F
	T5M6H8czcJ38KBGsYSwKuMRKrtQ2znkVz8matBEfTvU1VyZwPZjhUUnIasTHOFgiYGz9MZmu9B6
	u8NsTTJ0AL9KtSrAhvG/ueFEr06Uq5HSvOLTuzpQCuxfOwz62Ewel7BWUrCiewzBcCYxUTUvWO2
	IiFqeT9l2b+Ii1Uyh0hGmYt8YPNjxMbsr4CZc1Bjv1TFgoH1DWfcEJrwb7t5PO9u2wMIU/uUEOv
	szzx+ULJhBWAeT4WFHYDO0k=
X-Google-Smtp-Source: AGHT+IHxq/iA5grijNAymPWay23D0iFdsFNkmhYOlxQbOIIanspFe78QUP99gU/SefByF5UHbl8HKg==
X-Received: by 2002:a05:6000:144f:b0:385:f271:a22c with SMTP id ffacd0b85a97d-38a2240e20bmr15043579f8f.59.1735037067445;
        Tue, 24 Dec 2024 02:44:27 -0800 (PST)
Received: from [10.50.4.206] (bzq-84-110-32-226.static-ip.bezeqint.net. [84.110.32.226])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4366127c4d7sm163226825e9.34.2024.12.24.02.44.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2024 02:44:27 -0800 (PST)
Message-ID: <47f88e5d-e262-40e5-87bc-ea2e30ec8bc9@grimberg.me>
Date: Tue, 24 Dec 2024 12:44:24 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] net: core: Convert inet_addr_is_any() to sockaddr_storage
To: Kees Cook <kees@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Chaitanya Kulkarni <kch@nvidia.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Mike Christie <michael.christie@oracle.com>,
 Max Gurtovoy <mgurtovoy@nvidia.com>, Maurizio Lombardi
 <mlombard@redhat.com>, Dmitry Bogdanov <d.bogdanov@yadro.com>,
 Mingzhe Zou <mingzhe.zou@easystack.cn>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Simon Horman <horms@kernel.org>, "Dr. David Alan Gilbert"
 <linux@treblig.org>, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
 netdev@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20241217012618.work.323-kees@kernel.org>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20241217012618.work.323-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
