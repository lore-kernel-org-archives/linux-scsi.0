Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755351C280;
	Wed,  3 Apr 2024 03:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712116603; cv=none; b=WOlPEVkUSH1MmX97FOsuC8AN/T3uDZeIFDY2tsOMk//+mY4AzRKfyEpUPm0V8ni9/8zY5NPL4mnubusw6i7JNesc2KkZRh09c1wWNKhNhaZFtNCAkDLs/XDP+WWxnfbppiNR/qXaGuF22ChjlAy5VWnE6jljJ9d8dONibvhdSos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712116603; c=relaxed/simple;
	bh=YYCPVBA3375GF5Ph5qAHEvIAw0hfx7yA1qo6ZRkPtrM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=gWbmP6rzSpIsqKS+4xsUjB/18zi75zSlbiJHfLzfyk8uYMPjpmXokycYCjpNQ24Zb6RqEfQUma7Sr33tM8K13JEtfaQ4muS9jjRS30Up5JL+GhPipOntmLZJw71zekXH1/B5+ak8jrFnnbo2CM5vN1YQQ4Z+zZkMIPZvaqXRhdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pg/lxft2; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pg/lxft2"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-5e4613f2b56so4313245a12.1;
        Tue, 02 Apr 2024 20:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712116601; x=1712721401; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:cc:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fugzhJcIxXGAO0ssTnR0bYZbKaxEwSQa+2J5+v83xpo=;
        b=Pg/lxft2SE4VQOVfWwAujBP9fUHZSc3I4lGUOGZ2724giISNejJ8NoGsU4qDb4h3Wd
         1L+kLXQ4M9uvg026+Fe8TuA9C6kEZfYg5Txgzk4urh7AKY5Ay9jhJ1/tdLnWEjZWX1W0
         Gqt1VCRJ9WBTSOzubTNSMSOkZr9+oVEnsSPLx2+w+LaUEOhf/6zz4Z0zc7VxHfU3jZZ9
         25bLBdUv/SRbScFKgGepacfD10qhRr+PB4ce2YfttwXOPu3PNxSolXmiWNC9VVx/cvWC
         aiUzB0RqkEpzs6AY3XdvjPtoM6NyP2yb/DB6adITFwt0P1VNhYkET80SPpAdmxFWBQsT
         kdBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712116601; x=1712721401;
        h=content-transfer-encoding:in-reply-to:cc:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fugzhJcIxXGAO0ssTnR0bYZbKaxEwSQa+2J5+v83xpo=;
        b=G/fjPNRKFttz8eTzCDDMJqx1HZQX8umRB2no/puTMx3649TnzKBEt6x1YFR1OrgtVg
         sUATc8mFx82rEKu3vPh6E5MYzWA747Yb/hy2thbZbBNVt/kU/9UgHt7nYfRy3AwNwlEl
         Qmd4JzdkooT7mVXeR/vQ2hFpLmpe596Y8kh8MIsdD6FNWgb9NKGZjU+ohlGwGw7r34Lj
         KHj9vxidvuMqbUyrQZnLmwzJiHID0eevll7U0lpAonZ3pRlpSTTCsWf/BeKUPvzO4yM3
         hao2HlU1D4Px+Sy3dOicOOO6xA9qqbvMwBGRhDAU7X/iMC0SbYw6THmLR5/Xyatj2833
         I/ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwV4iGrVJEtvNNFLqOymabOBma0XtQyq+rrw1W8OuQ7DF3IFK8KcMAd3W9EfFx766kcRGjjIhvSRiq0+Bf52dL+Zxiq5gKqKzLEQ==
X-Gm-Message-State: AOJu0Yy+nNVdiIRpzhXPLns6TlQNZHYrnyLhz8a9cRg4FC2Wjq9qN2hM
	SugDzhLlkRNjDPora5MFTgZjIgQ0/bdJIQJDKS5Pge1dOIzkwUgz
X-Google-Smtp-Source: AGHT+IHfoJxdwg1KatKMqIm6Uh/xcA1bx9qJJajW01kM2Vir6+vvULrmKk55dbcD4GRCoM8/BWI30w==
X-Received: by 2002:a05:6a21:6d8e:b0:1a5:6c73:74b9 with SMTP id wl14-20020a056a216d8e00b001a56c7374b9mr14589743pzb.48.1712116601569;
        Tue, 02 Apr 2024 20:56:41 -0700 (PDT)
Received: from ?IPV6:2600:8802:3800:75a0:159f:e332:af97:bfba? ([2600:8802:3800:75a0:159f:e332:af97:bfba])
        by smtp.gmail.com with ESMTPSA id i13-20020a17090adc0d00b002a29160df67sm531650pjv.27.2024.04.02.20.56.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Apr 2024 20:56:41 -0700 (PDT)
Message-ID: <7a3be43c-39d9-472a-9593-89a1c4e03004@gmail.com>
Date: Tue, 2 Apr 2024 20:56:40 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 17/28] null_blk: Introduce fua attribute
To: Damien Le Moal <dlemoal@kernel.org>
References: <20240402123907.512027-1-dlemoal@kernel.org>
 <20240402123907.512027-18-dlemoal@kernel.org>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
In-Reply-To: <20240402123907.512027-18-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Damien,

On 4/2/24 05:38, Damien Le Moal wrote:
>   
> +static bool g_fua = true;
> +module_param_named(fua, g_fua, bool, S_IRUGO);
> +MODULE_PARM_DESC(zoned, "Enable/disable FUA support when cache_size is used. Default: true");
> +

checkpatch is generating warning on this patch, please check :-

WARNING: Symbolic permissions 'S_IRUGO' are not preferred. Consider 
using octal permissions '0444'.
#31: FILE: drivers/block/null_blk/main.c:229:
+module_param_named(fua, g_fua, bool, S_IRUGO);

Also, I noticed that for zone_append_max_sectors attribute patch
you are using 0444 but for fua you are using S_IRUGO, any specific
reason ?

-ck


