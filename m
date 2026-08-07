Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF25813B58C;
	Fri,  7 Aug 2026 08:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786091745; cv=none; b=vGY94DWOJh/G2ZmEQEpASbWJ+TEPo5UyZhjW8UXzsxXPO1LCpsUP/zLRLHTD4DcRlUbogmMkAnhJ16Hcdhjpd6bu484uniljyQv8ApLZHKwjXOaQLrDMCfA/L4yr7fWQ05hyQN+RRB+FUcJDnVqs+lhQr2YSCD+BDM877OIfUYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786091745; c=relaxed/simple;
	bh=Kp4j4mA1m6ZfOD7LYco6dC3ISG/csgSjh2mzlP8Wwfk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=CDe57kEvNppywYOAdJNQouPhkEf3Xrmw1wgfvtsTBoQhsCMrPi2GoBKg5Rkeh/9xyNTlSUYHbvshP5bieTCuRgEg306xyDFYDiy069wgETxQDBplaI1kcXF+fTriaBPnOCUzxTVmowrNOLtQ4TMTqmB0ona3qmT4MlWjuHSxQwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=It1+9tt+; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="It1+9tt+"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=EQwjjYXis5wziawmfGZhOOkc579mWyPJoann0Y3BzK8=;
	b=It1+9tt+lpZf5wrHUq0rpasF1oEEKSq/Jsl2/CTaxVDd28Hd8veIUFQlA1yR9dH5HzxhoZ5+i
	IvGYcIyhQC2zVLL175X7bSmLJJEscvPXTtsBU0dmVgPLf5ktltDU5o7Qn14++a56WYIJUhVIuFN
	qzGbjv/7adfsUKNQ1wb94SU=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hGcfk4Lk2z1T4Jg;
	Fri,  7 Aug 2026 16:25:50 +0800 (CST)
Received: from kwepemp200007.china.huawei.com (unknown [7.202.195.46])
	by mail.maildlp.com (Postfix) with ESMTPS id D01704057F;
	Fri,  7 Aug 2026 16:35:33 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp200007.china.huawei.com (7.202.195.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 7 Aug 2026 16:35:33 +0800
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 7 Aug 2026 16:35:33 +0800
Message-ID: <af713624-fc5a-c4cd-2737-7f52bd0d163e@huawei.com>
Date: Fri, 7 Aug 2026 16:35:32 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v9 0/2] libsas: rediscover improvements for
 linkrate/sas_addr changes
Content-Language: en-CA
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
References: <20260624063230.3264029-1-yangxingui@huawei.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <20260624063230.3264029-1-yangxingui@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepemh100017.china.huawei.com (7.202.181.103) To
 kwepemp500015.china.huawei.com (7.202.195.9)

Hi, John

Kindly ping for review...

