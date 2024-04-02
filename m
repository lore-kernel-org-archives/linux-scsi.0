Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8FC2BB1F;
	Tue,  2 Apr 2024 06:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712040262; cv=none; b=B3bGgWnZAzl+499iqXBx7CEXSKagJbSK1hFH6E+3eXyxHECsoDPaJYDYaSVskNJt2MHRvdu/eyPqKnq2Ylmetk1PcaodS4LFMH0iGtJdRQ3qQUxM827bLi9tSYxlCwwog8ZX283qAGkf6KOkmYdQE8cS1TmeGSv4GhVwl/15OOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712040262; c=relaxed/simple;
	bh=m6n+rmD1AQUeFVuOYAPQoLt/JLCEJTj1YtNrJPF/8b4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=SlJFibV2STmf7XO59cJW8B8Ss5SEXEJU10m1lFG3OlFurs39aww6CEhKfCskVmW8gvF8x+Sn+qWQIbKN1qy704ZX+kKYvq5fJTV+1tU6UWvB0JxF7Z/yp62nqQq7aiQheW1GASHASTAUNIJa88DRGYCjGzHep9xXNPj2SV6vDyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JHPhJsi2; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JHPhJsi2"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6e6d089cad0so3201811a34.3;
        Mon, 01 Apr 2024 23:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712040260; x=1712645060; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=o4Gt2A/YlxbVubczq49Ydic0OlMC6zIRUZ48mhZIweI=;
        b=JHPhJsi2BAlmOZUUItpgMGCQEKhGSt95EuQWTuMUKMqR7yydqg0oGejl2gFDHP2xRp
         zV1PhiYfK818aaD6rjZ/UwGzjBWfQ1UGRNIGYVHDsrFAfqconJ9A1/mfk/tcJHkc52yo
         GyfVpeCCbLHODbrJK8+DcmaYKVEA1eav6UdxQcX//yAXIFjHxiDtQJ3V6p5eXjG4z1wi
         snxubE+n21B0a7KTMpTcLbbrjd50+2Sr7LvyzwNyrG9ygGFJuTB4DpN+ehv8G3x7uaUq
         gUxKlsj3igdWz4f+liLzbWOXrgXNq2Q6k0zU8rkUVfNi6aQKS0fy8ilrxVhplSBD6izy
         +wpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712040260; x=1712645060;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o4Gt2A/YlxbVubczq49Ydic0OlMC6zIRUZ48mhZIweI=;
        b=lgVO/GFG7WOmEQYQXZ7CDd5/A5D6HlovFCP15adrYEMx3tvvfUjMtCYlUsLRY1rO/r
         ASzPoUXaN9IPo0JnY+r+OjE3o1le5OJrLBZlUNt1zyWlxSHQsFU4ntUUpyKqHoCNv2kk
         TTmuLKuXMqcux6TAFRk2hthGqQEmWW9aH0G02AqzMq225iimWlHh4MnEOVjiL+cutffP
         1ZRDY/rHMQ4AhN0O+dnNmOIiOHC6Dk5O0J2+5rueCAEPXX8xRQjueNRe5gWrUYd31qQ+
         jodN3TY3fOYuYPOQ+xQKdx4dSQttzeiNE10qhgxrrmu23DNNuj+VfWRdWRVDj806ndUw
         UrCw==
X-Forwarded-Encrypted: i=1; AJvYcCWTulXNcYii85AlcD64nqJgAv8hT6aUz1UTGj1qLKXf0rJM3ojVaRC1pM+oLgnDw+n7Acva6zF7AreueLHwSyHLuq3UqHPJQxdvecKJ1AcTPJAtJhlef+b8aUDrpIg7YrLPB8jP6J/S
X-Gm-Message-State: AOJu0Yy9tqLhdPQJI/76tbUM5X5czj3wItAHM6AtFeAmJ+20NHo+ItEC
	MuYUAaJEWyYqbiVB5UWFuUo+iFpuyJx+HSIzi5cEw56gNKo8is6X
X-Google-Smtp-Source: AGHT+IGsALuz+EYbsn3NEk9dyZFdNc4oYqbTtk6nUxsCzJEfOMWdydw5yQ9IV6Tn1FPKa+CognHTmQ==
X-Received: by 2002:a9d:625a:0:b0:6e6:d5e0:2308 with SMTP id i26-20020a9d625a000000b006e6d5e02308mr13185747otk.4.1712040259823;
        Mon, 01 Apr 2024 23:44:19 -0700 (PDT)
Received: from ?IPV6:2600:8802:3800:75a0:2378:fa3f:c6b3:24d1? ([2600:8802:3800:75a0:2378:fa3f:c6b3:24d1])
        by smtp.gmail.com with ESMTPSA id q20-20020a635054000000b005dc120fa3b2sm8756141pgl.18.2024.04.01.23.44.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Apr 2024 23:44:19 -0700 (PDT)
Message-ID: <30d1d907-4585-40e9-880d-e23a2a5e88c5@gmail.com>
Date: Mon, 1 Apr 2024 23:44:18 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 18/30] null_blk: Introduce zone_append_max_sectors
 attribute
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-19-dlemoal@kernel.org>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
In-Reply-To: <20240328004409.594888-19-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 17:43, Damien Le Moal wrote:
> Add the zone_append_max_sectors configfs attribute and module parameter
> to allow configuring the maximum number of 512B sectors of zone append
> operations. This attribute is meaningful only for zoned null block
> devices.
> 
> If not specified, the default is unchanged and the zoned device max
> append sectors limit is set to the device max sectors limit.
> If a non 0 value is used for this attribute, which is the default,
> then native support for zone append operations is enabled.
> Setting a 0 value disables native zone append operations support to
> instead use the block layer emulation.
> 
> Signed-off-by: Damien Le Moal<dlemoal@kernel.org>
> Reviewed-by: Hannes Reinecke<hare@suse.de>


Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


