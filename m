Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9081552EB;
	Fri,  9 Aug 2024 07:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723190133; cv=none; b=CawMhbP6gqrLhHIcNwsPm2lhaVu1D/cLBUZEK0IB1ZKAH4WwOROG3jj/PUDOhjnGVR8ObVwnBY3261xlR2JHZ65dK4mKoN+e0aePTwpygTCxGxjPHczC3bBiHnb0NJtlouPyhRhFu3oplWHBNcEqFe8YyHcpyJHMQ5ZNsujyRFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723190133; c=relaxed/simple;
	bh=a3NDtrOFkr6eWhw4xLJ1GOK2gjy06ICYCwEMqdwLNjg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eBBEGLdkcJUvVF5EfRyPfoY/1qwxv7c1VYsYCBWiyZyvHfCiemEY1ZIVWdII4Ns+X4Bz1KUxGRVfTUtjk76AJXFzTBu4F5iIFc6smaafitg8dKbTBWVTLTf+lOYmNSrwsPx3NprLiFfPNe5Pjar9/sqlZMOdu9r8n+7w+05Hl8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=at8Qs08S; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="at8Qs08S"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-7a1be7b5d70so1424014a12.0;
        Fri, 09 Aug 2024 00:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723190131; x=1723794931; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2mIwtqqNsntLjxTEf9qy3KmpCcVtl80DMioT7BD07WQ=;
        b=at8Qs08SYeQZStEQD8z/gl3fMiy9rTHLCpLPbgWCFdqwZvXAXELLy+7ahNuSm2s6t+
         /qobGViq6PN/IfwcGvpgjZ/ESvlWp7cngsU8w6r+jsAabMtYDEWyY49WGDty3q18Yp/9
         IxBRe0N0whtSYtydBhbGCb8WJ9uQse4FwU1ZiOKaxdsv0VA9r6WSB1s4hxhhdy/JOyqN
         d2HGvEIltCHhwjOSOrXJf1+dDEE3SqhedMKjmHMWVQzyGteiMgItYZM6BHj2uwgBCy8+
         AEsaVmcBr2ogFm5B5paR0Wdv2jwG8W03R+YNeDxJLFJiHljsAvs0/HHKzKFyDU295Vfg
         +ZQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723190131; x=1723794931;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2mIwtqqNsntLjxTEf9qy3KmpCcVtl80DMioT7BD07WQ=;
        b=pedkufFJXwOo54HQF9uopykIods9D9x7Btw8hQfzyFYeiS/0HuRt0yeeiPZLRutjw3
         lX5U4YbCF6Hpvhr6Kx8qW5txNiODnYNvkE8pZ/euhWi2HLMAZAm4nWw1Nyn+PR1c/uD1
         54iOhGWHbJe6sqWrJGBkmGHOVGpqYObeMFzc/KFNhJj3aJohgNHOEKdu7ZJoVx7KoQJL
         QHFpHxKsLp6S268qFRjWqQrCwzC1LS40wV9NQJ/FcHg0XHeWK74yGQK6762wcsn/+OD2
         CEMqmNQ+UmPRktxSMFCgEGRZynvQceL+rhPnaqcuaXkQtt15YqMefSSe8FIWWBCDo+AQ
         lDEA==
X-Forwarded-Encrypted: i=1; AJvYcCUamUvc1WEx0mT+qVk16oltVjmav92bJksni+CaOGyFvuyFf30e6j1WlO4EOCZcqvHaHoZKR+aQmSXsFqdpT4K6+/Td/66apxvjaQpkddatC3HidfxPFlNUM6rP8kDiL39JYnu0BkXzTg==
X-Gm-Message-State: AOJu0YzdvajeXQbPafkYHFW8G4mNYVtvWSNoKNJiGkeUnztY6wqnpo7D
	pt7hdnnk6rWUlogHeypKdIhS/FSQ8BSjaD/15IbkNgJVVKjTu8Fx
