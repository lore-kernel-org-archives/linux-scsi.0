Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6F841C86;
	Thu,  6 Jun 2024 05:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717650107; cv=none; b=rp5zF5dcepT+GNxFVp0r+zoAz2eO6lE3BgL8Lp7BL4BuLslpoiutDrD82VxbMNO3SKY7P3qPBIcb6FUKPoxQ6VhUdexen4Ulmk1bJoEXuxJ8n0GL7vr7zP7yJYZ3Ce0xeCxz0lSAXk0Q2qN/Zoh3m7JjnejscBmCklCvB6VGf50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717650107; c=relaxed/simple;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CMZTkv4QYznZrpOeFn66RO6matHFvu1hp0xSHV1JB0SrIQk9fk2xEC3JUd4I1FN+fn5Qu0Mv8S8e9DMoUaEm5eMeQIkVEbU5hOQ0XTblcqcX4QDFsf3/7brO/zczfNbVACAswAIkqgCEzBWTqIL4B8ndCZW/rtaNUnXECA2ULPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GGQ70kMy; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GGQ70kMy"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-24c0dbd2866so288636fac.0;
        Wed, 05 Jun 2024 22:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717650105; x=1718254905; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
        b=GGQ70kMyOaf3qVVHW5pfE4C71CC2vsNRsos/HhlSxlff6OruKXqfLttMWDS9AmgvIC
         haVcSbD12yXB8LUcP+e99oc+ZsaFWW53v89bIvejSDOPa0T4KgOtGPLhm5oCoyfbLkbC
         i1+Nfrwg1a61eOyekm3mAAYlf3i+PXWKIZTGE1oMEZkosF/Ekr/G7tEyrdR283xRPJhk
         nBluX6eykwKocxe7wSexYbF1d6B1p2aFQDaYhOdRPvdbWFtVPYVvz/3tWyC/wL9Q01rT
         Mmi1JflWyXYVpJMUhv1taFL+phIwVN1GbVqT4bPPrCOxpKwC4d4/3ZkQJpb6nGgr9sCP
         kiww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717650105; x=1718254905;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
        b=iBL6KMhONbRj+XqGUPtyKYuKBQ7E56eK7UBYlJ+8Yj6LFy0OjQMDqWe6u3SZIgxy/y
         qjzxHLsmemAyjAp7OfdQ1IfkKZ48qet/YeS4bikuC5CxZP1UOZuXqaWu6hYudhNQ+KA0
         +EdCGR6ZfsFWjrhB+3VLKdYGGBZ8DTnpq4URnUnRqokCTQdWf4GxrRWH/IevEzH846c4
         RcLgOrrDJo7qTaztzM/XCcOnPYt3MohJ/ub6QeoeRyM10176luqMT1m2UvFpLVae3WNi
         mKv0uc5HfVSeWG1y7pgfPYMY0yRBz5zNweNx5HuckeHU0qQJMx0dgUcfraqrLsIi8Xed
         p4dg==
X-Forwarded-Encrypted: i=1; AJvYcCWk5Mh8DvagESfQr5C0F97pcoWiDkfwfOMeNq2Zr7gXXJEpTp6iyh4Sgr30Th6xQll8Gjr9RcQ29H2dWvD6mDc0FUbF2SIYk2ssluRWFzNEOfVUkba3AVBNzzLLJ/CIJJHAqYvcYY7fsM0e9nN9rB6QIK2qsRZQuSm7pUWzogROIPPXCA==
X-Gm-Message-State: AOJu0YzD+WFszlbln0vHoFQyGKkIphcwnViMrWLAyk4uhDBES3hzW2Fa
	ofgMmMyQM0tUFDrsk6gFDkjTcwUYyFlqiSnPLvbEa+t8nip4zWecErXp4xHWdFJ78XZtn+/vH2W
	48W/Q0Sk8uqXqbm2aE7ljiz+ISndCQgOLsZk=
X-Google-Smtp-Source: AGHT+IG959oSX54MQq8GKfVWKo3o05hRklNZiBoCzbvR+OQgV8iL3zKUSZnj1CdwY90/HxmBqEYVn80Ozx7+RJmP7Ig=
X-Received: by 2002:a05:6870:970d:b0:24e:896f:6a25 with SMTP id
 586e51a60fabf-251220b9deemr5280914fac.58.1717650104968; Wed, 05 Jun 2024
 22:01:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240605063031.3286655-1-hch@lst.de> <20240605063031.3286655-3-hch@lst.de>
In-Reply-To: <20240605063031.3286655-3-hch@lst.de>
From: Kanchan Joshi <joshiiitr@gmail.com>
Date: Thu, 6 Jun 2024 05:01:18 +0530
Message-ID: <CA+1E3rLUA_hnGsXF7p14Hap9jKk1hHDTicYuHMque10QV3GEDQ@mail.gmail.com>
Subject: Re: [PATCH 02/12] block: remove the unused BIP_{CTRL,DISK}_NOCHECK flags
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>, 
	Yu Kuai <yukuai3@huawei.com>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Keith Busch <kbusch@kernel.org>, 
	Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>, linux-block@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
