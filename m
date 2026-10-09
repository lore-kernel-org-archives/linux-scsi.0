Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB4A2DF719;
	Fri,  9 Oct 2026 09:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791536936; cv=none; b=OSENmdWGvZTZMP6nhas5GNv9Ip6CaKTBUgrIIg9DZJxJs0Kdmhhm8nvJV+bnsJu27nXtfRzmBJbF6ovSc4TVKK9nJas0dZJvIftF8cp/YFJ9BiwfBbdNg8A6OBk4/RXnlEDnAzbgczpbptq5bOsPjfB6x4WXM/ZZlM5IsmrH8No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791536936; c=relaxed/simple;
	bh=vQdys6JN84qg0vz5KWOJgWvBl7/qJN+mWAbDcm8siIk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=gb2ubE1tbk3jQLXq9IRkHWy9kVGjEfBugOVwfAiY0wr+kD3IT5hUQF8TcO2YeA9mUgeG9ZfZHoKwsdKTKKA38lvLy8ph4EDKk/x0IidzS6JUCCVnTZPX1K3xJt3+rszrf6cs6FZtRJLO/Lif936CgZOjUdARvRU8rdpiHPazNwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=dfoshPIm; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="dfoshPIm"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=spanpOD4ZJ9QlA2oL7DcTdTt5EE5NuZI/P6v2qXOSew=;
	b=dfoshPImi0g9u9saXtSWtqZqWbh9XPf/vqWyoUF1U4HP0OyBag8RXs+op8hmHY9On1T7pDjvf
	LzkC9WeGskN9xUAv4ZzkOnUfRf5G2bF5gnNtyauq326x+MCC6Gh2VosdR6IG82xW6ggmyYJpXxv
	959YujpuO5llEPyBX+T49To=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4j1LM100GVzmV8H;
	Fri,  9 Oct 2026 16:56:28 +0800 (CST)
Received: from kwepemp500007.china.huawei.com (unknown [7.202.195.151])
	by mail.maildlp.com (Postfix) with ESMTPS id 6B12240561;
	Fri,  9 Oct 2026 17:08:43 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp500007.china.huawei.com (7.202.195.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 9 Oct 2026 17:08:43 +0800
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 9 Oct 2026 17:08:33 +0800
Message-ID: <51d44015-cbbf-ab69-47ed-0c9b397da203@huawei.com>
Date: Fri, 9 Oct 2026 17:08:33 +0800
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
To: <mkp@kernel.org>, <jejb@linux.ibm.com>, <john.garry@linux.dev>,
	<yanaijie@huawei.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <kangfenglong@huawei.com>
References: <20261009033238.1076098-1-yangxingui@huawei.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <20261009033238.1076098-1-yangxingui@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemp500015.china.huawei.com (7.202.195.9)

Hi Martin, James,

We have gone through all of the Sashiko review comments on v2 and v3
one by one.  Of the six v2 findings, two were fixed in v3 (clearing
all five error counters and taking the runtime PM reference with
pm_runtime_get_if_active()), and one was answered in the v3 commit
message (the software counters are cumulative statistics and are not
reset by design).  The rest are pre-existing issues, summarized below
by trigger condition and impact:

- The delays in the phy disable and host shutdown paths predate this
   series.  The 50 ms wait for the PHY to go down is a hardware
   requirement, and a poll-based rework is planned.
- The pm8001 and mvsas response-IU findings are pre-existing issues
   in those drivers.  The libsas patch leaves these cases unchanged
   and strictly narrows the worst case, and fixing them is outside the
   scope of this series.
- The suspend flush-ordering window from the v2 review also predates
   this series.
- The suggested CHL_INT2 clear order would trade delayed reporting of
   error counters for actual data loss.
- The negative-return concern of pm_runtime_get_if_active() cannot be
   triggered on this driver, and the suggested check would disable the
   fix on !CONFIG_PM builds.

In short, none of the remaining findings is a regression introduced
by this series.

One concern to raise: Sashiko reviews every posting from scratch, and
its findings change from round to round.  Of the six v2 findings, one
was re-raised in v3 and three were not raised again, while six new
ones appeared (7 findings on all 4 patches for v3).  Iterating on its
comments alone will not converge.

Could you let us know whether this series is fine to be merged as is,
and how you would prefer the pre-existing findings to be handled: in
a follow-up series, or folded into this one?

Thanks,
Xingui

On 2026/10/9 11:32, Xingui Yang wrote:
> This series contains three independent fixes for the hisi_sas driver,
> plus a libsas fix found during review.
> 
> Patch 1 fixes an out-of-bounds memcpy in sas_ssp_task_response(): a
> device-provided sense_data_len >= 0x80000000 turns negative in the
> min_t(int, ...) clamp and becomes a huge memcpy length.
> 
> Patch 2 fixes incorrect delay values introduced by a previous
> magic-number cleanup commit. Three delay sites were changed to use
> a single macro (value 100) which did not match their original values,
> causing increased boot and shutdown time.
> 
> Patch 3 clears stale PHY error counts on phyup so that error detection
> is not misled by intermediate errors generated during link
> establishment.
> 
> Patch 4 fixes spinup failures of directly-attached SAS HDDs that power
> up in the Active_Wait state and wait for a NOTIFY(ENABLE SPINUP)
> primitive before becoming ready: parse the sense data in the slot
> completion path and send the primitive from deferred work.
> 
> Changes from v2:
> Addresses the Sashiko AI review of v2.
> - Clear all five error counter registers.
> - Use pm_runtime_get_if_active().
> 
> Changes from v1:
> Addresses the Sashiko AI review of v1.
> - Add Patch 1, found in review of the sense parsing of patch 4.
> - Clear the counters under phy->lock.
> - Take a runtime PM reference for the deferred work
> 
> The remaining review findings are pre-existing issues, left for
> separate fixes in the future.
> 
> Xingui Yang (4):
>    scsi: libsas: Fix out-of-bounds memcpy in sas_ssp_task_response()
>    scsi: hisi_sas: Fix incorrect delay values from magic-number cleanup
>    scsi: hisi_sas: Clear PHY error counts on phyup
>    scsi: hisi_sas: Fix spinup failure for SAS SSP devices in Active_Wait
>      state
> 
>   drivers/scsi/hisi_sas/hisi_sas.h       |  3 ++
>   drivers/scsi/hisi_sas/hisi_sas_main.c  | 43 ++++++++++++++++++++++
>   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  4 ++
>   drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  4 ++
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 51 ++++++++++++++++++--------
>   drivers/scsi/libsas/sas_task.c         |  2 +-
>   6 files changed, 90 insertions(+), 17 deletions(-)
> 
