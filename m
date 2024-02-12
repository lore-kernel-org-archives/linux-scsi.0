Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C61D3FE44;
	Mon, 12 Feb 2024 18:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707764297; cv=none; b=cS3IVajjrpobKKskvOn2g1kCXV0Isz0ZY38LsE2BCvrH/NZQeBVe98coVf4B5zYEzac8vYRLeeSZVGRtAAqVhxjdUc2uzk+O9BoHtCGDZA1A814hqxShduzf4Hg55f0WBSQEZs1JmrcSxQdbfukbT4Bc8h3GKAm/oh5WAx7NRAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707764297; c=relaxed/simple;
	bh=oBORXUPQB4yrjvrk+2g91gv98knQnBzlsSlJv9Oz4Vo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BAuGJY2N4weLCfXvdU1Y+vdKWYWNiubotGOqigL8BzMS+MXQu9chh6bn16Rt6qdNCzc441ix/V7D91HRqgfEdrdx0zxKzSQD+PRNVQTgqxaUSmJRHWAhe34yHS165x80wLLxhkVx8AHtdMAYy1h5pnedAQMQJu5bPGo4KuISnzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-5d81b08d6f2so2726855a12.0;
        Mon, 12 Feb 2024 10:58:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707764296; x=1708369096;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FMiKDshhm4Ns7d1XVPONNwU0zO4lYi41plmErazUVpQ=;
        b=Dx/BQFcmBQzOf2NDZBr3CsSfoAA6xAR+yZgM6pbdgliYt6M/yhC83c+LVGX7TEVcXC
         SfdIA1lY+nNYZaIx6//ZFq+NKPEhNKtnEaj/1NVRBKZe2VjXnctMuHy4UTxrpVFPUYAM
         YC/E9SmqEVueysUcuVY4wzKYC+FXud0qP7CaGIgVKtToCKujWLl7QC3Zi/psrT9vxN23
         dRqtAP+pewT8Ftkf5C7oCJ9tnG7ZdmsESAK7ZMJ3rBurBegvHsnaShNZs6QeKUGSmMbn
         P0+zQsiO6s2HacLwfu+FkhkoxrUY47Ocaf7OvUn2yXrqkoU6mAxVypK7qeDAEc8nLvNw
         h9Rg==
X-Forwarded-Encrypted: i=1; AJvYcCXLOMh2Z7PTgGcSu7dMlXNYlnp6EhagvoU+9vsu2hDTlSsShJuQi1Dj8JlzsmeSbWq+fNgUajAYPqeifDYyeAEqve3s7sw8QShFwV2LwRy2y9qBYp7ma1Rc0AvZXgNQI1tYnjYAjI2m
X-Gm-Message-State: AOJu0YwaoZOZTkLtiQUFvaUPZX/Sh2HkUbH2NoDB2tGpHsu3QWPySO0b
	QD/dmuPfLVWQCKpNwrw58X6c8zcl5Thb8bWKvam5O25CU8+Il6WC
X-Google-Smtp-Source: AGHT+IHj+V0InCmmwC3gd1/7mIX2MORi4sT6njdKxQe6B6o4ScdwOLvKUrib+HycVmyBoj444q5hDA==
X-Received: by 2002:a05:6a21:3993:b0:19e:c777:5c60 with SMTP id ad19-20020a056a21399300b0019ec7775c60mr9251719pzc.21.1707764295685;
        Mon, 12 Feb 2024 10:58:15 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXAbMmvukj5Tps4Q/3BK2orBYiT9Qa5/0zMcijZHtkn56W+UhN/UKDUyFsdydY7rqbpdoV3APLzkDMBSQUx3x3IQWVH/RV5gmPctO/49tu+GNh4RX8HigfH6t7juTfPe8+51qendpWMZ99sR1AobSi4ty8hhJ37DCcdIWzWEYY1AuKuA26W1Xa3Kr63oKpdzFcWz9Zd2IVGXgQupRs1usOCc+MC8TKIYDiVPAI9NRu/pkznJFL+svGcbCuhkzWsKBtBSDhWZoBHNWF309UNh4zk
Received: from ?IPV6:2620:0:1000:8411:dfc4:6edd:16dd:210a? ([2620:0:1000:8411:dfc4:6edd:16dd:210a])
        by smtp.gmail.com with ESMTPSA id u18-20020a62d452000000b006da1d9f4adcsm6122771pfl.127.2024.02.12.10.58.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Feb 2024 10:58:15 -0800 (PST)
Message-ID: <25d2f9b4-113d-4967-bbdb-24cb6ca62c2b@acm.org>
Date: Mon, 12 Feb 2024 10:58:14 -0800
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
 <2e246189-a450-4061-b94c-73637859d073@acm.org>
 <75240a9d-1862-4d09-9721-fd5463c5d4e5@kernel.org>
 <e2a1a020-39e3-4b02-a841-3d53bd854106@acm.org>
 <c03735f3-c036-4f78-ac0b-8f394e947d86@kernel.org>
 <a1531631-dce4-49a6-a589-76fa86e88aeb@acm.org>
 <028b77ed-d6a9-44e6-a603-3558914381a1@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <028b77ed-d6a9-44e6-a603-3558914381a1@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/11/24 17:09, Damien Le Moal wrote:
> On 2/11/24 12:40, Bart Van Assche wrote:
>> For the use cases I'm interested in a hash table implementation that supports
>> RCU-lookups probably will work better than an xarray. I think that the hash
>> table implementation in <linux/hashtable.h> supports RCU for lookups, insertion
>> and removal.
> 
> It does, but the API for it is not the easiest, and I do not see how that could
> be faster than an xarray, especially as the number of zones grows with high
> capacity devices (read: potentially more collisions which will slow zone plug
> lookups).

 From the xarray documentation: "The XArray implementation is efficient when the
indices used are densely clustered". I think we are dealing with a sparse array
and hence that an xarray may not be the best suited data structure. How about
using a hash table and making the hash table larger if the number of open zones
equals the hash table size? That is possible as follows:
* Instead of using DEFINE_HASHTABLE() or DECLARE_HASHTABLE(), allocate the hash
   table dynamically and use the  struct hlist_head __rcu * data type.
* Use rcu_assign_pointer() to modify that pointer and kfree_rcu() to free old
   versions of the hash table.
* Use rcu_dereference_protected() for hash table lookups.

For an example, see also the output of the following command:
$ git grep -nHw state_bydst

Thanks,

Bart.
