Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB9D1BBBCF;
	Sat,  4 Jan 2025 22:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736028723; cv=none; b=uUe2Oa5B3Q/eGwubiaFdv+2+0BJBbtJTlgPP4JfjtLkwTwFqXWfMcvqshCaqXzQttkxQvn3q4ZSJCbpJKf6lshLLO1+YlVst7JL3dhwaB39Cj6EAFMLOi64P6ulhdLklkchlBE4oLTbz+XZ+TkaOZyzkiWfW+1RDM7EUh1DuEa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736028723; c=relaxed/simple;
	bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pNV5BeLQaSXuSP6sy49dThG+jhhvj/KhMYVxKt2NIMee5ghyyR/Qxrg0WR1fzx4fb7qyDg6j96t9cJjWsdcvqIy7KfalbgGUUHitkaa2LrxEj4haDXN1lq630U3qZNkDbstehBgkmpn8gbWqJvVqGcd8bx7AMEEfPK7VhaGrtag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43690d4605dso54500825e9.0;
        Sat, 04 Jan 2025 14:12:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736028718; x=1736633518;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=w4MBXhZmRK/qWu33tZv7j6QBE38dwyi8uMqMq7qUfZrldm9ybD7ox9QaYJSPN8bBOc
         pi+HUmV+v/bh20o+HHBPuckSaT1BA/eYrmxAr4Nrq4s4gIgRUrqnw2sZ216J+CKl/krD
         lEzSYRxSiAKC+AeE9B2EulPms52dj6PVmDoL34uZFCaKfXT/JeDBco6R4/rXypKLljli
         uUkycyJOnnTw1i08uA06bUFk2mIsAmhnu+KMmpiar/RBtz2fPQUipjTQVCG5rhPG8u/u
         AONrnLm5jPAEdW1XzaiJpj5WQEjFo56tMxY2PRoM6/jkuRdfn05ha73SzSprDabk0QUJ
         IFRg==
X-Forwarded-Encrypted: i=1; AJvYcCUd3JRsEE4vH5JDeTJCiqvVahG060WZYv4lIFZjtXjPe9lmPHQSnvNdG/LOH1aM8wgSOsfHK4QNhtCZ@vger.kernel.org, AJvYcCUiCh4Xp43kdLYNpeC2t2cxtjnD/ZpN6UGeNKmHQhvhKrrniO7xzR7SWG1KXeB/eY23SEJNONz4O+v06Hmq@vger.kernel.org
X-Gm-Message-State: AOJu0YwBkYN/ucQgez3jMOMTjN4lzb/YlLq0qia+Jwepo0yTCJ6Htr8p
	TIJtATag0wwPgxfYOs4wAlPbUjagRSABrLP0ZJib/FyewXSGk9gv0fdPew==
X-Gm-Gg: ASbGnctbCEI55hwFncSL5ZLCSZIaME/qXxNAmMC4tBXLkPmPf+DhOh9+aHvAlpCKiNI
	p3LNCDI4B/JwEQIOHaNzWu4z1fSri3Y0bwVfxBYyAa7Lc+HW7tcYmyPPLTgsDAFOPU6cjVKixrG
	Faeya8LjAA14wTCNnZa4NYESLUL47oob6koOU2GLyFxaYrWw8aBso2puA1C5OacGoEr/MNxLvLU
	PKlRXoofdo+0dAvkpvwarH3aN0Kiw1lGyPeGz8XWHRgnt2a66nWx9FtYgk9xWkvP2jDf37/utBt
	nKhXK+Tt3TwS7fExvMMrt1Y=
X-Google-Smtp-Source: AGHT+IF+/O2w0tlV5xbiNSRXYkEgK4eJ6bNgAlswjUBk8c0kHkeMrsSP7nExVbh6SG1aQluYjVQE6A==
X-Received: by 2002:a05:600c:5488:b0:436:5165:f21f with SMTP id 5b1f17b1804b1-43668b498ddmr417778835e9.26.1736028718410;
        Sat, 04 Jan 2025 14:11:58 -0800 (PST)
Received: from [10.100.102.74] (CBL217-132-142-53.bb.netvision.net.il. [217.132.142.53])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43656b417afsm562520085e9.36.2025.01.04.14.11.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Jan 2025 14:11:57 -0800 (PST)
Message-ID: <38bf7ad2-cdc8-4ece-8e8a-03e1c3863c3b@grimberg.me>
Date: Sun, 5 Jan 2025 00:11:56 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] block: remove blk_rq_bio_prep
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20250103073417.459715-1-hch@lst.de>
 <20250103073417.459715-3-hch@lst.de>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20250103073417.459715-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
