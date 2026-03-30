Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76053ACF00;
	Mon, 30 Mar 2026 08:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774858098; cv=none; b=UpgAxZRL3An56umRr2aKP+OBjrjWAotDzVfWpja+3v9B5pEiS8+hVcVH5pISggBupF+DKzeD/XYyywGDh4qUP2K6SSPetQmMCwfjkH7NHTKhdipELvvW1n8XhFhpyHEhDziGZmSuGDTg2nBhJVgQPzHK80hDkmrAJWarfh0KI18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774858098; c=relaxed/simple;
	bh=t+nqG3/wCiqQu0s2NJPkLZKR4MAaFxSdDwVtifL1beQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=nZsuJW4U9WeXxZ7nQxAu54b0cTAONFuy2L4sQKag9Djrrd5EA+TG/7zQM+XfjAdh/wPDCI8t2bXn33RAjaURbk/GziSeryfZ9Rx9A2deUERFmULm4fCvrx9bU77dGDxaGQN0BV5ppPKazQ2HjXN1yNwdF273hLrmZZsdBdnONNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=FXEU/3zQ; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=FXEU/3zQ; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="FXEU/3zQ";
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="FXEU/3zQ"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=wxpkmpYiPR7j4fcuhkyeN2M7Pm8HCN1zSEDOb1WvCk4=;
	b=FXEU/3zQOX/lHrxHLT3aLJd+wpE5BYr/Vt+QNV147jJLH7DPe3a/vpf1strxhuEvUqAsBO8Zy
	ma16WAR1NkTtgjnYJYmXXAgMBSbyAksffrfTj4MK5qU2ikV5COrJhBPPM9p58TymBuit6o/+/Cv
	r3uX3KuTZC13B82RUM9tAFg=
Received: from canpmsgout10.his.huawei.com (unknown [172.19.92.130])
	by szxga01-in.huawei.com (SkyGuard) with ESMTPS id 4fkkQ72KNhz1BFwm;
	Mon, 30 Mar 2026 16:07:59 +0800 (CST)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=wxpkmpYiPR7j4fcuhkyeN2M7Pm8HCN1zSEDOb1WvCk4=;
	b=FXEU/3zQOX/lHrxHLT3aLJd+wpE5BYr/Vt+QNV147jJLH7DPe3a/vpf1strxhuEvUqAsBO8Zy
	ma16WAR1NkTtgjnYJYmXXAgMBSbyAksffrfTj4MK5qU2ikV5COrJhBPPM9p58TymBuit6o/+/Cv
	r3uX3KuTZC13B82RUM9tAFg=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4fkkHB5Rdtz1K9hw;
	Mon, 30 Mar 2026 16:01:58 +0800 (CST)
Received: from kwepemj200013.china.huawei.com (unknown [7.202.194.25])
	by mail.maildlp.com (Postfix) with ESMTPS id 0CB034056E;
	Mon, 30 Mar 2026 16:08:05 +0800 (CST)
