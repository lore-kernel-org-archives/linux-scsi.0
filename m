Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06918122
	for <linux-scsi@vger.kernel.org>; Tue,  5 Dec 2023 10:15:15 -0800 (PST)
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1d0c4d84bf6so8242395ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 05 Dec 2023 10:15:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701800114; x=1702404914;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FlxomyK9j8bdR77lCwqEcPy8n/Owpg71TskCiocC7wU=;
        b=U/s2AGMyq4IJSlFEfOx/DzfKokDya902F+2Lr0EYFzYPvRteFA8E1cClbMv1zuQHz+
         A7HJttJf71fIhkflFIHl5+d4kPPycZaRrzZCkA0k7pf7sWW+DhTs4n0ofqjzMTtd6xa5
         Aop+Q0Ljv0yDO0x1Alpp+VCswQirKFZu9hlTWe0RM/S2wQstz/e2IcEq6pK+PdLPKS5j
         9OY83yM1/M9BeCMM4j9Tp1M2B+KJg8+iFn4Ps/NWXeJCnXpGims28WKIdWb3uM8JlHHS
         gr2XtECsgR3H8PecrlsGJVK3RW5CGVrHQrf/AGNUuqQNDUrBZYj/EasJc7FJwkUdEhoG
         6qYw==
X-Gm-Message-State: AOJu0YyauAFke0ZtMK3J9mcnltQxXlzyZmAIB0is/wnC/g0dpwGH7yH1
	yk42KHdWHapuq/ukqectZX0H1IRcGpM=
X-Google-Smtp-Source: AGHT+IHLnEvZxKayVP+VWZW3YcNy2EtAGWujT+G93QGDVB8WM5+mhWqXyeuIVTpCaw35PK+HNad8gQ==
X-Received: by 2002:a17:902:6a82:b0:1d0:6ffd:f231 with SMTP id n2-20020a1709026a8200b001d06ffdf231mr3787502plk.135.1701800114248;
        Tue, 05 Dec 2023 10:15:14 -0800 (PST)
Received: from [172.22.37.189] (076-081-102-005.biz.spectrum.com. [76.81.102.5])
        by smtp.gmail.com with ESMTPSA id y8-20020a17090322c800b001bc6e6069a6sm10439737plg.122.2023.12.05.10.15.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Dec 2023 10:15:13 -0800 (PST)
Message-ID: <eeb94a02-7de2-46df-a9c8-e4abe4c52459@acm.org>
Date: Tue, 5 Dec 2023 08:15:11 -1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Fwd: drivers/scsi/mvumi.c:407:40: sparse: sparse: incorrect type
 in argument 1 (different address spaces)
Content-Language: en-US
To: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: scsi <linux-scsi@vger.kernel.org>, Shun Fu <fushun@marvell.com>
References: <202312050259.TaopJEnL-lkp@intel.com>
 <9e2696f5-731a-46d0-8c18-804628c677f3@csgroup.eu>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <9e2696f5-731a-46d0-8c18-804628c677f3@csgroup.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/5/23 09:52, Christophe Leroy wrote:
> You seem to be one of the latest and most active commiter on that
> driver, would you mind handling the sparse issues reported by the robot
> on that driver ?

Hi Christophe,

That's a misunderstanding. My changes in the mvumi driver, just like all
mvumi changes of the past ten years, are refactoring changes that
affect all SCSI drivers. The most recent non-refactoring commit that I
could find is the following: bd756ddea18e ("[SCSI] mvumi: Add support 
for Marvell SAS/SATA RAID-on-Chip(ROC) 88RC9580"). Shun, is anyone still
using the mvumi driver or can it perhaps be removed from the kernel
tree?

Thanks,

Bart.

