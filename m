Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4BF768FE;
	Thu, 21 Dec 2023 20:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1d307cf18fdso8663535ad.3;
        Thu, 21 Dec 2023 12:33:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703190790; x=1703795590;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/7KbnN33cEMU1ra8cl0k5N0j8jcZeZqi4GJ0MVOhJUc=;
        b=kGYxG1o2byY4AyIkpBkmSt/GS2tsrxOYktk0pke3Ra4MCB+fMF+efX4UjQxtVwjRG0
         JYAgs2G46X9PiV8F4PhYfN+Tn5ksi3gRx7/IpbIouyceIYMmvJ7a+w1/7OARN8PAATKp
         0BaFOpgmF2xU+05ynmVFJjRO+WaX+zPr/wshLPfu7/Fplu8Fh9OBs+jT9pnTjsn0Qpby
         0ynzOqKic6xkImwyI9aChTvmdv0m0i7C36r+6zhvnOwVwWWNrHgz7v6O0gXVIjjHgtrW
         NFMeCm77sugeF0fvjR/XLN9dKvmdCIKOc9UY4YTavAmiWO9KxQPKy9/FADQE5dd2h9bk
         LLkg==
X-Gm-Message-State: AOJu0YwzzH3M2G46gIFRjSsDZgn0eqPQYvc6yDmBL2XZeby3mM/DRNTi
	mWvFcrPC3pt/79Z2kaTTHWFjo66GV6s=
X-Google-Smtp-Source: AGHT+IEuLC9+wqhPPyf5+htFMuDuga2BsWAd+xWyMzex6dtSWq5jWA+ph6hyRpScpzzQ0l6JSfYajw==
X-Received: by 2002:a17:902:ecce:b0:1d2:e521:dd72 with SMTP id a14-20020a170902ecce00b001d2e521dd72mr230098plh.109.1703190790351;
        Thu, 21 Dec 2023 12:33:10 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:d9ff:baa2:bd58:437a? ([2620:0:1000:8411:d9ff:baa2:bd58:437a])
        by smtp.gmail.com with ESMTPSA id z3-20020a170903018300b001cfa718039bsm2045190plg.216.2023.12.21.12.33.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Dec 2023 12:33:09 -0800 (PST)
Message-ID: <5c356222-fe9e-41b0-b7fe-218fbcde4573@acm.org>
Date: Thu, 21 Dec 2023 12:33:08 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Large block for I/O
Content-Language: en-US
To: Hannes Reinecke <hare@suse.de>, lsf-pc@lists.linuxfoundation.org
Cc: linux-mm@kvack.org, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
References: <7970ad75-ca6a-34b9-43ea-c6f67fe6eae6@iogearbox.net>
 <4343d07b-b1b2-d43b-c201-a48e89145e5c@iogearbox.net>
 <03ebbc5f-2ff5-4f3c-8c5b-544413c55257@suse.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <03ebbc5f-2ff5-4f3c-8c5b-544413c55257@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/20/23 07:03, Hannes Reinecke wrote:
> I would like to discuss
> 
> Large blocks for I/O
> 
> Since the presentation last year there has been quite some developments
> and improvements in some areas, but at the same time a lack of progress
> in other areas.
> In this presentation/discussion I would like to highlight the current
> state of affairs, existing pain points, and future directions of development.
> It might be an idea to co-locate it with the MM folks as we do have
> quite some overlap with page-cache improvements and hugepage handling.

Hi Hannes,

I'm interested in this topic. But I'm wondering whether the disadvantages of
large blocks will be covered? Some NAND storage vendors are less than
enthusiast about increasing the logical block size beyond 4 KiB because it
increases the size of many writes to the device and hence increases write
amplification.

Thanks,

Bart.

