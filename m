Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73ED1367;
	Tue,  6 Feb 2024 00:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707181060; cv=none; b=oSHeEP7AwLVXzub1hQrzYJQ/FiWjlODaNEGeqwQPFFh+Ia97MLnnMRMZFoS37ThaVgu0+721D9dQVWLaKbmtmA9grOL9ZjcUMa/TIrczibf7DI2fLtwsHs5HHm6g64IwkRcxuLlUuFE326JGqL5DG3UStokGFvaAvA1MFaBDE2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707181060; c=relaxed/simple;
	bh=YWNKKmsMv/jBqFoU7Yl6BOcdIWeoPqHd7UeMGcgtxRo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BhasSDsPPdrPiEm1zq1FFKeJFuQm4AjtDabKmKP7U/dpVrlmCwxZhGImelm91wMzEOxMLhFT2YMKY+jTfLozANypoGndv4gFJOEW4F/kqJiNomVYnqTSUgcbpooLQgIZMP+pdvY/v7IUmx7MwpJhjPDNkN1x2pleA+FVfVVTgGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-5d8b276979aso317764a12.2;
        Mon, 05 Feb 2024 16:57:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707181058; x=1707785858;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=opHqb+C62MdhDCBurOh6qgNf+dB4dwPStmEHHYjGuQs=;
        b=MTF/DSXm67Ek0xNxMV2IfDIuL+FFnDpk8Nvf9Cc5yRPMAc3bcGnNlsZKlU5nZ1dmuA
         Y9oCr+aamKDQ1DCHL0wOtn08P/oI2YF43Kd41uVOaFA8xQFzo413YW63AHRUXHOoksjx
         c12QLS/9Kz+NBBreK2Up4P5Z6PeG6m0ieR4x1EwfIW8+Yyn39i25D0wBmBVn/R+WRcdf
         TOFAP/0p4dL7YbUvQYiQzGVU8RRxq2yTzUrJrWabMdTZkRuQrMHKZJ6agXN3PdlIKPUx
         +G3v8PHLwVu8NB4Aqo0OmL52yynWpDNA+cZ0p82FzQjMkQR5VifIx9/Mg2C3KmzIUeJE
         Z1vQ==
X-Gm-Message-State: AOJu0Yy98ryxmrHDGSqY9IbwBySlMIKwHuQVthASVNuBAm+gCUrBHk1z
	NZX/OgGKKmQHlYFw7rY6Cd13LpI53laYjMNenmOAZn+yuXRArabk
X-Google-Smtp-Source: AGHT+IFgEqpD+F+h/zwX8mI4dzAdSsOBPqzDR+llq5TTnQWnncz39XzUg62UjYTHQWYfuWai2I6HIQ==
X-Received: by 2002:a05:6a20:3d8a:b0:19c:b3ea:27ba with SMTP id s10-20020a056a203d8a00b0019cb3ea27bamr171383pzi.52.1707181057909;
        Mon, 05 Feb 2024 16:57:37 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVKRXhnFahbWUq+nAQAqMtfCnJ7Tna9OqKRm2WnZQL/Mh5NLT+yd4LyWd45ZL/gFFccK1p0jgZ6exFt5sKlJF9XXLDZ7H5vGvW/D+vwZF8TVFngxA4ndfQnfveeb3wcoJt2OpO89Y3qoO2ST0mB5zveFC4mmw+BbRODmQmKziPuxaj3qqU42L+IH8OkBATSwYY4fze9qcAsix4syv+MIWKaLNdp4kla1uxEMZPDjVLIcObSkKOvs+gN6FKTjhBJtq1y8Q==
Received: from ?IPV6:2601:647:4d7e:54f3:667:4981:ffa1:7be1? ([2601:647:4d7e:54f3:667:4981:ffa1:7be1])
        by smtp.gmail.com with ESMTPSA id e3-20020a635443000000b0058901200bbbsm696647pgm.40.2024.02.05.16.57.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Feb 2024 16:57:37 -0800 (PST)
Message-ID: <38c39245-3dbb-4683-8dd0-b5aabb672583@acm.org>
Date: Mon, 5 Feb 2024 16:57:36 -0800
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
 <7c98aae0-46d1-473d-8d60-8252a96c414a@acm.org>
 <ee72eeb6-f929-4879-906a-a628faa1c374@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ee72eeb6-f929-4879-906a-a628faa1c374@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/5/24 15:42, Damien Le Moal wrote:
> On 2/6/24 02:21, Bart Van Assche wrote:
>> On 2/1/24 23:30, Damien Le Moal wrote:
>>> The patch series introduces zone write plugging (ZWP) as the new
>>> mechanism to control the ordering of writes to zoned block devices.
>>> ZWP replaces zone write locking (ZWL) which is implemented only by
>>> mq-deadline today. ZWP also allows emulating zone append operations
>>> using regular writes for zoned devices that do not natively support this
>>> operation (e.g. SMR HDDs). This patch series removes the scsi disk
>>> driver and device mapper zone append emulation to use ZWP emulation.
>>
>> How are SCSI unit attention conditions handled?
> 
> ???? How does that have anything to do with this series ?
> Whatever SCSI sd is doing with unit attention conditions remains the same. I did
> not touch that.

I wrote my question before I had realized that this patch series
restricts the number of outstanding writes to one per zone. Hence,
there is no risk of unaligned write pointer errors due to reordering
of writes due to unit attention conditions. Hence, my question can
be ignored :-)

Thanks,

Bart.


