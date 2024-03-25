Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC9383A08;
	Mon, 25 Mar 2024 22:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711405666; cv=none; b=PonZqSLVAGp70jf0lkxe4Nwo7ugopTZVS1XXpbE1yUvyaptv+LVAJiE4FDQ2n/PovML5YLNg9tSrJvisWa1jHczvUe218qOAdvTvi8ek8r8l9vBnS8+43RU0c4vaKEpJzbFUQpDjHEcT7CCNrqh+mRc7V6ZSrd5uO8cCBTrKQhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711405666; c=relaxed/simple;
	bh=k380Di9PPn4HrfhXJaKlNHKgzfcSKY8nBgbOVUGHviE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KZy4wGgGcORoQLB/RRfvxFo7ZHiCldxGdhnDyz5/Lu6q0/8+QgR4wuR5TLuGvZXkn6KGX1sd6SRE48YNw0YPs5RUgMW9mq5vL/cW/jffOlo4SfQfXtHOSp/EYc7uRFVAj1QD40qInAavcNd07yzSxonjlUaF9PUkr2XcuLOPTjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1dde26f7e1dso35823035ad.1;
        Mon, 25 Mar 2024 15:27:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711405665; x=1712010465;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uzMzCvhZ2DsLlicFbodpkHWs9sqgYoFg0qVaOmdiFnk=;
        b=oWjK2g76yTVNrMX1k1TuBjSpdHsaKKT1sVWokUBeU2chxqZeRJzA8QhWS+kMQR4q5L
         M30uVtXJxUBExQb0l4cEif6Y72Q1E1YieAswGOfbX8CyodB4pwL1pnqXtxIHIHSPmJVV
         NmU/FXtE5EZQfHCyNpObM4UzFKxfGe/o0jTiC9xRJcW32xb4j1QATuaxBEVaUkqCJshb
         nTrhVVmUS+2jOpM0lVPhYxpNBORlmzoiue6qrKQN3Byql/mXKLN55hVYL45EJ/FM1omH
         1QXLK8vweDYsDqvDBBdjLKEM28XZWkpqSw9/M9l4aiCVw6yXh67lcr0jAmZoHi6TXfet
         iYXg==
X-Forwarded-Encrypted: i=1; AJvYcCVv3QdcIOCF7m7eQlufoUKKDjQaWnwT+dyErM4YuTpzQZrG/NWW3vZgnQxz7KlEW5mYUNWP1dPCbidwr/XYmlEHiZHcrzAwlBm+26DV3Lso5wcZNGK9OMtaxa4Z4FR4RGZ0pzX+zQkc
X-Gm-Message-State: AOJu0YwzrAGN5eDUetzNx9C7CPXEjsJ4dyjfXpV0BAOk3l3qikselMOT
	Yy+t13ka4q+k3AW79L9fhFqaTiVTxfV6ycbgUtpBAgUBA+5knBp5
X-Google-Smtp-Source: AGHT+IG9EL2LYfr+5S1VK0pzV73lq96IFxyx1IqFKpBI9Wig5gzPZQK/aPza9vwmuPuSmTHUppIalA==
X-Received: by 2002:a17:902:e849:b0:1e0:b60e:1a08 with SMTP id t9-20020a170902e84900b001e0b60e1a08mr5343333plg.40.1711405664622;
        Mon, 25 Mar 2024 15:27:44 -0700 (PDT)
Received: from ?IPV6:2620:0:1000:8411:262:e41e:a4dd:81c6? ([2620:0:1000:8411:262:e41e:a4dd:81c6])
        by smtp.gmail.com with ESMTPSA id c2-20020a170903234200b001dd876b46e0sm5261746plh.20.2024.03.25.15.27.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Mar 2024 15:27:44 -0700 (PDT)
Message-ID: <0f3b82c6-2579-46be-b709-4a4ec7daf9c8@acm.org>
Date: Mon, 25 Mar 2024 15:27:42 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 26/28] block: Remove zone write locking
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-27-dlemoal@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240325044452.3125418-27-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/24/24 21:44, Damien Le Moal wrote:
> Zone write locking is now unused and replaced with zone write plugging.
> Remove all code that was implementing zone write locking, that is, the
> various helper functions controlling request zone write locking and
> the gendisk attached zone bitmaps.
> 
> The "zone_wlock" mq-debugfs entry that was listing zones that are
> write-locked is replaced with the zone_wplugs entry which lists
> the zones that currently have a write plug allocated. The information
> provided is: the zone number, the zone write plug flags, the zone write
> plug write pointer offset and the number of BIOs currently waiting for
> execution in the zone write plug BIO list.

Shouldn't this patch be split - one patch that adds the new debugfs
entry and a second patch that removes the code that is no longer used?

> +	rcu_read_lock();
> +	for (i = 0; i < disk_zone_wplugs_hash_size(disk); i++) {
> +		hlist_for_each_entry_rcu(zwplug,
> +					 &disk->zone_wplugs_hash[i], node) {
> +			spin_lock_irqsave(&zwplug->lock, flags);
> +			seq_printf(m, "%u 0x%x %u %u %u\n",
> +				   zwplug->zone_no,
> +				   zwplug->flags,
> +				   atomic_read(&zwplug->ref),
> +				   zwplug->wp_offset,
> +				   bio_list_size(&zwplug->bio_list));
> +			spin_unlock_irqrestore(&zwplug->lock, flags);
> +		}
> +	}
> +	rcu_read_unlock();

Can calling seq_printf() with interrupts disabled cause interrupt
latency issues? Has it been considered to collect the information that
will be printed with interrupts disabled and to re-enable interrupts
before seq_printf() is called?

Thanks,

Bart.
