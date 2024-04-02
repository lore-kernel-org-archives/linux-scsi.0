Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2549C2BCE8;
	Tue,  2 Apr 2024 06:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712040195; cv=none; b=G0P8hD/gEhGN5CNYRb11h2fQ+R+WyieufsSWPVtEo1ha4X9bIhR2Gf2WJgpJ/Jw53xJpWaCb3etjVUegFRg6Iq4skWqo5JW+4LT5QTjsnci+h+Nb8z2LNsJOS4DsoEOCYQrwTSyFFE8fKRB7Z/6WEVFbbRd1FAD2Cs5E7PlmfMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712040195; c=relaxed/simple;
	bh=AaQc2ub9VM0LXeNFqMO+DpfwjU7/Sm5uTdBo3sy2WlM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=C13HVzWfAIfBsHjdNtKGQLZs17S35j3URy9pvQCN19cr//7sk+zdS3E5JKbVd6s6Ha8gOIDMtHi4AYtrGJpNb6Ls63ahZM2bVbN5cUUiCUt8EVsEl7xLE44P6hHiYdB23joKNGOhUIVBm0EGrqPJhQSpXr6/yuM3LJCuBkx85x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jve2q/zG; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jve2q/zG"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1e24985beadso13715025ad.1;
        Mon, 01 Apr 2024 23:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712040193; x=1712644993; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5ZpDpHuvqRkPr674LQuVEJQ8beI/LgLV+GDkIcfhzig=;
        b=Jve2q/zG33bVTV3THhmLOCl7h6p4/ca2jg9dQKwyLEOafVrJQzUrsag+M9BSr0CP8t
         Wa5HWc+OocViXJXXRldNDl/2J3WKsn8CM7mlgpFWs9tCqBNe+17JXkOa3GuIAIV8E++d
         K7I+sccJMU66joWGdeB9COqzORjQFTxg036HSAGYjUSe4JoOSTjTZ0nj0Jae4gnJ7kw9
         mtiMXaCRNkO3Y5i139l4G+i5wSi3SZXpZl9vwekt9K4xuR31QT7djnKgIyUji4CVyx0M
         SCAA6fK/51M+FeB3mk58rdAQN9dlA9701vXSkJTigl/KW06aTVNbxwkvJSjY0yT0QRxQ
         7PZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712040193; x=1712644993;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5ZpDpHuvqRkPr674LQuVEJQ8beI/LgLV+GDkIcfhzig=;
        b=dtamwCWm1eLKCeOFENMk+mqlj9zvjVeYr++QrwUIUj3LS7L4yZK7Ssrtz/1+Un0OEg
         u7GXIdhxkMbKmUqrUcPHMJcot14wujgKdUVHp2TozUPnxQiCSDnlO7pBsNQotcPUwpDo
         ur+0KE8q9WLecJB01HcSKtdtwz887ZyMdzkvkRktNd+SQDKFTP70TBvCJYP9rRnRozEP
         AMS4+UbUSeOc3iwkHPKhvL3Z9KNm/ojtCxbe/4Isd1BkqHYeRqRpXMlzckdOJfUycLDe
         ocFfw2sV0XETPscm1YujdYSq3QolTl/cjJQNC2gUSqVDYioer1+jQXn7SzNRCia/UOfF
         QQaw==
X-Forwarded-Encrypted: i=1; AJvYcCUg79Fl+c7xzTwmas13KfjmYkZUfFrOvNOl62xqajk8CSpKe73XUIhU4Ti5CJBYXEZJnA/JFCuHEAqJItNiKMOK93Oyi4cSMlDYHaPE9tcoHm65c8WrwXTVDWkDtC7GanYMgSRP5EQJ
X-Gm-Message-State: AOJu0YwZ4hhVnDKwfOHZfX7ALxRWb5/fDEVhJoMBvCj8hkFyZqZkTyPr
	JucTKa0sxrdeu3v4IhikzlUJl92/j3Wm1BlufcNLyWRJy35XkXAP4TXTY74j
X-Google-Smtp-Source: AGHT+IEM/srVZSPtUycGFnEMMDCOvK5W9K0Azw0ckKfS6iodyT0ENHw+o3pbopHF/L9b6DtyRXWrOA==
X-Received: by 2002:a17:903:1c4:b0:1dc:b64:13cd with SMTP id e4-20020a17090301c400b001dc0b6413cdmr18643219plh.27.1712040193389;
        Mon, 01 Apr 2024 23:43:13 -0700 (PDT)
Received: from ?IPV6:2600:8802:3800:75a0:2378:fa3f:c6b3:24d1? ([2600:8802:3800:75a0:2378:fa3f:c6b3:24d1])
        by smtp.gmail.com with ESMTPSA id q11-20020a170902bd8b00b001e0c91d448fsm10141148pls.112.2024.04.01.23.43.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Apr 2024 23:43:13 -0700 (PDT)
Message-ID: <a4791bc1-f523-42fe-a00d-2cc92b35670c@gmail.com>
Date: Mon, 1 Apr 2024 23:43:11 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/30] null_blk: Do not request
 ELEVATOR_F_ZBD_SEQ_WRITE elevator feature
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-18-dlemoal@kernel.org>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
In-Reply-To: <20240328004409.594888-18-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 17:43, Damien Le Moal wrote:
> With zone write plugging enabled at the block layer level, any zone
> device can only ever see at most a single write operation per zone.
> There is thus no need to request a block scheduler with strick per-zone
> sequential write ordering control through the ELEVATOR_F_ZBD_SEQ_WRITE
> feature. Removing this allows using a zoned null_blk device with any
> scheduler, including "none".
> 
> Signed-off-by: Damien Le Moal<dlemoal@kernel.org>
> Reviewed-by: Hannes Reinecke<hare@suse.de>


Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


