Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAD313AD3D;
	Thu, 22 Aug 2024 06:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724308486; cv=none; b=W/UlzKLgZZjhFe+DAaJWlREXm1TpIIVF5YFStsgtv0Q09yDzOCyz8u6fj2Bsrb3LBHla1/oHQJ0egd2qFed+GVQjAfpvHxGqNJZaH2twXg1Q4aSeL2ayjq4RXWcduq0QCZsMhn+vOAPi3B8FnX+j7ViXs6GPIFX2X/vC2rmSRXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724308486; c=relaxed/simple;
	bh=NF0OluGhBRTlKPkVfM1cDauUAjkB29/D4j6OdDxA50M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JVZXuutE8tFUfV8XR3Cx0eD0i0/aBS7FGoshTpgV0P7BIf1dLFgOvxCGSmDfndhn/R8ty5e803ljWVJXjP1gGsXeo0IT3XQR9zXoMTbkf9HJLwNsVbZz8ecHeikYqTB2zNTmUcHBs94oEVSg9meHROeaaZSr3Y//J2ZxudyjAGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g9PSf8Ex; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g9PSf8Ex"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7095bfd6346so358608a34.0;
        Wed, 21 Aug 2024 23:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724308484; x=1724913284; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FbcRmtSixN+nqgeio5cffFu+JG8NdhUCcxs6H+/cTBA=;
        b=g9PSf8ExeLrUKCqQ+AqqUfh25uGI1HwFHhDbOz1Dx6/IR//SH/NskHaQCiE3LatCbX
         UKqDGBvTC9SbQfvH/UBsGir0juHRuXEmtRPjOXa6Xuvx0Jl9oVNpWNRZqexjK4/9mAyf
         6uuxLGWU07qCBsWNHRv9gpgjm5d3dsCeTYWz+w4UiA0QRd3YCxZaliT0xHJ3K6HQ1O0J
         k0xMnDiAzjGDDNtoynXyZgluj0FsxZ8xj/vvEnW+E3MnfZJ8HibfNtlPAl5BzTFYwtTy
         Il4NhhJCJD8Y1bX7ZcYrscDXxv0trhIbarKfP1gtstG0kmQFoEiY4tgBLH71VOJxK12Z
         muyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724308484; x=1724913284;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FbcRmtSixN+nqgeio5cffFu+JG8NdhUCcxs6H+/cTBA=;
        b=fgaxaTN0Bpwa0Rfs0kM0KGtzebyQGDZQbfzluuTd6I6QxQrNrOcf2EAnt6J18NpPVt
         8f6nh5yNY82HHnOhWBexiBaQelAmWQr10Upz6VCJHxlxuyoinfxfpiTyft0SFWssOM6a
         +W9prz/x34c/hrGHojfKHEvW7FeRbqd9f1r7YUUZo8JgFGALIaW4ztApAHL+gkLP/Clm
         Sp+kMj3DJMEFb0h4cY76NDYBbbHRrEHqMLGppdD6N8QlfiT0uxirnXW4h7uqn0Or8GMN
         sNf6d8nuSNr4975UmxnBAWhr7pYoHFq5W28lvU7PyLHV0REdfMNen6hqmzPe6W9hBkXS
         QPcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQUlv3IdqH00WNNJlQmH0n34L8+FP3aS5OOV8xuahGPpnFRjwyA6k23z5yeEHeSTcgoZ169l/kf+FzgA==@vger.kernel.org, AJvYcCVg7fLt7RbRCZV4ETG6IkgrPTULOSse47JGCcMuGan4AvUBxgImCxIL0fbr71kahI5Xbq6O+Ukz5Wlt+ZY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyb17Td2I3j2X1bS87Cn+5+IqsSMoM/WC5rjGZ9QatsC5x6JFbW
	LFYLXRcRI+TNslVaItyoVyZ1ggc9AkSkRXlsoLM7ti7mbqr3ra3r
