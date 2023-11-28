Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C6618E;
	Tue, 28 Nov 2023 09:36:53 -0800 (PST)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1cfc9c4acb6so21389975ad.0;
        Tue, 28 Nov 2023 09:36:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701193013; x=1701797813;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qQVzoA6KB8WWZeZA91BhoJD6+IG8LppaJH07D3mUsOU=;
        b=i7fEQn5Mtk4pCNuLFF6JM+SVrLzw/LMiy41POibLRW+M7vogks/qGZ6tZ6jBljXXBa
         VjATiROwAYjpQO/jFhGPANqDy++xjd52HAIgESh0L56udjVMSItt0dh4Tpuq7ybvk2M1
         iA+NVz8GdJJgLtiCa+A9pxXywNcG01M1nFFpk6/SDMSSXWoVOuXLhHcgM0J5LQ/DHlS1
         Uu4VuJiYuaPA/4Y8FRXOc4TlO+fadw8qwdsmyui3E5w/hUCN7K2qBR5iNSr7PvQAtX+T
         ZpqYE8Ypbj7JTwDtDyYTUa7tUFyjR3KImLLIqOH5/rZ1X/rYk6YETntto1THvO1WYtN7
         UROA==
X-Gm-Message-State: AOJu0YwzaAhcsluPk0hFKWNZWzVpkeSBZTNyVXnUTFhi7HR+FDqbAC/V
	Y8rgNOUp2/eGLc2iY+awN5U=
X-Google-Smtp-Source: AGHT+IHJ8Zcb57hVsFkWr7NeyCpUP5cJFsatU7AGCSaKVooiglAQrpzT62jm1Aug08/zw1+qGuGcHQ==
X-Received: by 2002:a17:902:ab47:b0:1cf:cbf4:6f7e with SMTP id ij7-20020a170902ab4700b001cfcbf46f7emr8293088plb.14.1701193012679;
        Tue, 28 Nov 2023 09:36:52 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:81f2:7dda:474a:ba23? ([2620:0:1000:8411:81f2:7dda:474a:ba23])
        by smtp.gmail.com with ESMTPSA id v3-20020a170902b7c300b001cfc9ad74a3sm4702377plz.15.2023.11.28.09.36.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Nov 2023 09:36:52 -0800 (PST)
Message-ID: <9f522b19-82a0-4362-956b-fac10c99b1ad@acm.org>
Date: Tue, 28 Nov 2023 09:36:51 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 00/19] Improve write performance for zoned UFS devices
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>
References: <20231114211804.1449162-1-bvanassche@acm.org>
 <20231127070939.GB27870@lst.de>
 <a9748872-0608-4ab9-8986-a82eff17ca9f@acm.org> <20231128125355.GA7613@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231128125355.GA7613@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/28/23 04:53, Christoph Hellwig wrote:
> I know the background.  I also know that JEDEC did all this aginst
> better judgement and knowing the situation.  We should not give them
> their carrot after they haven't even been interested in engaging.

That statement is overly negative. The JEDEC Zoned Storage for UFS
standard has been published last week [1]. It can be downloaded by
anyone for free after having created a JEDEC account, which is also
free. As one can see in this standard, nothing excludes using a zone
append command. Once T10 standardizes a zone append command, it can
be implemented by UFS vendors. However, I do not know whether T10
plans to standardize a zone append command.

Bart.

[1] https://www.jedec.org/system/files/docs/JESD220-5.pdf

