Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F279B214200;
	Wed, 22 Jan 2025 17:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737565630; cv=none; b=GSkcBF1CXRSNnY29cHY5tToxTnlFQQXAb6APmefFwI5cfvD5b3MXVP3Iv4xf4O7YhUGkwcOo7NI3lvuplhyaWEpWcDZ12XzfYVzyF5peMm6SG/vz8hCPjiPB/Xa33xhgnFw5DuaW3ZCRjUnfQbrrua64kNlXhxVuLeI2FMthN+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737565630; c=relaxed/simple;
	bh=k3MTlzzhTVBchOZCrT8P+UBK3sXMc8f7PexjU1y7Bn8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KMoxVwXLvwanAspO9xhM1sA2hYFc6N6TDjguX8KFmrxzWeMZ4UpLgRnCaBgU3RrbiLHG59289TzkgqAcRB6Nit/WPLE5dvWxqBGzaCMP0Pli8D7ZaYE9qSwo50Anut6XBowf8hJAsrZ4dZ7XqGW/Km4bt4hBAiZvNXmjAFo5kiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lv5wv/Bm; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lv5wv/Bm"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2166f1e589cso173862295ad.3;
        Wed, 22 Jan 2025 09:07:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737565628; x=1738170428; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GFnDTj1I6ZClTjvqPxCPxzMIursCbOrnDmlrf1MGJtE=;
        b=lv5wv/BmMo2dG1nlsNUkGfCuCFGC2GBflaS5RONcsciriEFMnRhq6+FFLofKyBAXE5
         Hrty560AWv9lejHnC971mdGW4MN/1G8cORbPdb7/JpTzrzU5638wqz4/0PYrtRtoe2k/
         2LOdZdjpuu8wPKbUVPSn3CWe7GU92rnwvZmbImEvibGF9d0Hpx9WVQgOA/eznbXyFAg/
         9fS7aEJz8YCrXBHHTA//GkbMH83Uj8/6vAKhY6FR3ZLVSZg1s53g0xTCqKTdkLFywybl
         WAO6MyUNnDUYkctVSNv506pwel/fJIJMG+4KX+DL5ZDYjtLVqyNgtXKHwPYHicPu/MB6
         9m7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737565628; x=1738170428;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GFnDTj1I6ZClTjvqPxCPxzMIursCbOrnDmlrf1MGJtE=;
        b=Sm2o+8kFQovm/B5iwB8wWrN7b61Ho+nUYp3Pdzg8a6AaBUPwVtZQY2W9FXWy+6jYTU
         dJW+M+63unBPOE76YsCOyNoGXWurkTzU92i0pqwbX/y/9kbEz3vVVlpKGBpHKs9drsuu
         pDmEtM7NIZvK0ENY9FgFAoDVKClpTEZxQNONZ/YSiY7+3uiZ0B2nGq0ClnEPmu26WMdK
         +4l7447iSNYirus/aXwMkXXp9D9dn8YBFCaQSxUZUdBhDnjZf1TKApH2oGuSObfm9WHw
         APKgH61xhUgx5cqyKMD+A19R61fZHu+qUps270aIDoF45k/Q0d1rpdrqTa6SJoAZHtzZ
         NvKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXPE4Drgo5g7A27QHC+h6gznIy/dDNcTZqMMuwFUbvmjxH2cLsOp84eHXTP7WOR952wZZHwllYtcT0r3Q==@vger.kernel.org, AJvYcCXzOO0k8TDKRHmZ/Kh+9vtx6IeYOlHXKTWvQK+ttNRUlABSR4MvJl0rASjQG6U5PsFVeUxxwEvkp+Cib0w=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrW86Vd8okjxchnFhGuKIST/yYdd5Krw3XSSigYfv7pqljnBHg
	q0+IfX56aT/YzCzZKHEDl9m0P294C4/IzIyLqxptrmWy5gU9hYpVjhAgfQ==
X-Gm-Gg: ASbGncvvjaGtWtVuW0xm67uyFHGNOzVgb6t4lopqvkJd80xoRBq6slHhX+kAdfi14Kl
	8XZUNQ72mJjZCV3W88Uk8q66oxo67Qmx3eO37ETF1jNq5dUCY3G88aVtIvnAPsJ6m465BmfLAhs
	YdYOB1IXCgk9NXOxPD0OLbTZw0QD5TBpBUix6DJm/dn1H2UTADLT3CfngJH9Ajj/D4O13LB8zR4
	ZQ0kfKurMBBYqfVOLsDkH6FQQZzjXu+BKGpHRBJGO9Qgg6mG1/csXkDyfsbmOvgED2zYHnL/1n+
	6y0=
X-Google-Smtp-Source: AGHT+IE2JMY7DBLYUx5p6YJUetsh8tIL/3EWkIe0txGYLrmarmb0VknTEpNBJWJpkU+gnTlotlrOfQ==
X-Received: by 2002:a05:6a21:6d88:b0:1e3:e77d:1460 with SMTP id adf61e73a8af0-1eb214e00eamr36938277637.22.1737565628123;
        Wed, 22 Jan 2025 09:07:08 -0800 (PST)
Received: from thinkpad ([36.255.17.255])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-a9bdd4f70adsm11056560a12.58.2025.01.22.09.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 09:07:07 -0800 (PST)
Date: Wed, 22 Jan 2025 22:37:02 +0530
From: Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>
To: Avri Altman <Avri.Altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: Re: [PATCH] scsi: ufs: core: Ensure clk_gating.lock is used only
 after initialization
Message-ID: <20250122170702.jzwd57tk5dl7epwz@thinkpad>
References: <20250122062718.3736823-1-avri.altman@wdc.com>
 <20250122081756.hehvpcbyl2nd3yvf@thinkpad>
 <BL0PR04MB6564A6B239E652983AC5A878FCE12@BL0PR04MB6564.namprd04.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BL0PR04MB6564A6B239E652983AC5A878FCE12@BL0PR04MB6564.namprd04.prod.outlook.com>

On Wed, Jan 22, 2025 at 11:04:12AM +0000, Avri Altman wrote:
> > > To fix this issue, we use the existing `is_initialized` flag in the
> > > `clk_gating` structure to ensure that the spinlock is only used after
> > > it has been properly initialized. We check this flag before using the
> > > spinlock in the `ufshcd_setup_clocks` function.
> > >
> > > It was incorrect in the first place to call `setup_clocks()` before
> > > `ufshcd_init_clk_gating()`, and the introduction of the new lock
> > > unmasked this bug.
> > 
> > If calling setup_clocks() before ufshcd_init_clk_gating() is incorrect, why are
> > you not reordering it?
> > 
> > Checking for 'clk_gating.is_initialized' looks like a hack.
> Actually 'clk_gating.is_initialized' seems like the standard way to do this - see e.g. in hold and release.
> As for moving setup_clocks() around, I have some concerns about moving it out of ufshcd_hba_init.
> Having considered the alternatives, it seems that using 'clk_gating.is_initialized' ,
> despite its limitations, is the most practical solution we have.
> 
> I am open though for other suggestions.
> 

Looking at the code again, I think it is OK to have this fix for now. But
someone should spend some time to revisit the locking part in this driver.

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

-- 
மணிவண்ணன் சதாசிவம்
