Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC442E36F3;
	Wed, 17 Sep 2025 13:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758116293; cv=none; b=ldBShAzLLiFyd94eB3SJL4JuSgiAUukc0g6Xe4aYoQ18PhR6IeCum6d+JCBHO3zPN1SGJl5mnzcrtqXjDxcnPpxIkUc0mbiwWT00RDYpb5mdxktLBuro/RI09rb0GCnffE/on7AIVDJoxPsnVlo210rwGR6epId7rrbcIvAiNLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758116293; c=relaxed/simple;
	bh=lbxZBZE84OEIyWEspAriq8MTDBWuDcqYaQGYH+NNHHw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WaoTf02z8ZN7JgcjtHMo8HaUpw3+PV0bOFe1PU0aOztCOhcZlJtcJLswpxOBsv93sv7mvyKkCPKos0B1qzn2u9zey1w4o29xb/kCL9iVseNlVluD4BZWSC5P9byTQ4FQBcoUXB6ysRELLV0UnqlvnFYJ9t+1lS1pd/ZcrF74a5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=F9dPYUgF; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=YvG3aQVv; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="F9dPYUgF";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="YvG3aQVv"
Received: from mta-03.yadro.com (localhost [127.0.0.1])
	by mta-03.yadro.com (Postfix) with ESMTP id 21EBDE0012;
	Wed, 17 Sep 2025 16:38:07 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com 21EBDE0012
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-02;
	t=1758116287; bh=+L0EAGU85DPuRlYmLj+SoEjQLmhaNKFr3eTvsSsOYYg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=F9dPYUgFK/WSqevgxtU7a7y6freLBH1IX09zAyekzMGOO19jSQgQRgRJfhEWg4I+t
	 iI/Rtpbzqx/YrxnJH09nByuiCv6EjJKd6+Ax2oXEXP1IhEf4iyqYQJZsR7XlCCdrOk
	 aQdfmqc/cVZ24REjO6sPOwT6Fc98C2xU/sKCwU6kB41ewhIF3jMKsAIZiSZWZF4jr9
	 o30/R/34gct0W4Hp6hnDR+/Ql0fQG+5Hn6LW5AXQT2RqRIIG8GuXwOLBlSiEHkyiqq
	 b8yIj+DnydBqL83lr2OOvLU57UNfkvUQ+kzHy4BpSF0wiIL81Eqvyln2OsmJ9ET6Ag
	 C9keOcyotPYLQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1758116287; bh=+L0EAGU85DPuRlYmLj+SoEjQLmhaNKFr3eTvsSsOYYg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=YvG3aQVv0RTsOjNCQ51oYOR2Y+uF/gV20nM5pmQh/50qI3hMW5Kt7k/CrXv7bGXZj
	 +edaineqPt/BXlEHJOp1xlFUG2z2+DRkWIw9FFpHF7fTzQSSGrH6Gzuw+km+XQX7Hh
	 69LbBMplpFfAb+oH/RtIHXX2WzHbDbFe5LsdH0qg2LRZ33eU/oU6Mp/FEXMzEbX4Mu
	 Z52HcpT8ZwOv0uqBt5tTQBBiVI8FEvS1B35+594TSJ1cJau6/I25ts8zLRNNE15pdh
	 +NdJ6IPgkVC29+u/vTeZoy7F/1CiaH74an4TsIm8HDZH0xxVMXZE9KS8bBrjVgLQaY
	 X6TOiAvMFxg+Q==
Received: from T-EXCH-10.corp.yadro.com (T-EXCH-10.corp.yadro.com [10.34.9.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mta-03.yadro.com (Postfix) with ESMTPS;
	Wed, 17 Sep 2025 16:38:05 +0300 (MSK)
Received: from T-EXCH-12.corp.yadro.com (10.34.9.214) by
 T-EXCH-10.corp.yadro.com (10.34.9.212) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.9; Wed, 17 Sep 2025 16:38:05 +0300
Received: from yadro.com (172.17.34.51) by T-EXCH-12.corp.yadro.com
 (10.34.9.214) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Wed, 17 Sep
 2025 16:38:04 +0300
Date: Wed, 17 Sep 2025 16:38:04 +0300
From: Dmitry Bogdanov <d.bogdanov@yadro.com>
To: Mike Christie <michael.christie@oracle.com>
CC: <bvanassche@acm.org>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] scsi: target: Move LUN stats to per CPU
Message-ID: <20250917133804.GF624@yadro.com>
References: <20250908231000.10777-1-michael.christie@oracle.com>
 <20250908231000.10777-4-michael.christie@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250908231000.10777-4-michael.christie@oracle.com>
X-ClientProxiedBy: RTM-EXCH-01.corp.yadro.com (10.34.9.201) To
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

On Mon, Sep 08, 2025 at 06:05:56PM -0500, Mike Christie wrote:
> 
> The atomic use in the main I/O path is causing perf issues when using
> higher performance backend devices and multiple queues (more than
> 10 when using vhost-scsi) like with this fio workload:
> 
> [global]
> bs=4K
> iodepth=128
> direct=1
> ioengine=libaio
> group_reporting
> time_based
> runtime=120
> name=standard-iops
> rw=randread
> numjobs=16
> cpus_allowed=0-15
> 
> To fix this issue, this moves the LUN stats to per CPU.
> 
> Note: I forgot to include this patch with the delayed/ordered per CPU
> tracking and per device/device entry per CPU stats. With this patch you
> get the full 33% improvements when using fast backends, multiple queues
> and multiple IO submiters.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>

Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