Received: from [10.174.179.155] (10.174.179.155) by
 kwepemj200013.china.huawei.com (7.202.194.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 30 Mar 2026 16:08:03 +0800
Message-ID: <7fa459e1-d957-4dea-8694-fd5f8866b092@huawei.com>
Date: Mon, 30 Mar 2026 16:08:03 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: =?UTF-8?B?TW96aWxsYSBUaHVuZGVyYmlyZCDmtYvor5XniYg=?=
Subject: Re: [REGRESSION?] scsi: sas: wildcard user scan may iterate over huge
 max_id
From: Li Lingfeng <lilingfeng3@huawei.com>
To: <ranjan.kumar@broadcom.com>
CC: <linux-scsi@vger.kernel.org>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, <rajsekhar.chundru@broadcom.com>,
	<sathya.prakash@broadcom.com>, <sumit.saxena@broadcom.com>,
	<chandrakanth.patil@broadcom.com>, <prayas.patel@broadcom.com>, yangerkun
	<yangerkun@huawei.com>, "zhangyi (F)" <yi.zhang@huawei.com>, Hou Tao
	<houtao1@huawei.com>, "chengzhihao1@huawei.com" <chengzhihao1@huawei.com>,
	<jiangjianjun3@h-partners.com>, <yuancan@huawei.com>
References: <773ba972-433b-44b4-89d2-295bd9f5de38@huawei.com>
In-Reply-To: <773ba972-433b-44b4-89d2-295bd9f5de38@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemj200013.china.huawei.com (7.202.194.25)

Hi,

I have one more question after looking at the SAS scan paths a bit more.

What caught my attention is that sas_rphy_add() and the old
sas_user_scan() seemed to follow the same scanning model:

   - scan via channel 0
   - use rphy->scsi_target_id as the target id

For example, sas_rphy_add() does:

   scsi_scan_target(&rphy->dev, 0, rphy->scsi_target_id, lun,
                    SCSI_SCAN_INITIAL);

So before this change, these two paths looked consistent to me.

Now sas_user_scan() has moved to a different model for the extra channels,
while sas_rphy_add() still uses the original one. This makes me wonder
whether these two paths are expected to stay consistent, and if so, which
direction is actually intended.

Should sas_rphy_add() also be changed to follow the new sas_user_scan()
behavior? Or is sas_rphy_add() a hint that sas_user_scan() should remain
aligned with the original rphy-based scan model instead?

I am not very familiar with the intended SCSI/SAS scanning design here,
so this may be a naive question. I just wanted to check whether the
current inconsistency between sas_rphy_add() and sas_user_scan() is
expected, or whether one of them should be adjusted so that both follow
the same model again.

Any clarification would be greatly appreciated.

Thanks,
Lingfeng.

在 2026/3/28 10:28, Li Lingfeng 写道:
> Hi,
>
> I think commit 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle 
> wildcard
> and multi-channel scans") may introduce a regression for wildcard 
> scans on
> some SAS hosts.
>
> Userspace trigger:
>
>   echo "- - -" > /sys/class/scsi_host/host0/scan
>
> results in:
>
>   channel = SCAN_WILD_CARD
>   id      = SCAN_WILD_CARD
>   lun     = SCAN_WILD_CARD
>
> Before this commit, sas_user_scan() iterated sas_host->rphy_list and 
> called
> scsi_scan_target() for matching rphys. In effect, scanning was limited to
> channel 0 and to target ids present in sas_host->rphy_list.
>
> After this commit, sas_user_scan() does:
>
>   - scan channel 0 via scan_channel_zero()
>   - scan channels 1..shost->max_channel via scsi_scan_host_selected()
>
> When id == SCAN_WILD_CARD, the latter path goes through
> scsi_scan_channel(), which iterates ids from 0 to shost->max_id.
>
> This looks problematic for drivers that use a very large max_id. For
> example, smartpqi sets:
>
>   shost->max_id = ~0;
>
> In that case, a wildcard scan may end up iterating from id 0 to ~0 in
> scsi_scan_channel(). In my testing/analysis, this makes the scan take a
> very long time, and the id-space walk itself does not seem meaningful for
> this SAS transport scan path.
>
> So while the commit fixes incomplete wildcard channel handling, it also
> appears to expand the id scan range from:
>
>   sas_host->rphy_list target ids
>
> to:
>
>   0..shost->max_id
>
> for the additional channels.
>
> It seems to me that wildcard SAS scans should probably remain bounded by
> transport-discovered SAS targets, instead of falling back to a host-wide
> id enumeration for the extra channels. One possible direction may be to
> avoid calling scsi_scan_host_selected() with id == SCAN_WILD_CARD from
> sas_user_scan(), or otherwise constrain the id range in a transport-aware
> way.
>
> Am I understanding this correctly? If so, what would be the preferred way
> to address this? I would appreciate feedback on whether this is 
> considered
> a real regression, and on the best fix direction.
>
> Thanks,
> Lingfeng.
>
