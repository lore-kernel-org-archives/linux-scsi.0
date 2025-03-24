Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0581E433B3
	for <linux-scsi@vger.kernel.org>; Mon, 24 Mar 2025 07:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742800872; cv=none; b=ub92l+M5dKZLyqQQyfcEVkLSZiiTJM8nlcIGxx+b+L3kLvOk30UL7yHmQ44gIzfvA9TxnR0f846HbeRRHqBA0cwYh3lkoye70Mq7FPXeRHo6mih7d8Yv3gCrxQGSArUT/CRIL08veVcHVJVhPEY+2+t6NZjmZUgcRwKNmEaEW1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742800872; c=relaxed/simple;
	bh=SPhQSTflEW79AKbumYb7LdBCzhtq8AW5D/qQjjhVUrU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=B9P2csocmO1kor7qcIN86XShzHCm5BStcz/k/5T8IiYN9hlTNanJf6YUc02UVjBhASA2WfU6fzahmiEIO25VN+pAyGfAAS24DCZBTDopFp6JMfcLf3R5BVm3UlRt+b9mjo0HzacNbPBhCQ1ypGILGiliTMYLRk5OgVPWXwbSmEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4ZLkwl1r6kz1d09W;
	Mon, 24 Mar 2025 15:20:39 +0800 (CST)
Received: from kwepemg100017.china.huawei.com (unknown [7.202.181.58])
	by mail.maildlp.com (Postfix) with ESMTPS id 1E32E1800E2;
	Mon, 24 Mar 2025 15:20:59 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemg100017.china.huawei.com (7.202.181.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 24 Mar 2025 15:20:58 +0800
Message-ID: <12b119ca-8618-d75a-41be-84a6fd754472@huawei.com>
Date: Mon, 24 Mar 2025 15:20:58 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v4 0/2] scsi: hisi_sas: Fix IO errors caused by hardware
 port ID changes
Content-Language: en-CA
To: John Garry <john.g.garry@oracle.com>, <yanaijie@huawei.com>
CC: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>, <prime.zeng@huawei.com>,
	<liuyonglong@huawei.com>, <kangfenglong@huawei.com>,
	<liyangyang20@huawei.com>, <f.fangjian@huawei.com>,
	<xiabing14@h-partners.com>, <zhonghaoquan@hisilicon.com>
References: <20250312095135.3048379-1-yangxingui@huawei.com>
 <d7c30f0a-0a68-4f36-8d89-d0d082cb2473@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <d7c30f0a-0a68-4f36-8d89-d0d082cb2473@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepemh100006.china.huawei.com (7.202.181.89) To
 kwepemg100017.china.huawei.com (7.202.181.58)


On 2025/3/20 23:37, John Garry wrote:
> On 12/03/2025 09:51, Xingui Yang wrote:
>> This series of patches is used to solve the problem that IO may be 
>> sent to
>> the incorrect disk after the HW port ID of the directly connected device
>> is changed.
>>
>> Changes from v3:
>> - Lose and find the disk when hw port id changes based on John's 
>> suggestion
>>
>> Changes from v2:
>> - Use asynchronous scheduling
>>
>> Changes from v1:
>> - Fix "BUG: Atomic scheduling in clear_itct_v3_hw()"
>>
>> Xingui Yang (2):
>>    scsi: hisi_sas: Enable force phy when SATA disk directly connected
>>    scsi: hisi_sas: Fix IO errors caused by hardware port ID changes
> 
> So this is all solved in the LLDD, then this is good

Yes, thank you for your advice.

Thanks,
Xingui




