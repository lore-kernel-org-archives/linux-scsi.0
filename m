Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5611C3BB2E;
	Sun, 11 Aug 2024 13:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723381348; cv=none; b=bA06TLrwiS7Gs+WbzmQq2Pqpol8purtQ0S0Pj3cZL/p2O5REQ5MJfOSQoqVUkCc4Ru1NxrhUhDlJllvxuIpgtKnE8TKGk15XcAmYd7noRPc5LLk/y62bzH8vbMEI0to5a3jJihBBphYdTpDX5ttNtgfzXZv33Kgu3/J9cz0nz4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723381348; c=relaxed/simple;
	bh=Ee/+nHBgnQ0CY8edfzOVeBRHRbvMRW8ICejirhXTb6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tUfQ+ix9PO6/6RbGI1uL3ciKoRPo0Nbf6Szo4bfePZDKauEjqmMG/lSBH+5b0A82ItEBwwXQ08IhC4H5Cm9lY93PRHFrj+AhDetF0z5FiWaFjtFzXvRBDElHxDou4UO7K6BgFeWol7pEddBEtbxRhllpUM5LUfiHBoCev6VmDdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q53Hn8WO; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q53Hn8WO"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2cb4c4de4cbso2304085a91.1;
        Sun, 11 Aug 2024 06:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723381346; x=1723986146; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7/ZpdylMh5y7iw6PY+7suE8ZjKzS9h9fFvMhqx1MkEA=;
        b=Q53Hn8WOFMhjFLpDYghOYIiZqDlEB493PQA2KTe32naGwpMAWhVgk4yfRy3dCAPfOC
         prcncJbdwI7jIPHE/uE0vyacB2IXlurTmj9FLvryAqtjdTnv8llnhZ0Px+6GhH4UyKub
         JqqAodG+A/LvTKD5I+7NdUGvjhzhfJO1WeRnis7MA7Yjy6jurX+7ZCDlrVghd2AQFQR3
         Dlvxj6SFAWj+G9nuosYlBPlNg1vp07T2dytNtYsk/kvyc8AL/ae0/4CwzryKVwEjpgzu
         hDlY+7wRbCRvWJacQqUFzORjMFiFm76oteX3jTuepSJGOX+TU/A8tN+2d57s/C9Z5NSz
         AYaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723381346; x=1723986146;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7/ZpdylMh5y7iw6PY+7suE8ZjKzS9h9fFvMhqx1MkEA=;
        b=oYs/UHZsrNAibXWW6T8kNn/cgLwqPeVmznmAVuJ/17AcENxAio2BzI9uqSVGN1jJy7
         tLjpCDRMUyV3mOL26MvTJ4us7GeuL9nPWR2EepafNIFCOmkEqEEXZlAFgovZ7DTADRT+
         90ZrImo9GeALdbEWBlDnCm0QR5IT4VIkHLvgOw9oT+LwOu1+6DUc/zsoZ4IcmhfakaZI
         YFYCMOtyCtSUGmIHNNaglWv4ePwSCmtj2GLXzAW+ynDp6FVroCA6Sd/l2UtcUSFrdn6s
         oZSpn7NDqCXJmVLCqK+aC9SZzVsWuZKO/yJZ1lEITLLa4D9DX+mCOhUh9M1IJRU4bVvd
         S78g==
X-Forwarded-Encrypted: i=1; AJvYcCWCpEjj/1FAjToxMDi/SuWo/YAlw+aCx33bzeO6SE7YliH6hhRuY7uv5YaIHpzv1m72+6Hm0BeTPRYJDCRF8R5laRbVZ8BAJ2wNZzwPUzDGOJ+G68xNI4O8EIcLdUQM5Taqqps6EJD3FA==
X-Gm-Message-State: AOJu0Yy8cKnIV67kOmgM0zX7O73fv/ebSy+dIJJVLxmjgcoeDtpmCOhE
	42j+1G19CUEpJgt3zWwPBVE6/Zt1zB1UnL1CQQnnnUXQO7PvELBE
