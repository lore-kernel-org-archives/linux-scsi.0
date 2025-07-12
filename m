Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1943E1607A4;
	Sat, 12 Jul 2025 15:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752333428; cv=none; b=F/wbOKIH3EB3xV9NKmsMwqCDgGbnzeQX0ql/dCTSFwYcPajLN46EBjFv5sHtx0PU8oQ18kTWhtFa1PwOrWeoDQFkBB7bOTRJcL57cbiHcuJV3B9rtY0Rh3bu19aJwGPX35wMWGeQOo7VZSViq4+lnTEu2lacE5kJHCCFXQxuruk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752333428; c=relaxed/simple;
	bh=aMFFlD8sxb6KfI7aiKzBAgW2ILixRygjx5+/rKokabE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bH1g7lJlXH9TLuKHFz5kzDzGBd/DiFP3V/EbZ3MdE3WqNE8Ec84EXcryaZYSM7h+0HO5RislT8yfEwujgEoTTfPXl3WsBugBcBeKAOhAdZ5P89uNDaKfMm9V0qrnzVVpm8wdpEeVF+pYhbwdxi7JcBwbTTTDQtlBazRzO0QUEFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RcQP2LTL; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RcQP2LTL"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45600581226so7644455e9.1;
        Sat, 12 Jul 2025 08:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752333425; x=1752938225; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aQYhbDjEdkH6qRbj8NEnL6UoIBqxgyMRymT7FTKAEPI=;
        b=RcQP2LTLE5h/LpVgDkArkoxG6zOsKFzKgUl4Enz3gRAtc/HailOWiSAZGm52JY6232
         I4ts3g5MH+yWm+LfP21HpPg7NlbypOtRhryqmBssO8X46ni/mxOGVVnX9NkeDqrubimN
         DZjg0vJH6RMsWqwbVqRN78F2jZNpfquJOMlsFvOb3HaG8Y12DvwYGtvuZaTUSTh9Ntmb
         zMVZuOGFlrB53ecXOpyFRDmDplN5a/SfJI8dvSqMwedRADah4/LQ2N5Bbg4maJinen/F
         IxybFUZqNpIoJ0Yfawg/nZYO2ISi2yKYLW+aFDPyFLyvxkWOiz3Kr3ahmSlyoD8HVEYa
         xRsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752333425; x=1752938225;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aQYhbDjEdkH6qRbj8NEnL6UoIBqxgyMRymT7FTKAEPI=;
        b=rbDKmMm7zYp9R3Xgij9M1mXf0N4w+OQDnqlexv12+aLI7WYn4z1NyLDtCr/BAH+l7O
         25u6NSl87z1UK55nGCfmzEr1vw6Gj5rQ8YcgRTkURGN6J1pYYvV9qBq1HtQQEgWuBxUE
         hUJV52Wt1VQ9AdS74boMbSQ9zFBgne4LsZPtuE+bJi0bdsQtm2trklcJcsb+l+0PlxdP
         SW0n84BJwXbYn84hr3e8/LpoRLt/U+oXP09qiCYVEk/tGdbfsKpMQb5x77AbZe8njbmM
         RkZ13vrfg2RH1lFlS8gGv3kYTcOXxiEZLA9CEKuVIBveWcVKF+nxVgfmMwUUOzrleWKg
         3+yg==
X-Forwarded-Encrypted: i=1; AJvYcCXNervhfEfICRzrnI7sBnIOnJkOBoIfzemDP/b2esT5B2G+5/X2Ky68d5tKlgmuU/NdnVDanW8G3SKRRQ==@vger.kernel.org, AJvYcCXnbvFBuJI+PFDi6dPvrTMX5PA6cvSe9Jnzh4Sv+ebdJ5zOGmlHET8q3EaQcUgxWhwsY2zFAYaZh25g3VQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOyZAPsZqatGxd6WtUxVsy3dIrRz2rI9iL908vvCUBPgd5Wo6F
	JEMQdsmz7M0s9yAUqD3D/veYrLFXyODICQp/9ad1WzgOmVMDHJyy9D0RMR8SRw==
X-Gm-Gg: ASbGnctCvVM9ad5q6RcgYJKsF9RA14WepAu4fFz0uEU54VJZgj/N5O6NckX7JV4xVhu
	AWNVR0G+zEQWalxkhZyWJUdVWTveTwKpNASdFSCAnl+RewAYbj9GG51+932vj2/PxyfuskU4qa+
	UtgcX3GiMj1qh2Uz6tS9GD/EN5SP2HozfrwG46yKYDuv360xby6mhIBIdE1hCVU/7nQ4nnUD4+p
	Y3uP60WYdNX9mBcZKclF4/A7XUjRreKRZRimJ8ema44wciO6p8WgOYwxyY2DUPEXJQ96sUd2aHn
	N0uKjelDjLzQp0YjxwlVAEsgHNB2TAtSf48ig81U9VZHiBX3vJW5atZeuaq/sxWOWY+Gvu9cPBY
	F2UiL8M6aVMyPsec+VS/qxh12+L0VpugDISFJ8g==
X-Google-Smtp-Source: AGHT+IHsKQ0zL0Ztqsc+6mKM3Sd3cljTVmePtjv8/kQwA/IJ+3LpPzNoO1eIPju7wYqam1fDK9fNbA==
X-Received: by 2002:a05:600c:1549:b0:43d:300f:fa1d with SMTP id 5b1f17b1804b1-454f425585amr76589345e9.31.1752333425128;
        Sat, 12 Jul 2025 08:17:05 -0700 (PDT)
Received: from [192.168.1.13] ([154.183.63.38])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454d50def1fsm117167725e9.21.2025.07.12.08.17.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Jul 2025 08:17:04 -0700 (PDT)
Message-ID: <806f427f-2d6d-442a-b207-09cf59af642e@gmail.com>
Date: Sat, 12 Jul 2025 18:17:02 +0300
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: hisi_sas: use sysfs_emit() in v3 hw show()
 functions
To: Greg KH <gregkh@linuxfoundation.org>
Cc: liyihang9@huawei.com, James.Bottomley@hansenpartnership.com,
 martin.petersen@oracle.com, linux-kernel-mentees@lists.linux.dev,
 shuah@kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250712142804.339241-1-khaledelnaggarlinux@gmail.com>
 <2025071244-widely-strangely-b24c@gregkh>
Content-Language: en-US
From: Khaled Elnaggar <khaledelnaggarlinux@gmail.com>
In-Reply-To: <2025071244-widely-strangely-b24c@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/07/2025 5:43 pm, Greg KH wrote:
> On Sat, Jul 12, 2025 at 05:28:03PM +0300, Khaled Elnaggar wrote:
>> Replace scnprintf() with sysfs_emit() in several sysfs show()
>> callbacks in hisi_sas_v3_hw.c. This is recommended in
>> Documentation/filesystems/sysfs.rst for formatting values returned to
>> userspace.
> 
> For new users, yes, but what's wrong with these existing calls?  They
> still work properly, so why change them?
> 
> thanks,
> 
> greg k-h

Oh okay, got it. I was under the impression that older scnprintf()
calls should be actively replaced  with sysfs_emit(). But no need if
they just work, unless there is a bug or something.

Thanks for the clarification.

