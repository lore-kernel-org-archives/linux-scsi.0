Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2BA1BF2A;
	Tue,  6 Feb 2024 21:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707254416; cv=none; b=orziJtgSYSY9ksbYbu67V61zhJzR70vTOE/Gq3coPDBbyQs1XFMiXdq15O0FpNPEnxijDR1YEaaoKYRmllusNsUhaWmUNt/x+/GZ02mbalolBW01w7eMgjqQhyLPPiIGyTxUf7RIGxnPP0AtQubeEwVmaVWBo131iLlpbVA3lz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707254416; c=relaxed/simple;
	bh=VmSgp+63oRXrwJQrAP0cd+6cguoeR3YBtDiu9iIrJYE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y0e44rzKUcL6HJkMAn7zs/aEvKU1pXHEVuHTkXlsNNPoqAgo9qKlallPL7wjvx9vTi20ByAorygqe5StQt3a27M9f/u3oHkoFyQpTTb1P/fFOTPecCAmTpLTr7yoEO5+17cC5vFHyA7bP01F0Z00gEGzIhbyE5U5enj6gYL3Y60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-5ca29c131ebso5514941a12.0;
        Tue, 06 Feb 2024 13:20:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707254415; x=1707859215;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VmSgp+63oRXrwJQrAP0cd+6cguoeR3YBtDiu9iIrJYE=;
        b=au7k6UTsDsJ/Pkceidn5uDhl4zy3v6s9Uo0rZI/I1Tg2oQheapVd+LlYZo3FYLWdmP
         va9c6jXDaWaHlslGlaDoPnHl0Xwgy6/y4e5peWGvSl5umr0o8p8JsD30DnvGt08CcZYJ
         PuikQrdmq29GY3a5tWHUa7eKW/F/06xuV7vxcYsovcLFYEAXSaOLG06puGaeOub5MbgJ
         dYm3iW39XAW0ijsB0+Onna7oKBiN1cubf5mSuGjkjP0Kv5tlyxMDCCfcwwA9pxEuNTQ2
         NVKkSDmWXUe04Vn7arXoSWLGhz7AgjyJ0jJKqJr+S88hfNF8ar7BQpxAF3cRyZRR58LK
         AqpQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+A0SeMoox3Y0+mqwQDU1Q6fIlFHBkLIXswlShaQYJTp+HcSQ/z14CaPsGN1fc2xSQcgPVeFqa7PKVJNuwOs7jFrR38+J++Vd6ZA3p9OMZDxdh33eNMQTdOq+fwPUZDiKpShrOYq0/
X-Gm-Message-State: AOJu0Ywz3rEQMPg9JB7OEg4R0jdqPBoSymbemYyUg9LGXkjE5qXNy3mk
	8ORwcMoRFsi9Q6GVijCjTyhBTEKbk/FsiQdK8luUCijNn/s+xO98
X-Google-Smtp-Source: AGHT+IE1dmlg1DJBfQqr1jxNrF1zBsdEDx8lkYpwaHXAhDXDyTCYrU6/HXa2sJ2t2VmI74L9DJJoOQ==
X-Received: by 2002:a17:90b:480b:b0:295:a8b8:97b3 with SMTP id kn11-20020a17090b480b00b00295a8b897b3mr745099pjb.40.1707254414489;
        Tue, 06 Feb 2024 13:20:14 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCW7XBAhxFuEe3PaxPzBa6pxXcvoCqeRNLsMRYKp/5Nd90UPdqU0nIMDtSmpc1Ofh4ffG2Cb1tjyVAxPzzUSFejEzf2N/bt9JK3kPiPU6MzweT1sj0tXgS53miUtMPdo8f7w+e3dZonPMTPdCWpy8tb04IjlJXpNSGWGLJOPoRJyAS9WhUyrFHE41rh692JAhkh7rnc0bRReRJyBobicuSKWAlhGCe7DJU5jVD+RgD364QUWM64mqvqT0Tws18BtvRnd/zDQENPJYpq9+8t8Wq49
Received: from ?IPV6:2620:0:1000:8411:8633:8b18:c51e:4bae? ([2620:0:1000:8411:8633:8b18:c51e:4bae])
        by smtp.gmail.com with ESMTPSA id nd8-20020a17090b4cc800b00296dd7eff41sm224974pjb.9.2024.02.06.13.20.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Feb 2024 13:20:13 -0800 (PST)
Message-ID: <2e246189-a450-4061-b94c-73637859d073@acm.org>
Date: Tue, 6 Feb 2024 13:20:12 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 25/26] block: Reduce zone write plugging memory usage
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
 linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-26-dlemoal@kernel.org>
 <09d99780-8311-4ea9-8f48-cf84043d23f6@suse.de>
 <f3a2f8b8-32d2-4e42-ba78-1f668d69033f@acm.org>
 <a324beda-7651-4881-aea9-99a339e2b9eb@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a324beda-7651-4881-aea9-99a339e2b9eb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/5/24 15:55, Damien Le Moal wrote:
> The array of struct blk_zone_wplug for the disk is sized for the total number of
> zones of the drive. The reason for that is that we want to retain the wp_offset
> value for all zones, even if they are not being written. Otherwise, everytime we
> start writing a zone, we would need to do a report zones to be able to emulate
> zone append operations if the drive requested that.

We do not need to track wp_offset for empty zones nor for full zones. The data
structure with plug information would become a lot smaller if it only tracks
information for zones that are neither empty nor full. If a zone append is
submitted to a zone and no information is being tracked for that zone, we can
initialize wp_offset to zero. That may not match the actual write pointer if
the zone is full but that shouldn't be an issue since write appends submitted
to a zone that is full fail anyway.

Thanks,

Bart.
