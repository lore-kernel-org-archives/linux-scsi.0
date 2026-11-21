Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795229767;
	b=s25X1xFvj2D6HusJtpz6JNDNZ6amn4dufUQzzUlCuR4t2kFsMHjKsOJgU5804oeMqF2N
	 2rX6R7tr/e+t7+I41tYDQ/ylrJ8cmZ9QYhZDn829gYm2rq7bbkfEzrT/C2SjXtgAMRrgS
	 9atLIRiTKVvn81l0QvHkzHj6noOWxBReW3Qg8/YXYYCxh1el7rayPXMnn8JdR9RC3Xvom
	 jB1IWAOXsuJaKAuVfS1ayQRSd4VmnHtLVX94fbemJvyoNSQ8j5DFdFUipfm4dpOPGpKey
	 9H1R9rXZKLlQ1BVssi5XH5f/Lo0X4W51RXOoFuXV9VhRqo8ZgUzyPF9sVjLx0km+3WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795229767;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=sJoVwgXsrrvrc+yBOoDx/gllMAlzga1+5crKtB43PgY=;
	b=SFAbugOzXnSYyMJkwEvE7TEl5OLCn91xk+WKlRULQjB/Kza7Ycy7i4G9F3XIPHngbGV+
	 fDTmfac0jGj1HMjw7nCQ2DD+fQznjiZMY0RB5KfPEMVZ4RtLfIsLcGLhEmOiDa2aGNsX+
	 FxKsD6FRssICcpRXwM8ZBgiURP9xuPD77VILRuDB3d507149ACColx92R0gHTGYaTJweJ
	 vYr+bgZHULPVlI6FRWHrw4ZSGaeUM8dK4SATaLFD4gDzVP2/xoY1NpN/DI+S5OvlabCL3
	 R3oBQuxEd3QdSw4P/M233H5bW5E3rm7iBZCJ/jA3mv3r4Wbg+gWFvEWg4N07vJZEVag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KtwPvGF5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB47B606A699;
	Sat, 21 Nov 2026 02:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KtwPvGF5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439AD1F000C0;
	Sat, 21 Nov 2026 02:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795229767;
	bh=sJoVwgXsrrvrc+yBOoDx/gllMAlzga1+5crKtB43PgY=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=KtwPvGF5JpDX4biBU3cN2pjK5RnB4j8gB9IJsAxUgn4lfhMFs6DHxnoG9GAseeekJ
	 0mshuxZj5Yf/oxIakE39ovHWXBSFiwVrRSDX6/UuBazcC5PHeb7dPfM9rjJnVBf7uz
	 Oi9KwnYHPbXnOuBtoOZYi9Xjt6+TUlApiokKTTUCncrTCIMSv2VTdzl+2+ZZqd60T/
	 JnNz5rU4z1NVYEuKz5NQH9eMWt94PBo5rRPa/EzCn0pbfzrVcubmtn9TwERPrf27Lu
	 108ycBUvfvrd+h5bQlv9DM9ggn1HKiJGcFCc3gchofhbwuSHwo/guOzyFicbjVbV2k
	 OCMPAnFXnqyYQ==
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>,  linux-block@vger.kernel.org,  Christoph
 Hellwig <hch@lst.de>,  linux-scsi@vger.kernel.org,  "Martin K . Petersen"
 <martin.petersen@oracle.com>
Subject: Re: [PATCH v13 12/13] scsi: sd_zbc: define storage element
 management operations
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261120210651.580511-13-dlemoal@kernel.org>
Message-ID: <yq1jym6nb9k.fsf@mail.kernel.org>
References: <20261120210651.580511-1-dlemoal@kernel.org>
	<20261120210651.580511-13-dlemoal@kernel.org>
Date: Fri, 20 Nov 2026 21:56:06 -0500
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain


Damien,

> Define the storage element management operations using struct
> blk_se_ops. These operations are valid only on SMR disks supporting
> the storage element depopulation featu, with support for the GET
> PHYSICAL ELEMENTS STATUS command being mandatory. The support for the
> modify_zones operation is already indicated by the
> depop_modify_zones_supported SCSI disk flag.
> sd_zbc_check_depop_supported() is modified to add detection for the
> command RESTORE ELEMENTS AND REBUILD, which is indicated with the new
> SCSI disk flag depop_restore_supported.

Reviewed-by: Martin K. Petersen <mkp@kernel.org>

-- 
Martin K. Petersen
