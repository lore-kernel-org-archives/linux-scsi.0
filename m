Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6705E7350C;
	Mon, 25 Mar 2024 22:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404816; cv=none; b=aVGVnaHgBzYCMEmwaEoNqpigERg2oAvDFqGdTisy9qB4lB9utZJFpSWAMatUA7IYv8M1o9Vxd46gbF5I7jC+AbvKpGAE2WBSvZfuWcZ8LKEYbzoNctcL0aGejllDM7gZcqR5dlJa+2J1PIVbthjvUebAl9o3w51bnJ9YLwAGxKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404816; c=relaxed/simple;
	bh=lY9FIntr0nkvHSL2c+KUE7nnc9/NyBweIhAGiFvlGMc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eqoJYu1sbf7a3pRorJpk8Z0XYxHYYlXYVA9Y462rIhdm5EwV1LChyJlCZMdvcIZ1njVcP2buymsBuQJySN052rhSAe5LCEGV4/RH/93NLuy3u0eVhU4qL9QEJdvQTxbfoBJC3waseCusO/QrSiRi6RDlHL9nvISbuSLfh/mGwHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1dde26f7e1dso35736375ad.1;
        Mon, 25 Mar 2024 15:13:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711404815; x=1712009615;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lY9FIntr0nkvHSL2c+KUE7nnc9/NyBweIhAGiFvlGMc=;
        b=R+n9wE3OHI5rWqdyN3O34fud5nOzq0D2Wc3zZmt/QVS5qG77qhnvUksxXTpI9Z4C9q
         imfi9NIB0kLIPFtch7zQKLfX1KPMnF8iGe9ZI2GghbbMhG5qVaTC1PffURBs4YFDFDgs
         lH1zmtNe1nDVYNJ8gUWHE4zv5uztzjtOfnBMvjvuwpC1ZQvA18u5sgtvMhYxaqAyBtGo
         hiI6p0jH+Ne5NPLf0sEHC6ylszSPeDC51VNTtNmyy8IEtGlRWKOURbuB5ZYQ9/vNZlMz
         7Iair6TTYdxfsucxNOuF/zdC6x3TqpQk20vd3oXHsX3yyHHnaSDzfL89dmZ+ByXV34g+
         EmiQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZrVtRl3evs6g+Z6MMkQzh0FhdRBx0whkw0EKkPdA0qKDIjWCY7+5EeQzesRBSOaLCrYp3hHcx1qXu5+Ge1VxF8ogQUyAimnl0RJbmIbYBavU7LeDK06CWeyS3HvmVyphDWxpiaL2ogfPZWLxhccuXY28wd/SvMfrEHtkxiUbZUgSzbfu+A/nrdRqRpmwkXNnrUkan4NagSsCxnbF4A7ffN5QfhQeRqpXqEewXaKFJ5TyeRaU/ki2s90r268rRbxw=
X-Gm-Message-State: AOJu0YzaCo60s83nPCIf+Sud2QF3apmwrPfyEB42hvhCTkto+1SFYRBF
	so6+oHWyo2Dav+jbScMEvOJ+MCgW5pmRl861WcQ0qWEDOxSUdpoA
X-Google-Smtp-Source: AGHT+IFUGYd8Jam7bWvjJzPqP4kRsvvoGwSNPai1P4IrVGBzs7Jpyu8Rqw4R37V+qo7lwI2rThO4Hg==
X-Received: by 2002:a17:903:26c9:b0:1e0:27c8:5c7e with SMTP id jg9-20020a17090326c900b001e027c85c7emr7288051plb.25.1711404814659;
        Mon, 25 Mar 2024 15:13:34 -0700 (PDT)
Received: from ?IPV6:2620:0:1000:8411:262:e41e:a4dd:81c6? ([2620:0:1000:8411:262:e41e:a4dd:81c6])
        by smtp.gmail.com with ESMTPSA id v17-20020a170902d09100b001dcc18e1c10sm5273962plv.174.2024.03.25.15.13.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Mar 2024 15:13:34 -0700 (PDT)
Message-ID: <47028fba-7fb0-4eda-81a2-ccf439cfec6a@acm.org>
Date: Mon, 25 Mar 2024 15:13:29 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/23] scsi: add a dma_alignment field to the host and
 host template
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
 Takashi Sakamoto <o-takashi@sakamocchi.jp>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 "Juergen E. Fischer" <fischer@norbit.de>,
 Xiang Chen <chenxiang66@hisilicon.com>,
 HighPoint Linux Team <linux@highpoint-tech.com>,
 Tyrel Datwyler <tyreld@linux.ibm.com>, Brian King <brking@us.ibm.com>,
 Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
 Mike Christie <michael.christie@oracle.com>,
 John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 Jack Wang <jinpu.wang@cloud.ionos.com>, Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
 Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
 linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
 MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 open-iscsi@googlegroups.com, megaraidlinux.pdl@broadcom.com,
 mpi3mr-linuxdrv.pdl@broadcom.com, linux-samsung-soc@vger.kernel.org,
 linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
References: <20240324235448.2039074-1-hch@lst.de>
 <20240324235448.2039074-8-hch@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240324235448.2039074-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/24/24 16:54, Christoph Hellwig wrote:
> Get drivers out of the business of having to call the block layer
> dma alignment limits helpers themselves.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
