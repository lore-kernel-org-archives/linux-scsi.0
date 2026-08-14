Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556CC34404E;
	Fri, 14 Aug 2026 07:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786694129; cv=none; b=UlG0+C5hZ94iuSS7jkhFgTm0Vscb0cyQYkhZNS79ol1EtlDEvoYmWawJtZ3xOX54N+8ixBN/6y4KTcflpZeyPFy6xYvyfZ8nVWGaaDUQOB9l3nLVoDFZdm7CbY9ERUpV0FXpEtSP72VK62JA6A5FJ23GO+NfUXi5PgT7srAde2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786694129; c=relaxed/simple;
	bh=w/BJbMxW5kxjgmzLvVtxx6x2dDDDyLLWp9iSJnLLVmM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=ml4bTcGeELJZtiYkE+q4HnM3ZsJfhbS/QVZ0lV6OBIhNyzY6KoQCVfYXcb+lbJBAJX80sBV89MP7eMg5J9yJcDDQdTWt5yiiz3oFONoIu7e6lfpopEK1RqazxNp1Rcyt0uVViCYxr4+uKE+jo8OM9LFW2yfKdAeu88ZDLr55VSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=HzgnliOP; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="HzgnliOP"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=KQQ3UlgG3IZGfPN51NjE85vijmGD6nQm39BPS7xg5Do=;
	b=HzgnliOPHdvZoB1mfqIJMEGUOKUAMSjCylaK1Sm7oVzUkbUu4HdgYpUYu9nI7IHHo8Q3TsYJt
	VKyv6/xdCo88OyRlC85gXDv9/UUmjwWCnSD7fH9matONdq+faAUXgBbfG/PZKkZ+If9yiRb1BQJ
	QBSl1JlmVH4tsF6A0oHf/d0=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hLvPw3S0LzKm4b;
	Fri, 14 Aug 2026 15:44:36 +0800 (CST)
Received: from kwepemp500011.china.huawei.com (unknown [7.202.195.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 3EACD40572;
	Fri, 14 Aug 2026 15:55:18 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp500011.china.huawei.com (7.202.195.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 14 Aug 2026 15:55:17 +0800
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 14 Aug 2026 15:55:17 +0800
Message-ID: <49e6e991-5a0f-9205-1a2f-c1fe9f4fb036@huawei.com>
Date: Fri, 14 Aug 2026 15:55:16 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3 0/2] scsi: libsas: Support spinup notification for SAS
 devices
Content-Language: en-CA
From: yangxingui <yangxingui@huawei.com>
To: John Garry <john.g.garry@oracle.com>, <yanaijie@huawei.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <kangfenglong@huawei.com>
References: <20260803020536.546544-1-yangxingui@huawei.com>
 <e34a40de-474c-4a3c-8013-726d473bc79c@oracle.com>
 <28879664-7e0f-60d5-caf7-60a1e2442d77@huawei.com>
In-Reply-To: <28879664-7e0f-60d5-caf7-60a1e2442d77@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepemh200002.china.huawei.com (7.202.181.108) To
 kwepemp500015.china.huawei.com (7.202.195.9)



On 2026/8/4 17:30, yangxingui wrote:
> Hi John
> 
> On 2026/8/4 15:35, John Garry wrote:
>> On 03/08/2026 03:05, Xingui Yang wrote:
>>> When a SAS device is in the Active_Wait or Idle_Wait power state, it
>>> returns NOT_READY with ASC/ASCQ = 0x04/0x11 (notify (enable spinup)
>>> required), indicating that a NOTIFY(ENABLE SPINUP) primitive is 
>>> needed to
>>> trigger media spinup.
>>>
>>> Without handling this condition, the SCSI mid-layer will indefinitely 
>>> retry
>>> the command with ACTION_DELAYED_RETRY, resulting in the disk never 
>>> spinning
>>> up and becoming unusable. A typical manifestation is:
>>>
>>>    sd 4:0:9:0: [sde] Spinning up disk...
>>>    ...not responding...
>>>    sd 4:0:9:0: [sde] Sense Key : Not Ready
>>>    sd 4:0:9:0: [sde] Add. Sense: Logical unit not ready, notify 
>>> (enable spinup) required
>>>
>>> To resolve this, the SAS controller needs to send a NOTIFY(ENABLE 
>>> SPINUP)
>>> primitive to the target phy, which transitions the device out of the
>>> waiting state and allows normal spinup to proceed.
>>>
>>
>> How would other SAS HBAs which use libsas handle this scenario? Since 
>> they have FW, would the FW automatically issue this NOTIFY(ENABLE 
>> SPINUP)?
>>
>> I just wonder why hisi_sas seems to be only driver which would need this.
> 
> Thanks for the question. This affects only SAS HDDs. I checked pm8001, 
> isci, and aic94xx — all handle NOTIFY(ENABLE SPINUP) at the driver level:
> 
> - pm8001: sends once at phy-up, then mdelay(200) — comment: "delay a 
> moment to wait disk to spinup" — before notifying libsas.
> 
> - isci: enables hardware periodic insertion during link idle (ENABLE bit 
> in notify_enable_spinup_control), cleared at phy stop.
> 
> - aic94xx: enables microcode periodic insertion during link idle 
> (NOTIFY_TIMER_TIMEOUT = 500ms interval), stops at phy down.
> 
> hisi_sas also calls sl_notify_ssp() at phy-up, but the NOTIFY_EN bit is 
> held for only 1ms — msleep(1) between setting and clearing — before 
> immediately notifying libsas.
> 
> The root cause appears to be that 1ms is insufficient compared to 
> pm8001's 200ms. An alternative to hisi_sas would be to simply increase 
> the hold time in sl_notify_ssp() to match pm8001's approach, keeping the 
> fix within hisi_sas.

When NOTIFY_EN is configured, the hardware sends only a single spinup 
notify primitive, and adjusting the sleep duration has no effect. 
However, TRI_NOTIFY_EN bit (bit 1), the hardware can send three notify 
primitives, which helps alleviate this issue.

Thanks,
Xingui
