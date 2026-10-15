Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5C725B0B9;
	Thu, 15 Oct 2026 03:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792036321; cv=none; b=f4hqJZ+S4VjUMlwefI0IV5lRETIoOCIy7p6V5fbSeqNKIf3KMoN8nZwMhkKedHUQjUdqIDD37+n8LQ1v2nHPzPQFQ9j5Nkqkepzudx0U2UTZLsgG9Nq59zZgQ4WuWwbpecN0ZzhXOhfYfZ93q9gIkTe3euVjryR/1uBfEc4OMgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792036321; c=relaxed/simple;
	bh=RfAMC1AI75SE2Yt2VeOu/g4bC3+80hE8mx+3qMjcT0Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=aAWAW01jSMf/1OgJIYbQmS0TXvhrP4kGOJpFa5lYYrnmt7Y4YZwUwZMK6sY8g2XAEk8pgMwUz1ut2+Jagnga6ewTkLNLpaKkoCpS6Vphp2OxWZ3q7CD/uHC9UADsxDVUOhKykpFuDPbmiv15Psf2wewxvy9FsFkyBC+OFcWykO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=HillKrM5; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="HillKrM5"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=t+re2L57BDOlDw/WIgIkhKXYspqz7Q4J/QFKlsn7Jgk=;
	b=HillKrM5LC4waNNyExYXhqFEyyAyGctO6AoSe1+PMH7fk+QwcmDNBoxh4+Vx8UsUw67m+8PEG
	FkqfhkpN475jK078iOSO4wyMHaJ3CLG1RENj3pqt7z8JH+NSc9r3JfJ9YjF2hqMiklzQbMgTbwF
	m2GfHId2D4MTddco52CUp/k=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4j4v3r350hz1cyPY;
	Thu, 15 Oct 2026 11:40:40 +0800 (CST)
Received: from kwepemp200006.china.huawei.com (unknown [7.202.195.217])
	by mail.maildlp.com (Postfix) with ESMTPS id 451A240561;
	Thu, 15 Oct 2026 11:51:56 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp200006.china.huawei.com (7.202.195.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 15 Oct 2026 11:51:55 +0800
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 15 Oct 2026 11:51:55 +0800
Message-ID: <d92ec5b9-639b-87d5-f276-e327f1372d4d@huawei.com>
Date: Thu, 15 Oct 2026 11:51:55 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3 0/4] scsi: hisi_sas: Some misc fixes
Content-Language: en-CA
To: "Martin K. Petersen" <mkp@kernel.org>
CC: <jejb@linux.ibm.com>, <john.garry@linux.dev>, <yanaijie@huawei.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <kangfenglong@huawei.com>
References: <20261009033238.1076098-1-yangxingui@huawei.com>
 <51d44015-cbbf-ab69-47ed-0c9b397da203@huawei.com>
 <yq1ik33em3v.fsf@mail.kernel.org>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <yq1ik33em3v.fsf@mail.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemp500015.china.huawei.com (7.202.195.9)



On 2026/10/15 10:26, Martin K. Petersen wrote:
> 
>> Could you let us know whether this series is fine to be merged as is,
>> and how you would prefer the pre-existing findings to be handled: in a
>> follow-up series, or folded into this one?
> 
> Please send follow-up patches.

OK.

Thanks,
Xingui
