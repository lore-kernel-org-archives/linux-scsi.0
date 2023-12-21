Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE51576918;
	Thu, 21 Dec 2023 21:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-5cd68a0de49so903726a12.2;
        Thu, 21 Dec 2023 13:00:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703192450; x=1703797250;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=83E5t9dvCQdMsdpEN4iZfGFzunUB9ar9iR0gwlKCl6s=;
        b=pbyiIzMypj5C5D84PYIgTS/4/RQNycXF1BBoPqv7wm+X1le27Sn3abblEVAxuXJd7b
         thDX0HK2iU2lLXj1MRJMpcwkyxbgbJ0FVKY4jQC83IuKmWAirwr0fq+s9prQ+AdnxMmi
         r7NhjYU6W9Fy1bSDbKYAy08N+DEt20HI+AVaPxZQYKlvtZO1gPr07XReOFO9mwhIOrvB
         s7u5C6cY/LhmaTn0R1V6ELUPnj0HQTwKz2wdbpQ6CRxZot0UODvhMMMg/Mnl4g5U9Y1B
         l5hxliCBcryrhTYqgh9WG1gvGBh1flS8p3mslgd6OYrrn0gMUa4fr6Iglhalw3aROxAE
         brVg==
X-Gm-Message-State: AOJu0YySCEx5Bt1QZF+eKY4VOP7ehROZOyqwNKiWadwUj+lvqPzqri8a
	GVIds8ZUG0g+01KCtjXzu5uo72lDt64=
X-Google-Smtp-Source: AGHT+IF6Vyr0+ziV5cTfXGCs1VR1owc+gfKItvvVoK6ZO695dJGMuR7qbeQcDNpP33NW80EtO6hkjw==
X-Received: by 2002:a17:90a:de05:b0:286:6cc0:cabd with SMTP id m5-20020a17090ade0500b002866cc0cabdmr351341pjv.52.1703192449904;
        Thu, 21 Dec 2023 13:00:49 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:d9ff:baa2:bd58:437a? ([2620:0:1000:8411:d9ff:baa2:bd58:437a])
        by smtp.gmail.com with ESMTPSA id j15-20020a17090a840f00b0028bad9b220fsm2196949pjn.37.2023.12.21.13.00.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Dec 2023 13:00:48 -0800 (PST)
Message-ID: <8db6e3f4-c830-49e2-98c6-530c515eaad3@acm.org>
Date: Thu, 21 Dec 2023 13:00:47 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Large block for I/O
Content-Language: en-US
To: Matthew Wilcox <willy@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>, lsf-pc@lists.linuxfoundation.org,
 linux-mm@kvack.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
References: <7970ad75-ca6a-34b9-43ea-c6f67fe6eae6@iogearbox.net>
 <4343d07b-b1b2-d43b-c201-a48e89145e5c@iogearbox.net>
 <03ebbc5f-2ff5-4f3c-8c5b-544413c55257@suse.de>
 <5c356222-fe9e-41b0-b7fe-218fbcde4573@acm.org>
 <ZYSjJdF1wyqeCFhU@casper.infradead.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ZYSjJdF1wyqeCFhU@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/21/23 12:42, Matthew Wilcox wrote:
> So if you want to talk about the downsides, show up and talk about them.

If I receive an invitation for the LSF/MM/BPF summit I will show up :-)

Bart.
