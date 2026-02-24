Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B81C1A0BD0;
	Tue, 24 Feb 2026 01:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771896030; cv=none; b=OhMktW02UhFR8KxhTzn/8fSsSCMYwvGdd2xLbx7ZakWd+plAsDsShxLHpbdecS+yY8rId9lB7hn7Ianw+976D+rJGx1rUhwfpEd7BF2M6CxBrysYfDok3LrTeTX31COKd6ljhHedaWWrPaOd3aAcfQAlDenS6C8md3Fd8iB9srs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771896030; c=relaxed/simple;
	bh=komTt8YpF8ZfJjd3JhHZ2v7AhJmQ5ILztJp+5MLMIF0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=GtvA1Aa/QC4S7KmLd7G6oJ9uh2KVjXOaTSK94XGdwrYuyMxzq7W/dxghZuJPioZQ2bvtzihPv+qjYBssh6n7PyN3ICkbJHcLLER9bRas9NfDl5Fc4udqCdaaqQ3aBhXXEVLvTZqsw5ed79uAVUlQFEQyWW48WGlERRNYDGGi6I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=sg5v9zg3; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="sg5v9zg3"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=sxkBtvVacL4Mo4khjW/2ICY0X6PSJ0egclV0Jxz6amM=;
	b=sg5v9zg3ydNvcAP2PzGjbs0CILoYyItWm9RrMoEb4wO4GGVqj85NX46RNN+L6PUuBmKIDQid4
	uER7BdT1Fq0l9UT2t7CYUU72NAzW2Cgc0hQ53tAhEStx9xjFQuTEUEIettP1ZVnVozJ1KNM1WQj
	HRtDV0diw350fg1hghw9B5U=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4fKft15Kb5z12LJj;
	Tue, 24 Feb 2026 09:15:37 +0800 (CST)
Received: from kwepemf100006.china.huawei.com (unknown [7.202.181.220])
	by mail.maildlp.com (Postfix) with ESMTPS id F211640538;
	Tue, 24 Feb 2026 09:20:18 +0800 (CST)
Received: from [10.174.176.240] (10.174.176.240) by
 kwepemf100006.china.huawei.com (7.202.181.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Tue, 24 Feb 2026 09:20:18 +0800
Message-ID: <23905f7d-824c-408f-aa44-0e1c5bc55e65@huawei.com>
Date: Tue, 24 Feb 2026 09:20:17 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] scsi: sg: minor bugfix and cleanup
To: Bart Van Assche <bvanassche@acm.org>, <dgilbert@interlog.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	<linux-block@vger.kernel.org>
CC: <yangerkun@huaweicloud.com>
References: <20260127062044.3034148-1-yangerkun@huawei.com>
 <b40028c0-910b-4228-8ed9-9843e3db394e@acm.org>
From: yangerkun <yangerkun@huawei.com>
In-Reply-To: <b40028c0-910b-4228-8ed9-9843e3db394e@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemf100006.china.huawei.com (7.202.181.220)

Gently ping...

在 2026/2/10 1:47, Bart Van Assche 写道:
> On 1/26/26 10:20 PM, Yang Erkun wrote:
>> [ ... ]
> 
> For the entire series:
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>

