Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A58148FF3;
	Wed, 31 Jul 2024 21:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722460394; cv=none; b=I77eIXQZPSbgStRU1LfU/IPbcG1hgdDoGDxQpPoSsi534L9yqwxLK8Y9RLZPawc3djZAL3Wn01WIo3fKM8ZCPLL/aC3Zx1rzlGzmFtkYzW8hZ1bDLAVUHr9qAWh4fam05MoH14/+ESeAEQEVNOeNoQF4Xbvwe2sfXTMAkKy2iwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722460394; c=relaxed/simple;
	bh=wc4+dDNaQK65hClr0lWuXsz/o88UIt9Tk9fgYeEmSy0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N+15KfaAVNgOLPKLedbbrN4wT+E61XqppOqy1HeKj5UP9uW9WVzxePEh/6TML5Y9paRTi3xKy5kwmjUzu1wPWUSn/1D3QUT7Ikq7vLUE3wJN+rdU7H6U4l9evitc1fYn7/CHeKXTtaQq8jd++5sv2/RqbTqbWU/EFa/217KePOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0QFdNZE9; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0QFdNZE9"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WZ4ZJ3QrbzlgVnY;
	Wed, 31 Jul 2024 21:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1722460390; x=1725052391; bh=f2AwTeYITTrradPl/H+sVuiY
	Bmqp1ESPrs/YhR4DEZ0=; b=0QFdNZE9Jp3zwgILJDQiEbVZjscxUmDbzgd6YOnw
	aq1tfIiIhcamWy7YCu5uxCRatmj/MCJCJqPCwNeOcWI8LnqAXUZ4U44T9Pwesh1B
	Vx1ggfAQLYDUDcn9BWAH6IHOynt7AqhpezzjGKpMPo88X4XH7398ZtR9fjTtVc2Y
	QX2S6jClpRGpSr3L7wxGHCKYPhkRjh156CF1KVCOvXOigXhJgQ4KQi2SDiHp/jzm
	YXDTZO9Pa+cqy64IdL9LnuGpTyYwBL3WeADCAA5/EShaNz5RSKosJGsCg5msDpNT
	1EOqNpQuHhETyPRbQBDTp1Nv04sBZWWeEgNCG8LSUA6OWA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id a_ZRGJco0lJv; Wed, 31 Jul 2024 21:13:10 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WZ4ZF6c16zlgVnN;
	Wed, 31 Jul 2024 21:13:09 +0000 (UTC)
Message-ID: <0b3c0120-a680-455a-abfd-b3b6b0ddbed4@acm.org>
Date: Wed, 31 Jul 2024 14:13:08 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: Add HCI capabilities sysfs group
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240731122051.2058406-1-avri.altman@wdc.com>
 <20240731122051.2058406-3-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240731122051.2058406-3-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/31/24 5:20 AM, Avri Altman wrote:
> +static ssize_t capabilities_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +
> +	return sysfs_emit(buf, "0x%x\n", hba->capabilities);
> +}

For every new sysfs entry that is added, documentation must be added
in Documentation/ABI/testing/sysfs-driver-ufs.

> +static ssize_t ext_capabilities_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	int ret;
> +	u32 val;
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +
> +	if (hba->ufs_version < ufshci_version(4, 0))
> +		return -EOPNOTSUPP;
> +
> +	ret = ufshcd_read_hci_reg(hba, &val, REG_EXT_CONTROLLER_CAPABILITIES);
> +	if (ret)
> +		return ret;
> +
> +	return sysfs_emit(buf, "0x%x\n", val);
> +}

Host controller register reads must be protected by ufshcd_rpm_get_sync(hba) /
ufshcd_rpm_put_sync(hba).

Thanks,

Bart.
