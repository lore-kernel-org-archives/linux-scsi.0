Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5113812D766;
	Tue, 20 Aug 2024 06:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724134204; cv=none; b=mz8Jc6ZZ35VkyANihVylsooo6jnodbY3J2cRbFldbcmaGlj/dYSM0AZ+DG3t3v0ql3fspFg/zMyHHo2DNgGUymNlZQxpb1HLA/KT2dguqXEZTHZtQpmnrkhtiyXxx8fo8htAZGnWpe4PHxYzO+5YtDjx7/PETEgAzOtBbT1Md+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724134204; c=relaxed/simple;
	bh=WJI7sVIJQhNZEjGBipyfPnKHBQ2Q78zgewTe06ZwqXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pTN308uXrhoWCIH3lMBnC2jZiU9ip54hkWoVFrUcF9MAQXIjXpTgZOqDsK/Qi2KG8Owc+/N+764x+aU61eKSTTydVtL3pq6b4QMDmw0zWFfpfaH4YKoazaA0KqsvX5JLkPp1d1e9fnuU074hqwwOPCmKCKm9ya4QXkfHmVmhjvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WlHa111y; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WlHa111y"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-202146e9538so29681675ad.3;
        Mon, 19 Aug 2024 23:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724134203; x=1724739003; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TsLtowXZtvBXAdBdupLzzv6GRZHgGPkMeVDrjZTrM7k=;
        b=WlHa111ypLLQPCRzu/N6TvBS3bzCDpAiUfYcp38PbIeI3VXWkhhc16+LeIGwNtCwla
         xvj8pARi5QIIh6bZzgs0WgnHl/+lsOOIqcw28oBu5p45GtlJYfA1og/tTW3AlUeuJ2eJ
         GGZqco09xyXNSeJPWfulXuc8UygYaQWsBEkrEPA8rbSQKXkKqo3F2Mjqup9c4RIB3al8
         jSPFa2cXoxpleOo/Nwm5GEZj6h/4YsVj3q7q08kW5GL45TfWwF1wIKbKmCRkFxemY2mJ
         HxOjRuHLjbtQoRR80Op8VYSK+Zo0j+yAHZJwqcSV3R56JBSk2YhFptLWapJqRlF0hOTz
         nb0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724134203; x=1724739003;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TsLtowXZtvBXAdBdupLzzv6GRZHgGPkMeVDrjZTrM7k=;
        b=g0f2vU2aoU8IorrL5z0R/ZIVTesbNfEuWo/LO/yyhVfFIpeiMZeTYq5bc+1b6P1/Ec
         7++TT9axEYCm6LBRInpxWGBSJQ0lDOamFAtpkFySEVbprMI8emktfNwyASWMiBadIwSA
         a4rmHfLUq6wMzEznCIz6lI39ixy5c/maidUMOqVx70umpHYGXzY/4FWQirXCmYhhE051
         XcJPEq4nDI0d8GGXfW0KdmuoIw3Y8opNypi6v7ENuOZzMjaTmmN59q+1v4TsvB9ds8wb
         LBvxqWqoK6t06vLppDgvn0idKBRNBOemq0irFHWqhU05si+fEk+amddT9lu4GvbFg+XQ
         ZjvA==
X-Forwarded-Encrypted: i=1; AJvYcCUfu8sfxRSatBXoNkwwCFAu5x0gwJ9ZJrwMw/Jhlx0HqZEeJJaFh9HYZzsDHMUYLO20LLio8eBjlxfM@vger.kernel.org
X-Gm-Message-State: AOJu0Yxr5hGgHieZghtzifjx7KXtpLbDtssbI6Cu0B8SZLzfOakhEXzH
	NC5UDdHiVcR9SJZI8C4SkxB/sjrIN/DzmJrIitYSj+lPqdeQ4y0w
