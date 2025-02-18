Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9B61BC9F0;
	Tue, 18 Feb 2025 20:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739909574; cv=none; b=Gj0CeCRBGZaDuOIEkHpw6BPuUVvxW/xnflvT+R5NYpzT4zAO+3/BN/2S4pLGms6ec1BE9gCXFXFTARr9WIIFGcGwemafm98w9TumuJGoLN6TxRIRkcm7W1AwuKiyUaRyNP9UU/oU1aoguuCMTcah4s3xjEGXeehXHXdGL+REFpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739909574; c=relaxed/simple;
	bh=XU3f8iOzysWsUXprwUt22rCfRKOt8VzIxFdJ24lS6Ew=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uGS/YTdk+sd5dFrJorgiY0sYrVJJhxHSFJmT0CENI0kbHdAc3uiPeuDJ2xT3CjRsaZWprrCgW7Ykgqly16bkIgwUdb71mOZLlx8Mln55C4U6bUaH+id8ZpqhUzG4I+rvg3uegXSAtMhfX/n+9ljy4WXDBL8GK0gyqV43vBeJhPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LsktROp9; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LsktROp9"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4398738217aso22799605e9.3;
        Tue, 18 Feb 2025 12:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739909571; x=1740514371; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XU3f8iOzysWsUXprwUt22rCfRKOt8VzIxFdJ24lS6Ew=;
        b=LsktROp9Cs8TExqkaZc6O2k+wahPiphqwBNUcj9OA0zmv8Zta1+FnWFf66sYO2DudM
         HOkZ/D7/CFFTaIaeHKEmE6xCtSQUws1Ig3e3soKcmQNCPU3tyBufaHZ0U8VFDPzkV2rZ
         iRIHorQ/zX/2UWFGzM9CXe6pyCfB3q734pFaiaZsUAIgvqnmk6/HCK5XlSVZc43ZB46q
         43UDUl+nceiNAhFMiqxAQEs43vLIZOyqH2jOuigJu1AZmQXT962q2Tuy6BHlE3vfHpzQ
         XVmZyC42VDHgPon+9FcDwy8Ah0hUtCqfG6rcOev+CVKnO1t5cxmID5vCvprWqPQp+9EV
         3pyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739909571; x=1740514371;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XU3f8iOzysWsUXprwUt22rCfRKOt8VzIxFdJ24lS6Ew=;
        b=wXxuwCUAIyz+9u6QoRVwCYRAY/aLlFWvmeUN3fJYl2BcywM/OEGnsRGSjMo/XKsqSS
         dvoT/pYxovWGVQAVAKJ22je1tTRkzNwk71b6xHhlfYdVJr8ysLsway8vgtvSow6bt7Zr
         PRPAEYKY0HFtcrXE2UxLHYO0Wbau8xiOTt73ylgaLFtIzynTSCPYc58VfyAJ7oz7p67l
         FIJ/Iw5BPB/q2rldinHoGzKvpVGFbSAEwLOtFeAtTMLk1dr0/NGqOVr8M9sADdIvEgzn
         vvoxfXJeWE8gj1AqsyDQgiDiM5OE7lCNY7hJNamkP34DaFv9IiPpNXogySWuQway+jGd
         9Nbw==
X-Forwarded-Encrypted: i=1; AJvYcCUrj1SufFjGNN2+1pfIwjguMDSt/YOYo3JV/0dKyM0fA8zCWpNOJxnsczr4UMjWivtPntsJtwrOikN0ank=@vger.kernel.org, AJvYcCVUXTDO7UIKVSoGDdMnAQSpzMQqv+4PDgdDtYJtjtbG9JJzFiYTXll0BYWDcFHdRk9H+lQXXoMa@vger.kernel.org, AJvYcCWU47ylRW0z7+PlcPPmKLb1SFqNLh0MSSWm/huXQ9cfwleIAhs+IUabgUUXggRTq3mvAumcLXAvNt/Lhw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx864Kch+ZUU7Vh0Sxfzw4KpeCWpBS7HEhTP1fpOM3b237G7ngM
	MPEGPkDkgHe8euhvrPNypRxcOoLn1ItWRex6mw3lWJuqTee6nPmW
