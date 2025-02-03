Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758D320A5F3;
	Mon,  3 Feb 2025 16:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738600604; cv=none; b=WaF5AFcgCsEt1wbhaPcGbd/pv5nAlx6Z9SI/QsU5sE0LRTAp//6QNqF5ExXgtCOedDRzhq4WmP0VrPnyg49TmHgB/SWCZpV4PRDzQ1Cq3hghsYQCtzjHHKFxYe0HEl/kVWerPojuyi9yUFGKg0tMlb2m0VIwGwkrC9tNVxSirh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738600604; c=relaxed/simple;
	bh=Th26iYp2XuD43W1x+7a5A9eLqjsp5VY46yzwxOLF4BQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MS0YKbfx0VB+EAQBNQcYvgWZHsCg0pYRf+gAtMrtB+R/xXprFPeCBq3JhU00DrB2Hz4ls/kw7vl68T16+xVJCcMmoyCFXclC3jKx2ybNYOzuo6LRmr+gK1P6BA8ODX/N9ur1rCCIOQ8Alfta6bXcP1CR5NQ5FZIfFj48HGgXgs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ava/JbzX; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ava/JbzX"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-21649a7bcdcso79749035ad.1;
        Mon, 03 Feb 2025 08:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738600602; x=1739205402; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=JRABxOQ8WRZtkYcvMbooXK/iYiPhVNE0v215EGfljsU=;
        b=Ava/JbzXzDho+YmF+ElwS8CI8WfaScLnDXhoLINH3QeHOR+iy9lJ01Upd7c7OaoH3k
         k+7/UTm4/HiOureVE2hB5AfpjPCve0/94Ka31qWDPlp+RABzbPG0GNey4b5qg5JkCSRD
         R6C83IIB7XPeEvbnB2kSIrzb7Mp7byrci1/xz/cRaeQPYwbV9NYoEdPjwONbYgHbyXpf
         G4sbvu8c8rPxrWPMFGiSZCniePQ0nj/Zym43CkzxAhf8uIaLkacUdG6JLB/uPjXZfPW+
         Q5E9z/5GnBpf/x+PZESjtM/qKodfpWjZqZANS8+CcmczmzKD32k2qNKCcf4esAQ/fB8+
         VLjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738600602; x=1739205402;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JRABxOQ8WRZtkYcvMbooXK/iYiPhVNE0v215EGfljsU=;
        b=AnvfexNfj4B8YByyiz8Z+QXJ/Y4ALoIJNSMuUX12R8X6bqYPerSmNakav2yqki4U9K
         wwE2mFV83r+s0QBCQCUbcM3kjWAy18KlTewexFtyi3c84J4Fusc4bpjMlvl5+Nj228P+
         0Pn5g6z7ae3MjdGgOif+7oXJG801va2RcGA43MvhFu08NTt0JNlIHYp+4MYmq1uLMDQy
         IBF0rQcb1jLi1TOveTJkA4MH2mlo+jvclyRvyPH6zMwlU5eEYT33kR9AIOZ5VRLs+NV7
         kQ8Py9up/z3sJeKUMsKwQ+G6zvSo61/limwvw9uoUCLFq5WRmgxctL5IMZjquPnewrSW
         +JfA==
X-Forwarded-Encrypted: i=1; AJvYcCX8uzD38kvRqx/CXcFHfCy/I8X2kVlDDr2UZdGMI4LsKGmqv9R594sDa3B9QdeQjwRj6Sm5CY491yIAnSw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHDOZ6i2KpqQwJljIicMa5jgiplGIZWC2fbmArmyg3sIRukyCs
	cOv6DyNgPVSbNxMZPuuDA8g+Lli16YMGkZBs9HTDF6ToPS1NM2FoWMOF8g==
X-Gm-Gg: ASbGncsM4XT50XRKec8eH3QPkjLXb6oS+XHOZam7Vxxdx3ORrI8cMIUb9mk32x5fs40
	mbXLOkWrgjJGCrRbSuvT8TDuQo4rlJToGlobtvg+t/oYLHNI8fncJo+Hj1g+evHtSqYAHoQCfEt
	mkqb5p6sNlGbs+7m8yrMKQtvxPkNmOz0BAX0dGtilyMTb5JIrz9PsfoF9Z627NC0WegzuSgflcj
	pLTQLn2UOl5IoG55tfMlii10EWhRYagyFnLg8m5LBQo8O8Z1pvQm21p1Y5GazhlLd1vlTloSB4P
	ezdfxK0TZYMAs9UU1GUZStfbiBoKpc3tenOnjBX3tQP1btps9VtdKZ5/gT+eVfJx
X-Google-Smtp-Source: AGHT+IGvNU6PlPIzp3H55iEq/6qCotY9r/ghvH8ohwhb0aJP/aeZ7H66lWI3vVww3voVViwFaPegZA==
X-Received: by 2002:a05:6a21:150e:b0:1e0:c8c5:9b1c with SMTP id adf61e73a8af0-1ed7a5b66b8mr36833463637.9.1738600601606;
        Mon, 03 Feb 2025 08:36:41 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72fe64275e5sm8603450b3a.70.2025.02.03.08.36.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2025 08:36:40 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <d45b05fb-e98b-4df8-a33f-37ecdd23f67d@roeck-us.net>
Date: Mon, 3 Feb 2025 08:36:39 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: Add support for critical health
 notification
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 Bart Van Assche <bvanassche@acm.org>
References: <20250203152735.825010-1-avri.altman@wdc.com>
 <20250203152735.825010-3-avri.altman@wdc.com>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <20250203152735.825010-3-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/3/25 07:27, Avri Altman wrote:
> The UFS 4.1 standard, released on January 8, 2025, introduces several
> new features, including a new exception event: HEALTH_CRITICAL. This
> event notifies the host of a device's critical health condition,
> indicating that the device is approaching the end of its lifetime based
> on the number of program/erase cycles performed.
> 
> We utilize the hwmon (hardware monitoring) subsystem to propagate this
> information via the chip alarm channel.
> 

That is outside the scope of the hardware monitoring subsystem,
the "alarms" attribute is deprecated and must not be used
in new drivers, and it isn't actually implemented by this code.

I can't control what is submitted into the ufs code, bu from hardware
monitoring perspective this is a NACK.

Guenter

