Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC6212F
	for <linux-scsi@vger.kernel.org>; Wed,  6 Dec 2023 17:03:35 -0800 (PST)
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6cea0fd9b53so111523b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 Dec 2023 17:03:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701911015; x=1702515815;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U52vngLtiH5dfNxbwArqM84+bCaFar9/QyNxWIIqCuU=;
        b=IAu6YVAv2TNf6E2P0wUUPfAiJJK3IHMfEaGNxdx5gP9TkxhLj5vMWEvBrzDNQwOWVZ
         hZOszGO14lcjERl3sue8CFLS70f+f7+Hmnsr5+TWeQESZUXtb0Ayj1eWc5SlH13WGymG
         ep8OZLgf1jdwYltlFTuk2Q1IKWdO+Dz6a7onv6Dx7MC7mdwgqXZcNgxUfUh4gu2BN3ww
         vkSvQcyf3fV218WfNqI4Qvn1B0eLTx+F8lJ2OuUFhiz0XaWkOLtRW60rVO1IL5XR1/N3
         6hedPPVa3vxMzY+8vJQC3zLaWcHDIjJ/mopyMZeTbS2Yka6UyeV4kaH4AHl4YfsRud0E
         Z9nA==
X-Gm-Message-State: AOJu0YxAWw8Ur42bRw4nIWn7c0F5hGBvcMF5XubXmirMcRlCHxFimk0c
	iSBuOVhFcggz8CSKdLnGb5W8phy2fVw=
X-Google-Smtp-Source: AGHT+IFiiqT2rVtUw9XwpgPgsBD1M9nPaAOX472eSgEKuT0pYu3RJdmjJkbnsx0NZhtzCnbuQyBvKQ==
X-Received: by 2002:a05:6a00:1503:b0:6ce:2731:d5d4 with SMTP id q3-20020a056a00150300b006ce2731d5d4mr1763065pfu.69.1701911014884;
        Wed, 06 Dec 2023 17:03:34 -0800 (PST)
Received: from [172.20.2.177] (rrcs-173-197-90-226.west.biz.rr.com. [173.197.90.226])
        by smtp.gmail.com with ESMTPSA id p2-20020aa78602000000b006889511ab14sm134543pfn.37.2023.12.06.17.03.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Dec 2023 17:03:34 -0800 (PST)
Message-ID: <6a9482bb-ead0-4ef1-b77f-0783e6cdd72d@acm.org>
Date: Wed, 6 Dec 2023 15:03:32 -1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] lpfc: Kernel NULL pointer dereference in
 lpfc_dev_loss_tmo_callbk
Content-Language: en-US
To: "Dietmar Hahn (Fujitsu)" <dietmar.hahn@fujitsu.com>,
 James Smart <james.smart@broadcom.com>,
 Dick Kennedy <dick.kennedy@broadcom.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <FR0P281MB212385AC7DBA18F47AD793179484A@FR0P281MB2123.DEUP281.PROD.OUTLOOK.COM>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <FR0P281MB212385AC7DBA18F47AD793179484A@FR0P281MB2123.DEUP281.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/6/23 04:50, Dietmar Hahn (Fujitsu) wrote:
> We use linux kernel version: 5.14.21-150400.24.92-default from SuSE SLES15SP4 containing
> LPFC_DRIVER_VERSION: "14.2.0.14".

Please report bugs in SUSE kernels to SUSE. This mailing list is for
discussion of upstream kernels.

Thanks,

Bart.
