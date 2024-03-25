Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9107175F;
	Mon, 25 Mar 2024 22:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404811; cv=none; b=NxGNo7K3HXRymOVg+hi5XQM8weeYpTiDtAjPTgJMflC0NSYYqV32c7YbRzpODrFJyHSw7dbJK3ll7+aUhdjraIXn3DoBS7PNqke9sVS/cdCeE2/qFr4hN/mELnO5rvHZ695h8ZgKu4My2E3qdP9OPTopT0S2OxC55OMRhjM+YQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404811; c=relaxed/simple;
	bh=hN55zRuf1wTWfhOuZ1Hsv78yTqllTTJ254BBca/qaQk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cG9XUdwnJupOtS/dlKlg+jwgrSekMBFcvavfscmNtDIkxN1+TPUf7/9zaNHsNzp721m2lMH1AekgtgTA7GjxqP30HbCHz0UA83dZaqsfHKmfqjm2RjP5wQ1b0+gmvqp9XFGyoHZh3cryyVmYaVsGQ1AOcGAY3hGtC7dR00fsbNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1deffa23bb9so36284065ad.2;
        Mon, 25 Mar 2024 15:13:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711404809; x=1712009609;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zuN0euwq54EZtcjYVhfgSHBS8X1ggoE7zpwJRA9IdAU=;
        b=rLX24Fo4abfkAccK+MZQ/cDIIhb+/7adMYXFZwg+V9FN78aAIHPalx4870g7Eir8/O
         lW72rCYi/ZwoajVurUHE27iad6yRn+XJgXwXilpkUbUPy735arRUpIN7fbLmyL4y0Wum
         5ALsqkFv1uuYwhwq2BwxbszBrgyv285P1EfrFKgBSrYCl/T3DRAYx7kyZGq28eWqjA1d
         Oji61b0FpDUUIqgFrzoVgZ38Nht6nqhX5uD3Tl7qR8PhcQ3JjEp65YiA3fUawoGDENTx
         2vLsXYW3OcZUgtHZXx9C5rj9rDQL8nCoF0BBfJpBJtCeFQyCgdVgPIg9HoNqGPGcK7Gm
         boSA==
X-Forwarded-Encrypted: i=1; AJvYcCXl50no4CLC18F5XrYIDtn7WIrw3Y1/JnAy1lZL5Xbpfy8I7VOUWslK6pcRO3p3UEQd7NumvFMP+a3CkkmCetTXHaCWElhj2sJT0oBuIRa5JF+lCMjSRbTYwwz8eU1SpJB9VfVOsFV/
X-Gm-Message-State: AOJu0YyFqZaJWUxvdfT8w+DogKGqmZE35WH05+Ez+XAHFBQqi93mcB5E
	tX6FmIeOKQDA3Ji2Z/5AEJBPBtY8Ooa+lSnd12AME+YiFUOjmVg7
X-Google-Smtp-Source: AGHT+IH7D3A3vhycoJD9zsFoky6aAGhFXt3gON+zXNbmmnkac3mGgGxBCi5GcVNm1aUF9F0QqwqVXQ==
X-Received: by 2002:a17:902:c3cd:b0:1df:f624:a542 with SMTP id j13-20020a170902c3cd00b001dff624a542mr8579974plj.16.1711404809365;
        Mon, 25 Mar 2024 15:13:29 -0700 (PDT)
Received: from ?IPV6:2620:0:1000:8411:262:e41e:a4dd:81c6? ([2620:0:1000:8411:262:e41e:a4dd:81c6])
        by smtp.gmail.com with ESMTPSA id s23-20020a170902a51700b001e0310bb84fsm5229183plq.289.2024.03.25.15.13.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Mar 2024 15:13:28 -0700 (PDT)
Message-ID: <df2e08d0-102e-4754-ad91-e50fa643d744@acm.org>
Date: Mon, 25 Mar 2024 15:13:27 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 22/28] block: mq-deadline: Remove support for zone
 write locking
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-23-dlemoal@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240325044452.3125418-23-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/24/24 21:44, Damien Le Moal wrote:
> With the block layer generic plugging of write operations for zoned
> block devices, mq-deadline, or any other scheduler, can only ever
> see at most one write operation per zone at any time. There is thus no
> sequentiality requirements for these writes and thus no need to tightly
> control the dispatching of write requests using zone write locking.
> 
> Remove all the code that implement this control in the mq-deadline
> scheduler and remove advertizing support for the
> ELEVATOR_F_ZBD_SEQ_WRITE elevator feature.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
