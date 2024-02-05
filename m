Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2ECC482D1;
	Mon,  5 Feb 2024 17:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707153678; cv=none; b=BsoGchIERe5QJCACJnOs46JnfjnacWgUiP0gi6P79QT8B3SZqp6RYeLZjw5gzuUMbHxqOLx598r+GmWLMgKbvlI2DQLIInpyTZTjcGFHPJ8kRXjUfvoKrs9k9i/uLnlebapTwwOfb2Zo10ktflPDOG4ieGOIwgevKdfU2SPMynU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707153678; c=relaxed/simple;
	bh=+s4G4yE224/ZsT8tVQV8ZetJjGuXRmqMB/KHzuIt7JE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A0NoR6Dq3WnIk/nqSG2n1mL2upeu3lH3eq1/UijRIM3WqRmKvULQMPeju6ykm285cF9RGEfmSWtspfuPsdxRrUYneLbK7KbEcWDHLkFU//WFWG4qhum7mLtZOBLxT6P93BJqOPmkes+rx/GW+09F4Ra7HjHI2imIHgjIwH7hOpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1d91397bd22so35610995ad.0;
        Mon, 05 Feb 2024 09:21:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707153676; x=1707758476;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+s4G4yE224/ZsT8tVQV8ZetJjGuXRmqMB/KHzuIt7JE=;
        b=D6Tdwvtmf+lQE1K5+MOutURl421nRkcFNVhRIa2sgwa7OBD0mU4b5rlqOd94LSvCU+
         Lijl4M8ZLbfPz9ylJuckfQYXxI2K0A/8zg1vfUmY1sjYdmuOvl9WH/RWZlIZw3YzBLXs
         vew0oLnwSH0yVsOc++/GtfN0Yw3vHmAqGSReJTcxTuWCNR8HbcEph0P6Ar9yUKTCW/R7
         88sTVipzB63+LtBiCE1cWMInSU0X0v9TKz5KqlSW/u4EHhx23xMetJugt2QCgj6E3BU/
         0L8gF66uyOTmGN/bsKOECi1l2PHJ2sOrSKvtoOL6VjyXmlCHbQHdcSfk32ZBH00VsOZD
         Oekg==
X-Gm-Message-State: AOJu0YydErKED55EDp0ywHALSBJGMZlAIAZQpVn6Xn05QpWm1fSls2Bo
	gha/uIG+eI5AL2gvKGs7Vi6qp7Y7gLpv/xNk+wVSSyJZX4ncWfqU
X-Google-Smtp-Source: AGHT+IH6DGakhIlE1JJ4QYIdlK2j575hUSRaZDT03chyXNlT1fTCvhZ09RO4hsAqM2SS3pXeLK8meg==
X-Received: by 2002:a17:903:94e:b0:1d9:c534:62c6 with SMTP id ma14-20020a170903094e00b001d9c53462c6mr191749plb.1.1707153676139;
        Mon, 05 Feb 2024 09:21:16 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVY+oC3Hl8G47MOwoLbDao2WE/eTVtHUdLDX9zXqfv4mgXvddcObQx2EBvLZDidgYdOm0Ib2eELeShQD5b760hX553hZp9Uppw/CThVchHIBgX3SeAl7XUNxLLanEFQDEQSzWE1x20zxLkMa+BV/DIeFuQ70XyjwshjIb6PEZViF5p+E7WXkTBx3luu59kDsbo4p/FKYPAKlnY5RpwNpFXTGh95xEPAqBzYX/mQIum/pgdo/slusULBMqpjCUAkpt9f7Q==
Received: from ?IPV6:2620:0:1000:8411:be2a:6ac0:4203:7316? ([2620:0:1000:8411:be2a:6ac0:4203:7316])
        by smtp.gmail.com with ESMTPSA id r20-20020a170903411400b001d8ec844fe7sm103169pld.283.2024.02.05.09.21.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Feb 2024 09:21:15 -0800 (PST)
Message-ID: <7c98aae0-46d1-473d-8d60-8252a96c414a@acm.org>
Date: Mon, 5 Feb 2024 09:21:14 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/26] Zone write plugging
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240202073104.2418230-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/1/24 23:30, Damien Le Moal wrote:
> The patch series introduces zone write plugging (ZWP) as the new
> mechanism to control the ordering of writes to zoned block devices.
> ZWP replaces zone write locking (ZWL) which is implemented only by
> mq-deadline today. ZWP also allows emulating zone append operations
> using regular writes for zoned devices that do not natively support this
> operation (e.g. SMR HDDs). This patch series removes the scsi disk
> driver and device mapper zone append emulation to use ZWP emulation.

How are SCSI unit attention conditions handled?

Thanks,

Bart.