X-Google-Smtp-Source: AGHT+IFw3WmAmM0HWKVmo2TC/Y1FOV+raetLMbeq76kNmBX/sstKdKvg4/qodKn2UYFsvJPhcSnfNw==
X-Received: by 2002:a17:90b:4a42:b0:2c8:a8f:c97 with SMTP id 98e67ed59e1d1-2d1e8078a15mr5347217a91.37.1723381346348;
        Sun, 11 Aug 2024 06:02:26 -0700 (PDT)
Received: from thinkpad ([103.244.168.26])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d1c9c7b479sm6291992a91.12.2024.08.11.06.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Aug 2024 06:02:26 -0700 (PDT)
Date: Sun, 11 Aug 2024 18:32:21 +0530
From: Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>
To: Avri Altman <Avri.Altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Keoseong Park <keosung.park@samsung.com>
Subject: Re: [PATCH v3 2/2] scsi: ufs: Add HCI capabilities sysfs group
Message-ID: <20240811130221.GA2809@thinkpad>
References: <20240809072331.2483196-1-avri.altman@wdc.com>
 <20240809072331.2483196-3-avri.altman@wdc.com>
 <20240809075522.GA9360@thinkpad>
 <DM6PR04MB65751DE4930E7198279F6FE6FC842@DM6PR04MB6575.namprd04.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DM6PR04MB65751DE4930E7198279F6FE6FC842@DM6PR04MB6575.namprd04.prod.outlook.com>

On Sun, Aug 11, 2024 at 06:19:49AM +0000, Avri Altman wrote:
> > On Fri, Aug 09, 2024 at 10:23:31AM +0300, Avri Altman wrote:
> > > The standard register map of UFSHCI is comprised of several groups.
> > > The first group (starting from offset 0x00), is the host capabilities group.
> > > It contains some interesting information, that otherwise is not
> > > available, e.g. the UFS version of the platform etc.
> > >
> > > Reviewed-by: Keoseong Park <keosung.park@samsung.com>
> > > Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> > > Signed-off-by: Avri Altman <avri.altman@wdc.com>
> > > ---
> > >  Documentation/ABI/testing/sysfs-driver-ufs | 42 ++++++++++
> > >  drivers/ufs/core/ufs-sysfs.c               | 95 ++++++++++++++++++++++
> > >  2 files changed, 137 insertions(+)
> > >
> > > diff --git a/Documentation/ABI/testing/sysfs-driver-ufs
> > > b/Documentation/ABI/testing/sysfs-driver-ufs
> > > index fe943ce76c60..b6e0c3b806fd 100644
> > > --- a/Documentation/ABI/testing/sysfs-driver-ufs
> > > +++ b/Documentation/ABI/testing/sysfs-driver-ufs
> > > @@ -1532,3 +1532,45 @@ Contact:       Bean Huo <beanhuo@micron.com>
> > >  Description:
> > >               rtc_update_ms indicates how often the host should synchronize or
> > update the
> > >               UFS RTC. If set to 0, this will disable UFS RTC periodic update.
> > > +
> > > +What:                /sys/devices/platform/.../ufshci_capabilities/capabilities
> > > +Date:                August 2024
> > > +Contact:     Avri Altman <avri.altman@wdc.com>
> > > +Description:
> > > +             Host Capabilities register group: host controller capabilities register.
> > > +             Symbol - CAP.  Offset: 0x00 - 0x03.
> > 
> > This doesn't look like an ABI description. You are merely specifying the register
> > name and offset that gets accessed while reading this attribute.
> > 
> > Also, I'm not sure if we really want to expose HCI/MCQ capabilities as sysfs ABI.
> Why not?

sysfs is an userspace ABI. The information that is exposed is supposed to be
consumed by the sysadmins/userspace applications.

Looking at the contents of the capabilities, I don't think anyone could
interpret what is being exposed unless they have access to the spec (which is
not free).

> Like the cover letter say, this info is otherwise unavailable.

There are other ways to expose this information too, like debugfs. But what
exactly do you want users to do with it?

- Mani

-- 
மணிவண்ணன் சதாசிவம்