X-Google-Smtp-Source: AGHT+IHA8hn+5Z32hUDFcN9u6j/5XUYfOpOTNglgvb90esXK+j9diout9kueU7OAZbDusLaAvNaxCg==
X-Received: by 2002:a17:903:22c1:b0:1f4:a04e:8713 with SMTP id d9443c01a7336-200ae608246mr14391345ad.28.1723190131155;
        Fri, 09 Aug 2024 00:55:31 -0700 (PDT)
Received: from thinkpad ([117.213.100.70])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff58f219easm136368005ad.58.2024.08.09.00.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 00:55:30 -0700 (PDT)
Date: Fri, 9 Aug 2024 13:25:22 +0530
From: Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Keoseong Park <keosung.park@samsung.com>
Subject: Re: [PATCH v3 2/2] scsi: ufs: Add HCI capabilities sysfs group
Message-ID: <20240809075522.GA9360@thinkpad>
References: <20240809072331.2483196-1-avri.altman@wdc.com>
 <20240809072331.2483196-3-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240809072331.2483196-3-avri.altman@wdc.com>

On Fri, Aug 09, 2024 at 10:23:31AM +0300, Avri Altman wrote:
> The standard register map of UFSHCI is comprised of several groups.  The
> first group (starting from offset 0x00), is the host capabilities group.
> It contains some interesting information, that otherwise is not
> available, e.g. the UFS version of the platform etc.
> 
> Reviewed-by: Keoseong Park <keosung.park@samsung.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>  Documentation/ABI/testing/sysfs-driver-ufs | 42 ++++++++++
>  drivers/ufs/core/ufs-sysfs.c               | 95 ++++++++++++++++++++++
>  2 files changed, 137 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
> index fe943ce76c60..b6e0c3b806fd 100644
> --- a/Documentation/ABI/testing/sysfs-driver-ufs
> +++ b/Documentation/ABI/testing/sysfs-driver-ufs
> @@ -1532,3 +1532,45 @@ Contact:	Bean Huo <beanhuo@micron.com>
>  Description:
>  		rtc_update_ms indicates how often the host should synchronize or update the
>  		UFS RTC. If set to 0, this will disable UFS RTC periodic update.
> +
> +What:		/sys/devices/platform/.../ufshci_capabilities/capabilities
> +Date:		August 2024
> +Contact:	Avri Altman <avri.altman@wdc.com>
> +Description:
> +		Host Capabilities register group: host controller capabilities register.
> +		Symbol - CAP.  Offset: 0x00 - 0x03.

This doesn't look like an ABI description. You are merely specifying the
register name and offset that gets accessed while reading this attribute.

Also, I'm not sure if we really want to expose HCI/MCQ capabilities as sysfs
ABI. This just prints the hex value without even telling users how to interpret
it. 

> +
> +What:		/sys/devices/platform/.../ufshci_capabilities/mcq_cap
> +Date:		August 2024
> +Contact:	Avri Altman <avri.altman@wdc.com>
> +Description:
> +		Host Capabilities register group: multi-circular queue capability register.
> +		Symbol - MCQCAP.  Offset: 0x04 - 0x07.
> +
> +What:		/sys/devices/platform/.../ufshci_capabilities/version
> +Date:		August 2024
> +Contact:	Avri Altman <avri.altman@wdc.com>
> +Description:
> +		Host Capabilities register group: UFS version register.
> +		Symbol - VER.  Offset: 0x08 - 0x0B.

This and below attributes are fine. But the description should be changed. No
need to put register name and offset here, that is not relevant to the ABI.
Description should clearly state what is the purpose of the attribute, how to
interpret (if necessary) and read/write capability. Like,

```
	This file shows the UFSHCD version.

	The file is read only.
```

Applies to other attributes below.

- Mani