X-Google-Smtp-Source: AGHT+IHYbocImC6WHcuJ9AmtcgfITws7HCvxLrGAl8Tjpv1JI7Ge2IcET1DX6wOznPbblA5mjw/l/g==
X-Received: by 2002:a17:902:ecd2:b0:1fa:2e45:bcb8 with SMTP id d9443c01a7336-20203e503a1mr145500205ad.2.1724134202568;
        Mon, 19 Aug 2024 23:10:02 -0700 (PDT)
Received: from thinkpad ([120.60.128.138])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f0378952sm71308755ad.133.2024.08.19.23.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2024 23:10:02 -0700 (PDT)
Date: Tue, 20 Aug 2024 11:39:46 +0530
From: Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>
To: Mary Guillemard <mary@mary.zone>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	Peter Wang <peter.wang@mediatek.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH 1/1] scsi: ufs-mediatek: Add UFSHCD_QUIRK_BROKEN_LSDBS_CAP
Message-ID: <20240820060946.ktiysu7sn7qgbwx4@thinkpad>
References: <20240818222442.44990-2-mary@mary.zone>
 <20240818222442.44990-3-mary@mary.zone>
 <20240819120852.tdxlebj7pjcxjbou@thinkpad>
 <ZsOJKMg8xlpdgoi5@kuroko.kudu-justice.ts.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZsOJKMg8xlpdgoi5@kuroko.kudu-justice.ts.net>

On Mon, Aug 19, 2024 at 08:17:10PM +0200, Mary Guillemard wrote:
> On Mon, Aug 19, 2024 at 05:38:52PM +0530, Manivannan Sadhasivam wrote:
> > On Mon, Aug 19, 2024 at 12:24:42AM +0200, Mary Guillemard wrote:
> > > MT8183 supports UFSHCI 2.1 spec, but report a bogus value of 1 in the
> > > reserved part for the Legacy Single Doorbell Support (LSDBS) capability.
> > > 
> > 
> > Wow... I never thought that this quirk will be used outside of Qcom SoCs...
> >
> 
> Yeah I found that by trial and error some weeks ago and noticed your
> serie while looking to upstream this change, quite funny to see other
> vendors having the same quirk here.
>  
> > > This set UFSHCD_QUIRK_BROKEN_LSDBS_CAP when MCQ support is explicitly
> > > disabled, allowing the device to be properly registered.
> > > 
> > > Signed-off-by: Mary Guillemard <mary@mary.zone>
> > > ---
> > >  drivers/ufs/host/ufs-mediatek.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
> > > index 02c9064284e1..9a5919434c4e 100644
> > > --- a/drivers/ufs/host/ufs-mediatek.c
> > > +++ b/drivers/ufs/host/ufs-mediatek.c
> > > @@ -1026,6 +1026,9 @@ static int ufs_mtk_init(struct ufs_hba *hba)
> > >  	if (host->caps & UFS_MTK_CAP_DISABLE_AH8)
> > >  		hba->caps |= UFSHCD_CAP_HIBERN8_WITH_CLK_GATING;
> > >  
> > > +	if (host->caps & UFS_MTK_CAP_DISABLE_MCQ)
> > 
> > How can this be the deciding factor? You said above that the issue is with
> > MT8183 SoC. So why not just use the quirk only for that platform?
> > 
> > - Mani
> >
> 
> So my current assumption is that it also affect other Mediatek SoCs
> that are also based on UFS 2.1 spec but I cannot check this.
> 
> Instead, we know that if MCQ isn't supported, we must fallback to LSDB
> as there is no other ways to drive the device.
> 
> UFS_MTK_CAP_DISABLE_MCQ (mediatek,ufs-disable-mcq) being unused upstream,
> I think that's an acceptable fix.
> 

If you use this quirk, then you need to use the corresponding DT property. But
using the 'mediatek,ufs-disable-mcq' property for 2.1 controller doesn't make
sense as MCQ is for controllers >= 4.0.

> Another way to handle this would be to add a new dt property and add it
> to ufs_mtk_host_caps but I feel that my approach should be enough. 
> 

No need to add a DT property. Just use the SoC specific compatible as I did for
SM8550 SoC.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
