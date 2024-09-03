Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DF61DC744;
	Tue,  3 Sep 2024 20:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725395499; cv=none; b=l1Q62efBWV++OE7tkVfzSlfHTXta4lJHfH77F+yLHvYy4OP/QXMWnhwhnGP9Lzf8dysEYfVMi+HjSB+2718dbi/f8trN1Qgch/zyd9IVG2wmT1Qj4Z2Xk/AW1cxGJDOdrY9wMIFihaCfZK32F2XrPTIvOzjFtKSvNytixQbZnDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725395499; c=relaxed/simple;
	bh=xmuMa21+b+uKAHL09j61Qjrbj6fBlP0AYRtv0TAQngM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUzvqMRkDFlwRMhxEGBbxd7HpcwX39QQEDgap7x4myeWP6uYVl3o51S6NdFLSWC41IlckneE72z+p2uB5fo/XQ2owmVG1djjPDaApb6THNQ74kPmoz2oadfdKiRu2ExGkG3ian1pqsApXL1yiZ03wiD/OUWg5sYlE3MS1zn53yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JIFpzm+V; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JIFpzm+V"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-20551e2f1f8so28515125ad.2;
        Tue, 03 Sep 2024 13:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725395498; x=1726000298; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VA+wMvCOU+Zn3Wu3Jx5nqZybutdhYyNoMSRcIzN85HA=;
        b=JIFpzm+VCM/PLBK1p6ITKQf7Rjyu1M90pH8V3bpLubXx2UaXxppUqKdupY5ugWoOUT
         w6OJZCykHDSqllgEQA+LEvDuaLQLfBWMVJRHLEXXjkBPxzM44C/bUOnlSd3Y3LwFHCfX
         iNkH8AzLHVStZyEGEwk+2lkxnY7n6BW+iZ4S4wzHwqCd5YsLTytNOMAC0QDyOh8ltL7s
         9QOzk30sSzZZRSJVPCr9Gn/A2sBcM7UXZMcf99zKZYbH0Ivqfh5Dlyc/bEP2wf/9O1i/
         SXKLB1FsKtdfQRNaiqqOPCb7+FAftfQdsY1O64KKbuBLOL3DbzEkgajG0bvMJGeaDops
         WWIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725395498; x=1726000298;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VA+wMvCOU+Zn3Wu3Jx5nqZybutdhYyNoMSRcIzN85HA=;
        b=oYv6FL/4VaNshIXKcBOQME7bIIQEwn4hBMRHe/qfmi8ydVtHrNRXa/P7lOL7SIXPuv
         Vum0zzPlu/Cvc5jQB1cJGaFdqbXxFjymE2Jk/1aRFtfVN1JRjeXxp+vrqRAOlY0aq3cf
         ok/+o5SiKrCMY410wh+KHHVkbI080UZNP5kcLjZ73Jw4+3TnfIXHkYrF9fOi0qatucHP
         2lbyb9gtLfuoTZBeoikLxGC/T9qqm42x6mMzB1zEP+lYDpWb0PEDnJqgg8/sijcElYKg
         mgKO50wyZ2j9IXA8+3fukKsF2W/u3GwvBWmjwNjNrbWYPv0Sq6uiS/41s4B5Ix6gGr3p
         tHIg==
X-Forwarded-Encrypted: i=1; AJvYcCVgixODE3Z7x9f1hAfG9T1qUnAh7Zep9TO8GNTfGir+mSdoU8N0Exd2MXP5s89cJHl40UpScszKzx20XIM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGW1L7pRZAwX/Z3cLXA1pZzLNqCDPZQV7YifZ1lxiuC0bLM3MI
	cWqbWTCr+JWOAoU5bLBdbaCNoJ37dIt1WyjsfDNl9ZahKeuhMbMF
X-Google-Smtp-Source: AGHT+IGPtwQehj8Qnq0KPAz3fls1ieIv0Uqe/xF3I6kGuKO+sr/5cUwhXjsoTCun39qQr52fTyFxkw==
X-Received: by 2002:a17:903:188:b0:205:4e22:ccfc with SMTP id d9443c01a7336-20584222d0bmr87946995ad.50.1725395497288;
        Tue, 03 Sep 2024 13:31:37 -0700 (PDT)
Received: from fedora.. ([106.219.162.224])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206ae965b58sm2366355ad.118.2024.09.03.13.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 13:31:36 -0700 (PDT)
From: Riyan Dhiman <riyandhiman14@gmail.com>
To: bvanassche@acm.org,
	aacraid@microsemi.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: aacraid: Fix memory leak in open_getadapter_fib function
Date: Wed,  4 Sep 2024 02:00:13 +0530
Message-ID: <20240903203121.5953-1-riyandhiman14@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <b7f0acf4-5e7d-4491-81be-71518197c58b@acm.org>
References: <b7f0acf4-5e7d-4491-81be-71518197c58b@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

>> This patch ensures that the allocated memory for fibctx is properly
>> freed if copy_to_user() fails, thereby preventing potential memory leaks.
>
> What made you analyze the code modified by this patch?

If copy_to_user() fails and returns an -EFAULT error, the memory allocated 
for fibctx was not being freed, which could lead to memory leaks.

> How has this patch been tested?

I have compiled tested the patch. I realize I should have specified "compile tested"
 in the commit message and written "preventing potential memory leaks" instead.  

>> Changes:
>> - Added kfree(fibctx); to release memory when copy_to_user() fails.
>
> Changes compared to what? I don't see a version number in the email
> subject.

I included the "Changes" section to indicate what was modified in the patch. I will 
remove this section in the updated message, as there is no version number to reference.

> Just above the copy_to_user() call there is the following statement:
> 
> 	list_add_tail(&fibctx->next, &dev->fib_list);
>
> Does that mean that the above kfree() will cause list corruption?

Yes, you are correct. I overlooked that fibctx is part of a list, and freeing the 
memory without removing the list entry would corrupt the list. 
The list entry should be deleted before freeing the memory if copy_to_user() fails.

Regards,
Riyan Dhiman