> +
> +What:		/sys/devices/platform/.../ufshci_capabilities/ext_capabilities
> +Date:		August 2024
> +Contact:	Avri Altman <avri.altman@wdc.com>
> +Description:
> +		Host Capabilities register group: extended controller capabilities register.
> +		Symbol - EXT_CAP.  Offset: 0x0C - 0x0F.
> +
> +What:		/sys/devices/platform/.../ufshci_capabilities/product_id
> +Date:		August 2024
> +Contact:	Avri Altman <avri.altman@wdc.com>
> +Description:
> +		Host Capabilities register group: product ID register.
> +		Symbol - HCPID.  Offset: 0x10 - 0x13.
> +
> +What:		/sys/devices/platform/.../ufshci_capabilities/man_id
> +Date:		August 2024
> +Contact:	Avri Altman <avri.altman@wdc.com>
> +Description:
> +		Host Capabilities register group: manufacturer ID register.
> +		Symbol - HCMID.  Offset: 0x14 - 0x17.
> diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
> index dec7746c98e0..751d5ff406da 100644
> --- a/drivers/ufs/core/ufs-sysfs.c
> +++ b/drivers/ufs/core/ufs-sysfs.c
> @@ -525,6 +525,100 @@ static const struct attribute_group ufs_sysfs_capabilities_group = {
>  	.attrs = ufs_sysfs_capabilities_attrs,
>  };
>  
> +static ssize_t capabilities_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +
> +	return sysfs_emit(buf, "0x%x\n", hba->capabilities);
> +}
> +
> +static ssize_t mcq_cap_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +
> +	if (hba->ufs_version < ufshci_version(4, 0))
> +		return -EOPNOTSUPP;
> +
> +	return sysfs_emit(buf, "0x%x\n", hba->mcq_capabilities);
> +}
> +
> +static ssize_t version_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +
> +	return sysfs_emit(buf, "0x%x\n", hba->ufs_version);
> +}
> +
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
> +
> +static ssize_t product_id_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	int ret;
> +	u32 val;
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +
> +	ret = ufshcd_read_hci_reg(hba, &val, REG_CONTROLLER_PID);
> +	if (ret)
> +		return ret;
> +
> +	return sysfs_emit(buf, "0x%x\n", val);
> +}
> +
> +static ssize_t man_id_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	int ret;
> +	u32 val;
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +
> +	ret = ufshcd_read_hci_reg(hba, &val, REG_CONTROLLER_MID);
> +	if (ret)
> +		return ret;
> +
> +	return sysfs_emit(buf, "0x%x\n", val);
> +}
> +
> +static DEVICE_ATTR_RO(capabilities);
> +static DEVICE_ATTR_RO(mcq_cap);
> +static DEVICE_ATTR_RO(version);
> +static DEVICE_ATTR_RO(ext_capabilities);
> +static DEVICE_ATTR_RO(product_id);
> +static DEVICE_ATTR_RO(man_id);
> +
> +static struct attribute *ufs_sysfs_ufshci_cap_attrs[] = {
> +	&dev_attr_capabilities.attr,
> +	&dev_attr_mcq_cap.attr,
> +	&dev_attr_version.attr,
> +	&dev_attr_ext_capabilities.attr,
> +	&dev_attr_product_id.attr,
> +	&dev_attr_man_id.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group ufs_sysfs_ufshci_group = {
> +	.name = "ufshci_capabilities",
> +	.attrs = ufs_sysfs_ufshci_cap_attrs,
> +};
> +
>  static ssize_t monitor_enable_show(struct device *dev,
>  				   struct device_attribute *attr, char *buf)
>  {
> @@ -1508,6 +1602,7 @@ static const struct attribute_group ufs_sysfs_attributes_group = {
>  static const struct attribute_group *ufs_sysfs_groups[] = {
>  	&ufs_sysfs_default_group,
>  	&ufs_sysfs_capabilities_group,
> +	&ufs_sysfs_ufshci_group,
>  	&ufs_sysfs_monitor_group,
>  	&ufs_sysfs_power_info_group,
>  	&ufs_sysfs_device_descriptor_group,
> -- 
> 2.25.1
> 
> 

-- 
மணிவண்ணன் சதாசிவம்
