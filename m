Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB157215173;
	Wed, 22 Jan 2025 17:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737565966; cv=none; b=hoi5gLR285mk68Q7StWdBaGbs/Tl+smWTF4W77KJQIQnGON5XrO3ctXcH3333Xml/n9f/qnRTKlaIrxMi3iLWm0XUbncQ8N6ceS59SFlcF77wkH7xhpZMhauCLzLwXU8w1Q0SVai2ACDDLJv3flDT9Ar5Iy+LGWsxk2K5YW26pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737565966; c=relaxed/simple;
	bh=lBeJtgsVmWCJbHV8MeLIgexfVuv4ZOCRaZfsna0uiN4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X9SlWfyHhtZik1gKyP/rPQgGEnyB+4MM27Ccxfj3ML6BXf70QwbrzUOOI4IKvAWMfyDZU6Iw30o5kPAm80x8PqcKKwXa2ATBC4mXYvjMFHZOAxc7F/CmnNwyJB2n9UFx/1Wpa9Vug/SzmZ0ZHyP9tBcK+KbuZImviYjBIln2NWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aS+8p2bB; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aS+8p2bB"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2161eb95317so129767875ad.1;
        Wed, 22 Jan 2025 09:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737565964; x=1738170764; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aVe+pO1AahYdD7i7Wr7NkfEzGDY9UwineuiBRqxmYiY=;
        b=aS+8p2bBUdFREa9gR8DzaVvaAbYi4w1xLTsuy4IxtQ7KPsfJwJixQYY7Oy5SlN/Kt5
         NKeo9JeDwmskgn17LJmiUyQB8YAy74rRx0XKrpnZKjkvjtrG2Ek5C4V1oY/Zp5duEVVO
         dPI2czhB12vDyOVaQX4FCjjXwLoHQcDphJ2S/SUquYmuBcwgdG4UyemjAK9rYXBqrvZe
         lbh8WRJhNq5FuRP+bRu+f6ym6l8e8VlbTgpx9pmMGsCCN5R0bwvmOLqLzlQw9NdsGLvj
         pr64GuP/EFW9p02b0x+qs96sqgNZR3tMB6h9w/HHXuT4QOWC1vZDz2/No0bum7QUAl3d
         pCNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737565964; x=1738170764;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aVe+pO1AahYdD7i7Wr7NkfEzGDY9UwineuiBRqxmYiY=;
        b=DkLAOsjOBBSzMIuXQd8sa+KS/HRzy8GG8koBiwmBFzo9NyM3AQnIX2pOW4roKPsUdA
         38n4+7jX68hhq7+HcQFQNL/DMX82MOwno8F901y4KjUDuCFA7OeHwPvlwXEZT3ctQopW
         2IR1mRzegTx8mAVY6iep5B9dVwAcIIURwQVwNCxbI3XzCyl6QkG0fM74debIx+CRqjgx
         gPwARKFo+j/z1GN1DlBYjkkVdOV5Yg3NWT5M+rTqyWRQsnVc5Nhp3OhuKE2Ai/1EnfJv
         07US0YMKnJ82LGG4C4SUU13EXCb651gZ9wAbRavp+Um0joAFFNKEkz0DKqBpHhi0/QIV
         0PCw==
X-Forwarded-Encrypted: i=1; AJvYcCUKkCCJNt0moPTI//OomzbROuOtkAZQM/zL94CI/bQ8VIdkEWykDXOzuZ77qSCbajTlCdpPM6YPu+dXdTY=@vger.kernel.org, AJvYcCVK1oavciV/fVeIhB5Cq06pnuTarBd1waXJ/Tt/4zE5dQyUQuUzN8oLrUBiDs6EQZrHCCBzwJANg7s1kA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ/G0JEI4NMRmaSx7DpTzS9E/1Jb60DbikYBF1phyEvWDwLGHk
	HZSn2/bPOCHYpOTHJ4R6l387Uah3JNDLrh+c2d9DvD/Ad9aamz2yGKbJfQ==
X-Gm-Gg: ASbGncuIyGZ012vq4ij9cSYD9nHIR+qJOJ9rqJG/XJtiPOM3bfhYY60Wcx8/rqcIYqZ
	sPHJ33yiggkWTb3CaADnofPtgL6wCXRGXG7PMnw3RqPouugNXElevJ43CPcZItIq3iiWn9/Mz+b
	93BKh0E4CQSYOG+4L2oxAlzV9pBL7q4+zELSQMaJsNi6fptevxK1QWwjw1A9UxqBZP4thBmgkmT
	1tdJNm7YJiKP9jP+EInNypi9/xAbqaZbSY5tAHTT9GVy89PzXfkQNGz4eaocf2Jyk4ia8QpX93o
	xAU=
X-Google-Smtp-Source: AGHT+IG0FxcmccrfX/tM3+56ArEEUsPuLe5SaKAIUXWRusN7KZq/7hFrNzfowzz+kuDbzTyc7s56Rg==
X-Received: by 2002:a05:6a00:2444:b0:725:e37d:cd36 with SMTP id d2e1a72fcca58-72daf929e6cmr33124985b3a.2.1737565962613;
        Wed, 22 Jan 2025 09:12:42 -0800 (PST)
Received: from thinkpad ([36.255.17.255])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72dab7f0b0dsm11154255b3a.30.2025.01.22.09.12.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 09:12:42 -0800 (PST)
Date: Wed, 22 Jan 2025 22:42:37 +0530
From: Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Can Guo <cang@qti.qualcomm.com>, quic_ziqichen@quicinc.com
Subject: Re: [PATCH] scsi: ufs: Move clock gating sysfs entries to ufs-sysfs.c
Message-ID: <20250122171237.33gvwxgmpsoqekwt@thinkpad>
References: <20250122143605.3804506-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250122143605.3804506-1-avri.altman@wdc.com>

+ Ziqi

On Wed, Jan 22, 2025 at 04:36:05PM +0200, Avri Altman wrote:
> This commit moves the clock gating sysfs entries from `ufshcd.c` to
> `ufs-sysfs.c` where it belongs. This change improves the organization of
> the code by consolidating all sysfs-related code into a single file.
> 
> The `clkgate_enable` and `clkgate_delay_ms` attributes are now defined
> and managed in `ufs-sysfs.c`, and the corresponding initialization and
> removal functions in `ufshcd.c` are removed.
> 
> No functional change.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>

While this patch is useful, you should also consider adding the ABI
documentation for these. I did share the comment to another patch that touches
this part of the code:
https://lore.kernel.org/linux-scsi/20250119074823.lnlppdpsfnkz7onx@thinkpad/

Maybe it is relevant to add the documentation together with this patch.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
