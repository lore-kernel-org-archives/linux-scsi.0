Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB66E1CB33B;
	Thu, 22 Aug 2024 15:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724341351; cv=none; b=OZb+X6A/gO8CRTCmUd0mx2VQ5KSYdPl7AfsGfVyDBcAfuiFOkTtuXNs4IpNQgvt0IM8htX3DK7ZfcT07pwKpFjm1YpTXsyYRePNYA9Jp2z7F2ijjt/RVLGHXK/mS1oVPI2zx0LT3RAUQUj9UwSTZz/eY6JC8zcLQZP3ic7t/PxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724341351; c=relaxed/simple;
	bh=srQv0vhfpJ7TuVF5UATQEzYC7ABOs0mfT8jGWJNhfog=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CZYSqIXUO/Xcq1LGXULqwF4HrkT7kTJnaaLT9ODs5qL5zCVW2bwsXfwf06eYhYKJWOFl0/9lkXC+PyItt5VpZ6RaSnq5w8ABFHgV1CyKhS2Rzf9wqZTYPVDyNulS7vOyOb+AOQjvXbuRoYIFoWg4wUeeP0GWLos1+WEaxCM3SYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e6EzmFV2; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e6EzmFV2"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2f4f2868783so964641fa.2;
        Thu, 22 Aug 2024 08:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724341348; x=1724946148; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KKuRHz3dN9ycQVjAWBxa5fGvRl8U6lvrA2n927jgmHQ=;
        b=e6EzmFV2U6Sb7n4Hg+YCdXqBdPVILXVrtuhWqJjH76W5Qg8Ds2YxbsqlIGUVGBFJWH
         nzIWdJgKNX9FmoGTFNd1/JCA6bNU0Zia+rjZY9ciKSBqi9+8NWzkx8VdgldakRQuEWaN
         dhdFqZmYiuNvu450SBOFeEXbIuRtZNeqZk0GJDvhLXF8dbUgqZmAibf3Zu78jzx9s+GV
         GGKedTYPfm1TzTQhObVD4Djwx5dVlh1up0g6b5x8Dt3LZXPnXVWHitysNn1aRo6cZ/QW
         jck1MduAHzDW3xN0gWHI1KXj2ZPZzUbczSBg4hRZ2Kgr4k1njBkAWGvRc4OlzNEBDS56
         8seQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724341348; x=1724946148;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KKuRHz3dN9ycQVjAWBxa5fGvRl8U6lvrA2n927jgmHQ=;
        b=NdJbGmRvv9iHGGoxvqsmWKmS0M68IizQin09p2akd0WIsE1ozI2/88wRxlz1rsm5U3
         BqxaWZAIe0W/F7sW+HiauatKH0CnVyg9IO763henTtXjgs0Mx+6b34VlMknAXW/EIQVH
         cw+/yaKypG+J8z23v6ZjEcRvSZd9iL+N18/xZnkRQSroB2iKv6W+/Mz0oISRbt7Psgdv
         KwEhu80YgcMyPjplkOqssJhzUY8XEDGomDstSwRjg3z/XxZT8sCt1d/sbMH47Inhwft/
         0MdfmayZzxDmYWZNcEQLISWhYuRKF3aQXFbYIE/8kw8PXu54fUr26Uf7Uswm1SZo+HZY
         Ws7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVbWVMO7zaJDW1O4bc7qontmzlXsOSoLgXBT95zK9+R6iZnWlpvdpxx8AemoePwMGPBFhiXYqIL6UoIYXM=@vger.kernel.org, AJvYcCVbs6YEg4Qa01UMzXhJ34X7dE58w5K9eY5k3EZ3cdBLwvEVwyjeL4rbXUB3eSB4ukxqlh1YJ7oiy3Nx3A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyO/MKzxVae63+0xk3TtKYyn5LXvJuL1gMdarv8i0aubmYLW3tB
	v8g2xy1bnf6LZWBtgWVGUAEbBMefnyR54Ljt/ZwhPbg9bvJqRoct
X-Google-Smtp-Source: AGHT+IHbrtS+R0RFzaXyAy2XKC8PLf3HwKp357wuUBM0qJBbr8MasTdsFXLPMzhkZ7GcbK3rwCcqoQ==
X-Received: by 2002:a2e:8781:0:b0:2f3:e795:3e6f with SMTP id 38308e7fff4ca-2f3f8953568mr35059981fa.45.1724341347345;
        Thu, 22 Aug 2024 08:42:27 -0700 (PDT)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c04a3cbdeasm1050253a12.33.2024.08.22.08.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2024 08:42:26 -0700 (PDT)
Message-ID: <04306da77d74e16edab1d682a8602f61b35025a3.camel@gmail.com>
Subject: Re: [PATCH v2 0/2] scsi: ufs: introduce a callback to override OCS
 value
From: Bean Huo <huobean@gmail.com>
To: Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
  bvanassche@acm.org, jejb@linux.ibm.com, martin.petersen@oracle.com, 
 beanhuo@micron.com, adrian.hunter@intel.com, h10.kim@samsung.com, 
 hy50.seo@samsung.com, sh425.lee@samsung.com, kwangwon.min@samsung.com, 
 junwoo80.lee@samsung.com, wkon.kim@samsung.com
Date: Thu, 22 Aug 2024 17:42:25 +0200
In-Reply-To: <cover.1724325280.git.kwmad.kim@samsung.com>
References: 
	<CGME20240822111247epcas2p2d3051255f42af05fd049b7247c395da4@epcas2p2.samsung.com>
	 <cover.1724325280.git.kwmad.kim@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2024-08-22 at 20:15 +0900, Kiwoong Kim wrote:
> Kiwoong Kim (2):
> =C2=A0 scsi: ufs: core: introduce override_cqe_ocs
> =C2=A0 scsi: ufs: ufs-exynos: implement override_cqe_ocs


Hi Kiwoong Kim,

I didn't see your patch email,just post your second patch here, and
provide my comments:

=20
+static enum utp_ocs exynos_ufs_override_cqe_ocs(enum utp_ocs ocs)
+{
+	if (ocs =3D=3D OCS_ABORTED)
+		ocs =3D OCS_INVALID_COMMAND_STATUS;
+	return ocs;
+}


I wonder if you have considered the case where the command is aborted
by the host software or by the device itself?

If you change OCS to OCS_INVALID_COMMAND_STATUS, there will report a
DID_REQUEUE to SCSI.


Kind regards,
Bean
