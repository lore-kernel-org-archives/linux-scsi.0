Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5879A40BF4;
	Mon,  5 Feb 2024 17:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707154101; cv=none; b=mDcHmBudNNeZXkgaaI4wW5SkF36/yNSi1AxPKbBk0/kGhL1gZ/bheJSSQkIH+w3VE+38KVYQ5caeaQI2mdUAaO9pYBBFvc9NyLsJoIM1NjBTxLldUcRJb2CfmU8t40AudzAU247zOI10Yz9k0g0uqDX50A2EcZEGiXwZIqAPBM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707154101; c=relaxed/simple;
	bh=dK9jTty3a/n9QrRTMZUnz5n67yM6a7EfZx1/O/w4oKo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d6+ZtD9T46HmcZ1Wy90zszw4ZIDamVK4Ks8E/x08UlXgbOiQtCFV9dJgYnrLd1uxWN8nHB6tcati88/y1hxyjKpkCpdeolDCVVxj4cGLfxafqSSp9r1zq6O2MJkW7ZcC1uRJXP1WW9yY4iaieJAktJz50AAfdT9uadafARZvEV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6e04eca492fso444324b3a.1;
        Mon, 05 Feb 2024 09:28:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707154099; x=1707758899;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QjTDlLbEeGu+oelqaYSRULrHfqn6Ec8MRZebJau3TpY=;
        b=R1B3umuOUgqJAyAtpV1LJdETrBD5El4a8XbTrznjZ81Wrp7UziOJpw4Tl1cUYEtvAe
         69S9pBdBfRtBQRQ4coulaDqsSHijRfi96f70sNmJHtJJnSmmNPzp25J9yFNRFk5deR4F
         OkS+GnKpnKZYhyFfHmz4nah1k1jbs42yZlEyug938VSI2ify8b86QZ2RUdqbRCOrx6IM
         98y6fkLSx2SB1UJKt1un8ra+cuyZiuaGGkMPxEDYnQpSeTD+MWlCe3skb8UfiQMeBen6
         f8pLNltcrL5AyGupbsrp2yoxFb+Y8TT9HCYX4GWl8PkG6jSG9RuRfODC8OyhJ+QapfFx
         phOg==
X-Gm-Message-State: AOJu0Yx7fZwK2u4A17CnH/BYeobw2T3VAN3CXoP38AlUP2MTvOU4zLL2
	BXJ4FYo6Xo/op9sB6J0eBS7eZq8xbI35WM6J9UH1piqqwgAhKbmf
X-Google-Smtp-Source: AGHT+IEGbnnigQCEx4bnoRaokXj2byd63v8qcsr6KkiHF5ZTtHGQ65fRilhC8f93iBKS6IjQ2Kn+IA==
X-Received: by 2002:a05:6a00:179a:b0:6db:e6b9:4ccf with SMTP id s26-20020a056a00179a00b006dbe6b94ccfmr302204pfg.5.1707154099547;
        Mon, 05 Feb 2024 09:28:19 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWuRk2VwT2NKwo1BMYgTBUC7L8V85X0dLoY0YbSLQ+vsjtcfdcTWiKmcoFqtG3UBMukLmoM6+/1qcAf5CULkl5tN8WlflkBG2dze2sjg/KDCPTvEVsc3VyxP1Aoya8zHfo7ZyQadjC/AT7FsT6b00tb90+MEOSXGfstw2CiCMaGTQAFon7dwmuGkeY/cc4sONexXwBkyI2cI8QgJ5qTg3EMjv30iaeTzQ2cyiNiKX7GDjVBz9qZen+ftsn/jIwyRLKltg==
Received: from ?IPV6:2620:0:1000:8411:be2a:6ac0:4203:7316? ([2620:0:1000:8411:be2a:6ac0:4203:7316])
        by smtp.gmail.com with ESMTPSA id c24-20020a62e818000000b006dff3ca9e26sm89724pfi.102.2024.02.05.09.28.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Feb 2024 09:28:19 -0800 (PST)
Message-ID: <f7dd57a7-1612-457e-aec0-5cf2c4d98b78@acm.org>
Date: Mon, 5 Feb 2024 09:28:17 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/26] block: Remove req_bio_endio()
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-3-dlemoal@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240202073104.2418230-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/1/24 23:30, Damien Le Moal wrote:
> @@ -916,9 +888,8 @@ bool blk_update_request(struct request *req, blk_status_t error,
>   	if (blk_crypto_rq_has_keyslot(req) && nr_bytes >= blk_rq_bytes(req))
>   		__blk_crypto_rq_put_keyslot(req);
>   
> -	if (unlikely(error && !blk_rq_is_passthrough(req) &&
> -		     !(req->rq_flags & RQF_QUIET)) &&
> -		     !test_bit(GD_DEAD, &req->q->disk->state)) {
> +	if (unlikely(error && !blk_rq_is_passthrough(req) && !quiet) &&
> +	    !test_bit(GD_DEAD, &req->q->disk->state)) {

The new indentation of !test_bit(GD_DEAD, &req->q->disk->state) looks odd to me ...

>   		blk_print_req_error(req, error);
>   		trace_block_rq_error(req, error, nr_bytes);
>   	}
> @@ -930,12 +901,37 @@ bool blk_update_request(struct request *req, blk_status_t error,
>   		struct bio *bio = req->bio;
>   		unsigned bio_bytes = min(bio->bi_iter.bi_size, nr_bytes);
>   
> -		if (bio_bytes == bio->bi_iter.bi_size)
> +		if (unlikely(error))
> +			bio->bi_status = error;
> +
> +		if (bio_bytes == bio->bi_iter.bi_size) {
>   			req->bio = bio->bi_next;

The behavior has been changed compared to the original code: the original code
only tests bio_bytes if error == 0. The new code tests bio_bytes no matter what
value the 'error' variable has. Is this behavior change intentional?

Otherwise this patch looks good to me.

Thanks,

Bart.
