Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E221156C74;
	Sun, 26 Jan 2025 19:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737921331; cv=none; b=aA0NeW1uwXw80rWPqG1lnF/7+oD3yB0FHWzElU/VXWla/7Ww/4+5GVzFjiIcHZJBjhE6GSpQsxpvFRt3y9VOceF1ztGuiFv7Cg0IvgCF2sOtX0gOrjOz5Gi1Qnd6MN526LWmc6092LClgupuwt9BE9iuPWINqQsUj2sFocOtuKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737921331; c=relaxed/simple;
	bh=XU3f8iOzysWsUXprwUt22rCfRKOt8VzIxFdJ24lS6Ew=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OboLsyltRcs6oOXODwK2rXfFy2OOSa6Ofk/D68UefB0/9asHlK0MYHzM22TPSA3HkhA0RKDEjLF4q3zEBMGwTplj6jv8JUByBYBri7GgRY3mehDjWUci76zDPiQXGXCuLt/DO/HZWiiT68wAgGZytwskL5kPbVpoxq9LcFGNInE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IPWs0rbS; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IPWs0rbS"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-437a92d7b96so38815525e9.2;
        Sun, 26 Jan 2025 11:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737921328; x=1738526128; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XU3f8iOzysWsUXprwUt22rCfRKOt8VzIxFdJ24lS6Ew=;
        b=IPWs0rbS29D/VoJOWsqiVlO+AALT3Jo0s6bN7dzMfuJp8wkgBbKPMtBeXbvbltJcpc
         oLScriH/O2XDh7KgvxSAro6UUmwECTMMkNS3aV/MmH7vUeyq+zUrIaUcu4CcEWSVqOuW
         uvdVzRQiFA7NRjZJCbrBjYordo3wIuk+xje7hbD4Rv3P+gktsI2VCeuDZatHivg85G76
         ncrEvke18YXMLPvHjM3Cu2VU5ed9AItDWXLUn+jT7x1+XRzWWWSKQTTB5zsQq/GDcq7B
         mQxFDfHRn0lA/AeoYNTWJ2VT/MuoMlQSzsthWUUYPE/r+/o4apu9lrfWiYYkS9GFms1s
         6eAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737921328; x=1738526128;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XU3f8iOzysWsUXprwUt22rCfRKOt8VzIxFdJ24lS6Ew=;
        b=BZddP4OlLn1cB5KjjwHgs2vUZILvLz+fNEUgPkP2imWvGVdVta/t/KRsQa2uw/Euru
         r2nTOEHNwkcQ6tWhMAxX5JpjdsWFbGsUQQ89RbrcyVFNO19BsXTvfV7FVGrNA9sKGrfm
         T4hc6XzXOFbkqVv21S+GdLC+hQPL1Ig942Jl7gY+b4KYHKY7xTlmAmg0zmd25XV872VE
         Sq84bEK/KRmGfhPG0aXxCD36vFlWtfZtigldhXvi1iRA6t6STEDsfAPatj/HrDdBCjce
         PMwpHyyjphU7DB8R9vuebgrl6DPod6MIINg5F9PHWOQmcjICPxvxzTOHtpUMskQ4aatq
         EUfQ==
X-Forwarded-Encrypted: i=1; AJvYcCWOBLTCYjjbxmgaJIY7jKuY1kkqKvwkN8nSRtaLlKqFtoQyGbBzfSofjYl/eUIaQYkGYVsZmvUrpqDrMm0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCouIUDfUixvkFh8Um9bTyxDg9g6qQEJP+yCNuYxZ/AQ2VbCoa
	KsHfTblVNEgupZbWiB7bU24Q2pvihulREYO8yj0D/YTiIKFL9EfSUBIftg==
X-Gm-Gg: ASbGncsV+AWAuzUz/huXh9Therkfuix02MGxHxO1/Vbov+gyHH5UNZMAy0YrqLALz4g
	tw1BAiudqJtHoJ5GfIdwJ7UqkVDcW36F4dv/co74V0eGRxaXrJWCsDPtrh6ZULtPtDt0E6j2LqW
	YMOZjZnJmokpEQlu69g9SDTwWoKfzO1HzvEk160NS7Bj1ZSmA5P/k/QB1ZwPBG3VfCdyWSydg4l
	NG8QyK5QkyvEjIMY+eiM/qkWE9p6WdwvNMvq6fHHsRUlUZM7QA11KJ3XSkBQP/31qYmWL/eyb5J
	unw5pnikWGaXXVIzGd9dF4KJe/wtgonpluu+8jjqg2UCsHv5zAazw3koOKP3RG/HetSnE/86AtP
	04BXWSEXKZSe25MtpJw4g1ju/EK6G8q4VF591LC7KT5bx
X-Google-Smtp-Source: AGHT+IET4X3oGPaE+iAz5vs3rFb65UIlv0jVcm+BLdjZIBgW1mTIrMNWn/YgAi3BgBo4nUjPWRFMHg==
X-Received: by 2002:a5d:438c:0:b0:38a:2b39:679d with SMTP id ffacd0b85a97d-38bf57a9d66mr24934124f8f.32.1737921328089;
        Sun, 26 Jan 2025 11:55:28 -0800 (PST)
Received: from p200300c5871e9503d190d4ef6c3ca8a5.dip0.t-ipconnect.de (p200300c5871e9503d190d4ef6c3ca8a5.dip0.t-ipconnect.de. [2003:c5:871e:9503:d190:d4ef:6c3c:a8a5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438bd501c38sm103006225e9.11.2025.01.26.11.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jan 2025 11:55:27 -0800 (PST)
Message-ID: <6247db2ef42dc3d9f5d687a82b469bee9f70880a.camel@gmail.com>
Subject: Re: [PATCH v3 1/2] scsi: ufs: core: Ensure clk_gating.lock is used
 only after initialization
From: Bean Huo <huobean@gmail.com>
To: Avri Altman <avri.altman@wdc.com>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Manivannan
 Sadhasivam <manisadhasivam.linux@gmail.com>, Bart Van Assche
 <bvanassche@acm.org>, Geert Uytterhoeven <geert@linux-m68k.org>, Dmitry
 Baryshkov <dmitry.baryshkov@linaro.org>
Date: Sun, 26 Jan 2025 20:55:26 +0100
In-Reply-To: <20250126064521.3857557-2-avri.altman@wdc.com>
References: <20250126064521.3857557-1-avri.altman@wdc.com>
	 <20250126064521.3857557-2-avri.altman@wdc.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0


Reviewed-by: Bean Huo <beanhuo@micron.com>
