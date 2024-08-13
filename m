Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2033B192;
	Tue, 13 Aug 2024 08:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723536630; cv=none; b=f5iefMbF3VvEgSMi+Ivt+APp5fAnaCTIZx4SnljolXNPtg9zDOwM99X1wwgo9WOtM7PSk1XWv8CiBQC6pNKhNu/UCn/L7e1AeiTB6pArCQCOJC9Boz+uupd73xmcdjlN53yYzm/Lb8dfAl57JCZT8mICuZ2mwiNUvfzchig3yYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723536630; c=relaxed/simple;
	bh=AFD6CmMksAHiPQ3u7g2nDhVmTrpKx+3AoTu8/7v0DGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e9ZvVMwCAxIsxFz0a+QY4jwmetkGChj+bJVWmJn4IwgHJJ14gNBZvSvZPPK2rFpOZA0gC9ln9V73gG+jxXUJXZfl84AdyJZzQ5dxzToLZ/i7eG8PDcPZ1evpFxOmfuEXycDFrLy7u2K1DCjVrPhNF2xe8q/hxKnrRVW0KiCHtww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5ba482282d3so6386810a12.2;
        Tue, 13 Aug 2024 01:10:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723536627; x=1724141427;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WMZrF9Pa4R4yecHFDustYvzQsmDBNpAcQ5C20dWPco0=;
        b=N8O0GOqunjscGZrHk9w6zi7eclCH1iR2Gmw47oOnEDrAg0r7VEsHp0keaUf6k2ZCvs
         h6Vw/FKnin8Z6o1eMwum2upvEm2fxxbCzgIxoe1EkaYyyR8jZwinKdI0PJLYiVRDX9b6
         I2F76WHpqgpOpHBb5IWxadSSXIYenmH51KQM2uag1Z/Fdd2E0w+bRhuf5KSHOsTPBw3a
         jihTB/cjTiAwdjGj8BteutYU32R8QjtQaFgz0IjUM6cYqIZgNiTXPjaE+YT0lzRe98wr
         0UxarHWm8JF/w0Nap7ogFAlxIUfm+LAKXGYDXWFM4Fi9ZxWcoM7nK0rfrDCmAc4grOVZ
         4CNw==
X-Forwarded-Encrypted: i=1; AJvYcCVZJM+BJZGX/7JncSJG3Gm4Z5FyN8kal8jK0lFY7GcKhfROQIvu2Z7IgVgbejrmqNEdyZ69gmBL8UN8+LWflnXrvfhEAvyzM4gZFnfFuJ83ed0n1yGGlfCQj3yVlVH3XGG1T5GIyTpjvg==
X-Gm-Message-State: AOJu0YxHkPSKh5Ls/Nngvj/OurEZpUqkLNIqd3bMrfnrDvb5KolpJ9fh
	vufooUIy+mY+/zrO6oEBsDjFMwRZj0ipa/a9/tsiXsL+3krw16lBac6iXQ==
X-Google-Smtp-Source: AGHT+IETDRF24qdZSzYXQ2uoxitHnNIZS61pBXpHR6iM4ULljt1tkzLUtbor55HS4ThLia9APX4sDg==
X-Received: by 2002:a05:6402:274b:b0:5a0:f8a2:9cf4 with SMTP id 4fb4d7f45d1cf-5bd44c65afcmr2063687a12.25.1723536626581;
        Tue, 13 Aug 2024 01:10:26 -0700 (PDT)
Received: from gmail.com (fwdproxy-lla-007.fbsv.net. [2a03:2880:30ff:7::face:b00c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5bd187f32fbsm2710153a12.11.2024.08.13.01.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2024 01:10:26 -0700 (PDT)
Date: Tue, 13 Aug 2024 01:10:23 -0700
From: Breno Leitao <leitao@debian.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	leit@meta.com,
	"open list:LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)" <MPT-FusionLinux.pdl@broadcom.com>,
	"open list:LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)" <linux-scsi@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: message: fusion: Remove unused variable
Message-ID: <ZrsU7zGH4ypWh/4s@gmail.com>
References: <20240807094000.398857-1-leitao@debian.org>
 <yq15xs5xkta.fsf@ca-mkp.ca.oracle.com>
 <yq1zfphw65a.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yq1zfphw65a.fsf@ca-mkp.ca.oracle.com>

On Mon, Aug 12, 2024 at 09:42:33PM -0400, Martin K. Petersen wrote:
> 
> > Applied to 6.12/scsi-staging, thanks!
> 
> drivers/message/fusion/mptsas.c: In function ‘mptsas_reprobe_lun’:
> drivers/message/fusion/mptsas.c:4235:9: error: ignoring return value of ‘scsi_device_reprobe’ declared with attribute ‘warn_unused_result’ [-Werror=unused-result]
>  4235 |         scsi_device_reprobe(sdev);
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~
> 
Let me handle it, and send a v2.

Thanks
--breno