X-Gm-Gg: ASbGncscN1kz/tN1tUJ+DJ8h71OmXflufHY6UOHznYTqF8sqIsqKsWmrvsTpdxvpMYK
	FFvfOKiOg7DMza5BhtpLJKGDBd2djaKqh/wgKr0Dj1ubeLXChUEeXoCcLYix+xw9KWgnmhjw3El
	pS63uBtzLA06lWhluwvYn/6IIwNO3VnHqNDKgggJP/CtTuO+DCKcwF20CW39CYrffLuzFdeT+Qx
	X0UKKgpNi50mp+uT9KXh+rwUAm5DIlFhJJuoKDlG+TrM6Wkmjo0Nc6Ic9B7rT/u7DDzgr/TJAb+
	na8YhoqEf41SwhxFmSSWzN3hStuE7lzbQLi3r2w1baXHyXl/j+d9gIn2LcuGpcGjdcKMZYx3rhy
	KI9MlosYbw5HsVWiniIXm7ny5QfygMwVnZd1PwAOF9qRASAvg8+IsQMU=
X-Google-Smtp-Source: AGHT+IEiEhHUMciRlkc8m45+DoYr9S7LGgnXuuTNoC3ZNS/rZCh3L/70loUhge2qTW/GTrsMh/h6og==
X-Received: by 2002:a5d:480f:0:b0:38f:2efb:b829 with SMTP id ffacd0b85a97d-38f587f18demr541066f8f.50.1739909570452;
        Tue, 18 Feb 2025 12:12:50 -0800 (PST)
Received: from p200300c5870742464093dbbd827ec082.dip0.t-ipconnect.de (p200300c5870742464093dbbd827ec082.dip0.t-ipconnect.de. [2003:c5:8707:4246:4093:dbbd:827e:c082])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-439892aaf13sm56153355e9.21.2025.02.18.12.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 12:12:49 -0800 (PST)
Message-ID: <dc1f763aa4a86e50d4e9f92d3bf5988fc421150c.camel@gmail.com>
Subject: Re: [PATCH v2] ufs: core: bsg: Fix memory crash in case arpmb
 command failed
From: Bean Huo <huobean@gmail.com>
To: Arthur Simchaev <Arthur.Simchaev@sandisk.com>, 
	"martin.petersen@oracle.com"
	 <martin.petersen@oracle.com>
Cc: Avri Altman <Avri.Altman@sandisk.com>, Avi Shchislowski
 <Avi.Shchislowski@sandisk.com>, "beanhuo@micron.com" <beanhuo@micron.com>, 
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "bvanassche@acm.org" <bvanassche@acm.org>,  "stable@vger.kernel.org"
 <stable@vger.kernel.org>
Date: Tue, 18 Feb 2025 21:12:49 +0100
In-Reply-To: <PH0PR16MB4245F16B2732AF3078DB1DC6F4FA2@PH0PR16MB4245.namprd16.prod.outlook.com>
References: <20250218111527.246506-1-arthur.simchaev@sandisk.com>
	 <8be8c9c45d627e40e4ce3dc87c1ac83f32717e2b.camel@gmail.com>
	 <PH0PR16MB4245909AD2A1DE0EC2C26E92F4FA2@PH0PR16MB4245.namprd16.prod.outlook.com>
	 <9e7cc353d2407cbde723fbbb41db5ac6cf83ef63.camel@gmail.com>
	 <PH0PR16MB4245F16B2732AF3078DB1DC6F4FA2@PH0PR16MB4245.namprd16.prod.outlook.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0


Reviewed-by: Bean Huo <beanhuo@micron.com>

