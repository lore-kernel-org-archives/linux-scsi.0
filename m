Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD68605AE;
	Tue, 13 Feb 2024 18:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707847984; cv=none; b=OBRtvth6nXjvpXmb8Am1MZhjJSf0V0Cqx2+Xpchro3B7XNltJutjRfOtyjvkgOkx/NTLBM5cfLv+qzH1lM/9TdsXVYHBd+wcWMEku9U57sXbtmuA7+cPM6kMA5apEYS7zfIplTN2oLhuTnfv0mnE8V/qbpZMJDzZuu8IsFIhwe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707847984; c=relaxed/simple;
	bh=2k9/Gb4WID3VfKPXG3mdHuhoFUPCD9yLRe+9n1llDWU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O/e3AKy4pKVsR29CwV/OACESHoowHj+gYVwlQ/agYQ4e1HJOHcnXuOgiVoBA8GTbPPyw5ERTgRCSeYSK1QLiVD/FqsP/5giW5eyW2b0srvd7dALM71A8iHEItNEFGth9dT89GUHQk8NZ9dCjLs3an3K1VWUmzzGaw4zIgRreB8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-5dbf7b74402so3112683a12.0;
        Tue, 13 Feb 2024 10:13:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707847982; x=1708452782;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2k9/Gb4WID3VfKPXG3mdHuhoFUPCD9yLRe+9n1llDWU=;
        b=ibt/IuXZEqQNTSWRsQNADJOrBBTA6B179YeI6huKfJ4zHzbyf/rPLQpi9Vsa6rUvnD
         kNl2YAE4Yntwgxff4SxVcjWO6YSn6xioCmwZxdo0TF73RMj2GVORrL1MFtVDK2WBrv7K
         xDsPcz6T72BZcaPD6/2jaM9WpqzrrFI4IIPcRFw7Kz421k83m2NVbgF4pvvqHGXSowdt
         np7m6avsHD0jpHpomUFBuYLJZ6D+rkr9zs1n3mWBVya22NXcV5hkfDl41P947ZeKawHj
         cMtqcuO6Fvo/xc1bkh4ALwLceokBMhuhWAa6WqzZEREeIDmDbwa3x4cqbNZnQzcG2P9X
         nCww==
X-Forwarded-Encrypted: i=1; AJvYcCXpKOqb2p1xHr+tfjLQT5f2daYB5PwMHF9HDYIRPhCjC9oB+Lgq4p6t5G8cjmeDjrdGFDPA57qz//OmvqawoVzPAxgxxeYtl+Ef1O8UUfFMbyHT9/0+unLEnyD+hRSgQT5J2bhmp6QUP1/fcb3o3HJJIhbX6SaqFXuaNTdhhw==
X-Gm-Message-State: AOJu0YyPwwp05uXrvicp9Z88lvXXmT3x2GnNYlltnCDuXIwwoNLNr9D6
	eeyYRMEAlcIJr7QVk3lQaqlXEvjP+9Uc0+8gDc4FJ8p1hwwqbzmw
X-Google-Smtp-Source: AGHT+IHmINl9u+Hp9Bc1sO+P46ZEj2uCQvNP2fo83WdQVgO69nf6brGL+Qt8e9+vZOWJpCnFQp/QIQ==
X-Received: by 2002:a17:90b:68b:b0:298:ab04:7381 with SMTP id m11-20020a17090b068b00b00298ab047381mr247797pjz.25.1707847981882;
        Tue, 13 Feb 2024 10:13:01 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWb6k5uiZdOujB1tf1Alj5VYtRZhWLBbKQ9r4fmX/9FzLM9GD3e+h/z012ckOZwj0T4ZjVUGgbgPo3/RIklKUyCqZkaExtGw2jnSS1bsLyyCCM2ut/5G0U/9iAmu14opBQK1pb+1EU6+EUlBNWP7nFHJrBpxWSAHQ/lufql4KSnTzwBD2n83gwb3KOeI4AXjQYx
Received: from ?IPV6:2620:0:1000:8411:edac:bb62:c977:aef? ([2620:0:1000:8411:edac:bb62:c977:aef])
        by smtp.gmail.com with ESMTPSA id pl4-20020a17090b268400b002966248d75bsm1549809pjb.49.2024.02.13.10.13.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Feb 2024 10:13:01 -0800 (PST)
Message-ID: <fabe11a4-d9a3-42cd-aa97-e2214c89de33@acm.org>
Date: Tue, 13 Feb 2024 10:13:00 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sd: usb_storage: uas: Access media prior to
 querying device properties
Content-Language: en-US
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
Cc: belegdol@gmail.com, stable@vger.kernel.org,
 Tasos Sahanidis <tasos@tasossah.com>
References: <20240213143306.2194237-1-martin.petersen@oracle.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240213143306.2194237-1-martin.petersen@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/24 06:33, Martin K. Petersen wrote:
> Match the behavior of a well known commercial operating system and
> trigger a READ operation prior to querying device characteristics to
> force the device to populate mode pages and VPDs.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
