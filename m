Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6382FBDFF;
	Wed, 17 Sep 2025 13:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758116040; cv=none; b=Kqf7XHmTPUQhxHQiDqzqGvncgAEL1M1jdVodBBuvXb+2Hg3J/ry9cjJtESORerxU0pSjlBJrkmTaNtY+SWLpoP67/bPK7rBPCm2W8t4/yygntuWX8fCEsnGph42necAWOghw7OCzRLq7Wa4PxZtVxxdqD7SoKopGnkyXTCR7s2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758116040; c=relaxed/simple;
	bh=Yla9o2ix5cjGKSQvLc6HUJjmiFT+WBiQqRqVfjM/Sg8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ALAMlybKCGowGJPo4VdQTD0QFxSgqfGAXZ6EHP9+SlRDx96sHE0P28i7tUU7s1LLlQxaR60U2KPfXhEW/7NptfGKh4OplneD0agoL5V651JqBTxkXglVV4JenfR4ADre5FeHmZ0CPpBTVqrr2sBpMqRR8EOsyoj+ubnrur+hkv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=eDoD1r5+; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=cD/nqtxB; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="eDoD1r5+";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="cD/nqtxB"
Received: from mta-03.yadro.com (localhost [127.0.0.1])
	by mta-03.yadro.com (Postfix) with ESMTP id E733AE0009;
	Wed, 17 Sep 2025 16:33:53 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com E733AE0009
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-02;
	t=1758116033; bh=H1BrXnKDcj43c+KdmykPcdh/94m2CUp+zEOKlLrNdVs=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=eDoD1r5+/GSUjCd3AOlDyztxtPjON0OKQkd3JF4eGpCMW2LwLyy/UehEe6jkyoaUn
	 nox0C8QyUuUoEKZipRRJSTGUVM7WbxPx3l6hMqFSjaxTCVbF94snOPOvW1z1FQwsTX
	 72sBeAmm9RorfISjeympLNES1EVFpQ8Go18/2OsGeS1ibAikWCvBo+OyE5LRL8Tnc2
	 liGeHneuSZxuTzZ3cu45C7qx3mXfWer1AkgvRA36YA0fYVzENArAaqMEcrh8BLA5/t
	 wxdh0AR1Ub9N6Uv9AwEW7xYJYTiB7p5W+Y8e4HFy3stuiElc2bxREv7o8mQrfSSPe7
	 UuZprnHZWV6gw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1758116033; bh=H1BrXnKDcj43c+KdmykPcdh/94m2CUp+zEOKlLrNdVs=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=cD/nqtxBQZgcnIkF/G4EaQmD7zrJRCpOhEWWv1j80VVwEUEGZsXUJVYZzpTasiZiV
	 wto+hPCOt0mbx+plb0UZ5s+KZTlIJp6ufb+wI3LFXxOxSIph6hlzKhRMprlZt5UdMC
	 ImRnn/b7M01uJe3iihwZlM4pFlFFe1FYPAijlZ079WXgRP6Mq5I+yw/fvmRt/NmKQd
	 zowuEZvlidw5wGpnMmsZUYUjuwkSVHCpsVGNN0twKqnAsMsO934INsDpMRpyVBOMNP
	 O7JiS9plDBKZWBV9Nwf9sLVL1FQgJxm3BUkD2jpE4BmI0O4phbSUiY08egdHfnTkRq
	 dCTXng579GJYQ==
Received: from T-EXCH-07.corp.yadro.com (T-EXCH-07.corp.yadro.com [10.34.9.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mta-03.yadro.com (Postfix) with ESMTPS;
	Wed, 17 Sep 2025 16:33:51 +0300 (MSK)
Received: from T-EXCH-12.corp.yadro.com (10.34.9.214) by
 T-EXCH-07.corp.yadro.com (10.34.9.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 17 Sep 2025 16:33:51 +0300
Received: from yadro.com (172.17.34.51) by T-EXCH-12.corp.yadro.com
 (10.34.9.214) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Wed, 17 Sep
 2025 16:33:51 +0300
Date: Wed, 17 Sep 2025 16:33:50 +0300
From: Dmitry Bogdanov <d.bogdanov@yadro.com>
To: Mike Christie <michael.christie@oracle.com>
CC: <bvanassche@acm.org>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] scsi: target: Create and use macro helpers for
 per CPU stats
Message-ID: <20250917133350.GE624@yadro.com>
References: <20250908231000.10777-1-michael.christie@oracle.com>
 <20250908231000.10777-3-michael.christie@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250908231000.10777-3-michael.christie@oracle.com>
X-ClientProxiedBy: RTM-EXCH-04.corp.yadro.com (10.34.9.204) To
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

On Mon, Sep 08, 2025 at 06:05:55PM -0500, Mike Christie wrote:
> 
> This creates some macros to reduce code duplication for when we handle
> per CPU stats. It them converts the existing LUN and auth cases.
> 
> Note: This is similar to percpu_counters but they only support s64 since
> they are also used for non-stat counters where you need to handle/prevent
> rollover more gracefully. Our use is just for stats where the spec
> defines u64 use plus we already have some files exporting u64 values so
> it's not possible to directly use percpu_counters.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/target/target_core_stat.c | 197 +++++++++---------------------
>  1 file changed, 61 insertions(+), 136 deletions(-)
> 


Thanks, that you agreed create such macros.

Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
