Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7FF333ABA;
	Wed, 17 Sep 2025 13:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758116873; cv=none; b=F1Q34DSyO+cLpRtLlBDyRlGLFVFYF1DQTzVobz3kG6OOBukH51XzWPXoQGDDsD+ZikCtpavtYDrch7sPc5Yijodr6CGakf/Bl5k0hKLoX8LE5ldpAHq75n6QFRIcbm4BUSoEFJzCyj1/Xd75ZMTC+eqFtDLyyUniVokMODD2Zmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758116873; c=relaxed/simple;
	bh=jZSzNlUuc8Z2dtrmiTT3GveGuPVXBoj/0tsecpRw3lw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kG0DeZtbt4EhFQmlgiFDqXv1Vkcwy/tSkOEDt4PAE7F4ccIlzVoWPkBKl1K85d3x8QpIPw2ggFqCO0nflHb/dEov3uq2giB7YULWYDSEHce+b1Y7RJObMoXCZoJ3HQexXNdU/hO0mESifOtdJ3ze/A6Y9ESgIyWhWzUBGC/xrNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=qGKnB4su; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=SoCmQj0y; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="qGKnB4su";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="SoCmQj0y"
Received: from mta-03.yadro.com (localhost [127.0.0.1])
	by mta-03.yadro.com (Postfix) with ESMTP id CE36DE000A;
	Wed, 17 Sep 2025 16:47:47 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com CE36DE000A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-02;
	t=1758116867; bh=kd1J20Tde57lx9zkiBL6+lF6PZF4T3VQJplX7mkDORw=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=qGKnB4suAkqmz3u6e6nlKZZJb8w1OPKyqDi0HxUs+aRBSalY1DEqYxCfKZKAm1CQW
	 meBW1E0khdEaoQVZguh1d3kCZXsXIRW2gFuc5gUkJR8dtLe2MgmuegihyWtcZF2+Xd
	 6K8wnpK9kdfEvp6iChPTL++8OnrbvHZJgE/L9AuIOw3YL26oFntxBn4OSXF3lq7eJB
	 hWKHpc4ZTDgtYF9BZGgB2nZKchJMZzCL7EtizOvQE4zYGEXEfqx53nmB9Zm4kRjhgJ
	 fImhkbxS6hukCuD06khZRN3gNXL1djLe+iD+dbOvN5kevqdv0LoEfTUttWtpg+6n4j
	 Y7KZOKxjgS69g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1758116867; bh=kd1J20Tde57lx9zkiBL6+lF6PZF4T3VQJplX7mkDORw=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=SoCmQj0yHruV/0jECnxKfn707iuGwV6RiAEe2zwknW3tX8KY8PwuKAD8euLDmDL87
	 v9qU4j3N7kqruaf9ljjty7LSXVtlfTyAdZIY1G+bDWdquN/t0Io/EhBs2D/QLMCfS3
	 SnN7FsCXjnqo8/heEzOY1d6iKkcwydu1JL+EEEjRvJ8Qv4OMrXOD526tSnvKe5wyWI
	 haq1/QTIjokxRBVdxYe9G6Xv/O/7xHF0g4VnSGzpyMMEyd4DE/3YMXv/8tQ/dznjtF
	 pJOne4JEKqhGXwB+xuh5EwQUda7dz5lPSknXVkFH/Q/NqNZoLD+yxy7Ta6tRuwDWfm
	 HOrD0qZaOdcJw==
Received: from T-EXCH-10.corp.yadro.com (T-EXCH-10.corp.yadro.com [10.34.9.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mta-03.yadro.com (Postfix) with ESMTPS;
	Wed, 17 Sep 2025 16:47:46 +0300 (MSK)
Received: from T-EXCH-12.corp.yadro.com (10.34.9.214) by
 T-EXCH-10.corp.yadro.com (10.34.9.212) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.9; Wed, 17 Sep 2025 16:47:46 +0300
Received: from yadro.com (172.17.34.55) by T-EXCH-12.corp.yadro.com
 (10.34.9.214) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Wed, 17 Sep
 2025 16:47:45 +0300
Date: Wed, 17 Sep 2025 16:47:45 +0300
From: Dmitry Bogdanov <d.bogdanov@yadro.com>
To: Mike Christie <michael.christie@oracle.com>
CC: <bvanassche@acm.org>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] scsi: target: Fix lun/device R/W and total
 command stats
Message-ID: <20250917134745.GG624@yadro.com>
References: <20250908231000.10777-1-michael.christie@oracle.com>
 <20250908231000.10777-2-michael.christie@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250908231000.10777-2-michael.christie@oracle.com>
X-ClientProxiedBy: RTM-EXCH-06.corp.yadro.com (10.34.9.206) To
 T-EXCH-12.corp.yadro.com (10.34.9.214)
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2025/09/17 12:43:00 #27827050
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-KATA-Status: Not Scanned
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 5

On Mon, Sep 08, 2025 at 06:05:54PM -0500, Mike Christie wrote:
> In
> 
> commit 9cf2317b795d ("scsi: target: Move I/O path stats to per CPU")
> 
> I saw we sometimes use %u and also misread the spec. As a result I
> thought all the stats were supposed to be 32 bit only. However, for
> the majority of cases we support currently, the spec specifies u64 bit
> stats. This patch converts the stats changed in the commit above to
> u64.
> 
> Fixes: 9cf2317b795d ("scsi: target: Move I/O path stats to per CPU")
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---

Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