X-Google-Smtp-Source: AGHT+IGt7LaehWmZirQr93jbtjm3KkpbMWcvY6306p8gGKPTEOiLokWFzIdDPH5vKvOtRnlZ+nuQLw==
X-Received: by 2002:a05:6830:6401:b0:709:3df3:7ed8 with SMTP id 46e09a7af769-70e046eed76mr1238430a34.13.1724308483935;
        Wed, 21 Aug 2024 23:34:43 -0700 (PDT)
Received: from thinkpad ([117.213.99.42])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7cd9ac9827bsm542807a12.1.2024.08.21.23.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 23:34:43 -0700 (PDT)
Date: Thu, 22 Aug 2024 12:04:36 +0530
From: Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>
To: Mary Guillemard <mary@mary.zone>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org, Peter Wang <peter.wang@mediatek.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH 1/1] scsi: ufs-mediatek: Add UFSHCD_QUIRK_BROKEN_LSDBS_CAP
Message-ID: <20240822063436.nvll5cw3ifwonshz@thinkpad>
References: <20240818222442.44990-2-mary@mary.zone>
 <20240818222442.44990-3-mary@mary.zone>
 <20240819120852.tdxlebj7pjcxjbou@thinkpad>
 <ZsOJKMg8xlpdgoi5@kuroko.kudu-justice.ts.net>
 <20240820060946.ktiysu7sn7qgbwx4@thinkpad>
 <223cc3ca-9214-4ba1-a3c8-2d672aef52f9@acm.org>
 <ZsZc1jYL8wSZZYSw@kuroko.kudu-justice.ts.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZsZc1jYL8wSZZYSw@kuroko.kudu-justice.ts.net>

On Wed, Aug 21, 2024 at 11:32:06PM +0200, Mary Guillemard wrote:
> On Tue, Aug 20, 2024 at 02:50:58PM -0700, Bart Van Assche wrote:
> > On 8/19/24 11:09 PM, Manivannan Sadhasivam wrote:
> > > On Mon, Aug 19, 2024 at 08:17:10PM +0200, Mary Guillemard wrote:
> > > > On Mon, Aug 19, 2024 at 05:38:52PM +0530, Manivannan Sadhasivam wrote:
> > > > > On Mon, Aug 19, 2024 at 12:24:42AM +0200, Mary Guillemard wrote:
> > > > > > +	if (host->caps & UFS_MTK_CAP_DISABLE_MCQ)
> > > > > 
> > > > > How can this be the deciding factor? You said above that the issue is with
> > > > > MT8183 SoC. So why not just use the quirk only for that platform?
> > > > 
> > > > So my current assumption is that it also affect other Mediatek SoCs
> > > > that are also based on UFS 2.1 spec but I cannot check this.
> > > > 
> > > > Instead, we know that if MCQ isn't supported, we must fallback to LSDB
> > > > as there is no other ways to drive the device.
> > > > 
> > > > UFS_MTK_CAP_DISABLE_MCQ (mediatek,ufs-disable-mcq) being unused upstream,
> > > > I think that's an acceptable fix.
> > > > 
> > > 
> > > If you use this quirk, then you need to use the corresponding DT property. But
> > > using the 'mediatek,ufs-disable-mcq' property for 2.1 controller doesn't make
> > > sense as MCQ is for controllers >= 4.0.
> > > 
> > > > Another way to handle this would be to add a new dt property and add it
> > > > to ufs_mtk_host_caps but I feel that my approach should be enough.
> > > > 
> > > 
> > > No need to add a DT property. Just use the SoC specific compatible as I did for
> > > SM8550 SoC.
> > 
> > Mary, do you plan to implement Manivannan's feedback?
> > 
> > Thanks,
> > 
> > Bart.
> >
> 
> Hello Bart,
> 
> I think that considering Peter's reply, explicitly checking for the
> MT8183 controller isn't required.
> 
> I also think it could be required for at least the MT8192 and MT8195
> considering they are apparently also based on UFS 2.1 spec [1].
> 

How can you add a quirk that is specifically meant for 4.x controllers to 2.1
controllers? It doesn't make sense.

Also it is weird that the existing DT files doesn't have ufshc nodes for any
SoCs, but the SoCs are supporting UFSHC.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