On 2026/6/24 14:32, Xingui Yang wrote:
> When a device attached to an expander phy experiences a linkrate change
> (e.g., due to cable reconnection or negotiation), the current code in
> sas_rediscover_dev() treats it as "broadcast flutter" and takes no action
> if the SAS address and device type remain unchanged.
> 
> This series is based on John Garry's suggestion [1] to check the linkrate
> and mark the device as gone and rediscover when flutter occurs, replacing
> the previous v2 patch series that used lldd callbacks.
> 
> The previous v2 approach added lldd_dev_info_update callback which John
> commented as "seem fragile and too specialized" [2]. This series adopts
> a simpler approach that directly checks linkrate/sas_addr changes in
> sas_rediscover_dev() and triggers rediscovery using libsas's standard
> async discovery pattern.
> 
> This aligns with Jason Yan's earlier work [3] which was verified to
> solve the linkrate change issue.
> 
> Additionally, per the discussion in v3 [4], the existing replace code
> path also suffers from the same sysfs duplication issue:
> sas_unregister_devs_sas_addr() only marks the device as gone, but the
> actual sysfs cleanup happens later in sas_destruct_devices(). Calling
> sas_discover_new() immediately after unregister causes sysfs_warn_dup()
> errors. This series also optimizes the replace path to use the async
> pattern, ensuring proper ordering for both flutter and replace cases.
> 
> Changes from v8:
> - In sas_dev_is_flutter(), call sas_ex_phy_discover() before
>    sas_ex_to_dev() to ensure PHY state is always updated and to avoid
>    use-after-free since the child device pointer is obtained after the
>    sleeping SMP request completes, eliminating the need for kref
> - Addressed Sashiko AI review [5][6] feedback on PHY discovery bypass
>    and TOCTOU concerns
> 
> Changes from v7:
> Addressed issues identified by Sashiko AI review [5][6]:
> - In sas_dev_is_flutter(), reorder sas_addr check before linkrate check
>    to ensure address restoration is not skipped when both change
>    simultaneously, preventing device leak
> - In sas_ex_to_dev(), add defensive NULL check for ex_dev to guard
>    against callers passing a NULL device
> 
> Not addressed (pre-existing subsystem design):
> - sas_find_dev_by_rphy() returns unreferenced pointer: subsystem-wide
>    pattern used by 10+ call sites, should be a separate patch
> - ex_phy->port TOCTOU: discovery path is serialized by disco_mutex,
>    no race occurs in practice
> 
> Changes from v6:
> - Add comment for restoring phy->attached_sas_addr to child_dev->sas_addr
> - Optimize the conditional structure in sas_dev_is_flutter()
> 
> Changes from v5:
> - In sas_addr change handling, restore phy->attached_sas_addr to
>    child_dev->sas_addr before returning false, ensuring
>    sas_unregister_devs_sas_addr() can properly match the device via
>    sas_phy_match_dev_addr() for correct device unregistration
> 
> Changes from v4:
> - Rename sas_rediscover_phy to sas_rediscover_ex_phy for consistency
>    with expander phy symbol naming convention
> - Rename sas_is_flutter to sas_dev_is_flutter per John's suggestion
> - Check return value of sas_ex_phy_discover() for errors
> - Factor out child_dev checks to improve code clarity
> 
> Changes from v3:
> - Also optimize the replace code path to use async discovery pattern
> - Introduce sas_is_flutter() and sas_rediscover_phy() helpers
>    to encapsulate the flutter handling logic and avoid function bloat
> - Fix replace code path sysfs duplication issue
> 
> Changes from v2:
> - Drop lldd_dev_info_update callback approach per John Garry's suggestion
> - Drop hisi_sas specific changes (no longer needed without callback)
> - Use libsas's async discovery pattern for rediscovery
> - Add sas_addr change detection alongside linkrate change
> 
> Changes from v1:
> - Split into three patches
> 
> [1] https://lore.kernel.org/linux-scsi/c4e4c99f-a13c-4e28-8650-48be1f96d7cf@oracle.com/
> [2] https://lore.kernel.org/linux-scsi/28bd9d5b-f597-0aae-5340-bd951b2083aa@huawei.com/
> [3] https://lore.kernel.org/linux-scsi/20190130082412.9357-6-yanaijie@huawei.com/
> [4] https://lore.kernel.org/linux-scsi/b99cd59f-b986-432e-aaf1-3b757e1c4c34@oracle.com/
> [5] https://lore.kernel.org/linux-scsi/20260611062530.3B6651F00898@smtp.kernel.org/
> [6] https://lore.kernel.org/linux-scsi/20260611062833.357031F00893@smtp.kernel.org/
> 
> 
> Xingui Yang (2):
>    scsi: libsas: refactor sas_ex_to_ata() using new helper
>      sas_ex_to_dev()
>    scsi: libsas: Add linkrate and sas_addr change detection in rediscover
> 
>   drivers/scsi/libsas/sas_expander.c | 102 +++++++++++++++++++++++------
>   drivers/scsi/libsas/sas_internal.h |   1 +
>   2 files changed, 84 insertions(+), 19 deletions(-)
> 
