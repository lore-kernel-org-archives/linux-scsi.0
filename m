Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B4115E8B
	for <linux-scsi@vger.kernel.org>; Tue,  6 Aug 2024 02:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722909970; cv=none; b=VilT9s0l+IxmgEVjlJ2ZKCzdDOMhWLe9WmuwZl16TDaUHT0kU3cjy0U7nNTSZzBML9x02v0Bl6hKyFs4I0u7+FqqAfqrvcnnAvr4UQ/UVm3WY0X3WmFzy6UJuyO/13MSfSWbxtFHLEOO3aO9URSJWR0GAs2XKIo4ADDggAYNwOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722909970; c=relaxed/simple;
	bh=Ee0QM6Iac7kLd+h7JVmmERG0VuReSQIOXKhNXlBuItY=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=oid1meaC8swNEZDaNpWrxACxnMxBtXz7WKxYwlNjP9hs1W0IeBtuz9uNOSbNHEtGVq4lnFORvliUsirM8Z2kb96ScmKh8axagMDSYJJtnC+0KucqszmIhBDKdmd6Gzn0UZJNA6gkyi6DqQ9W4mWh+r8y3NbUEOC9ZEPELbBk26w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=rsgJdEFP; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="rsgJdEFP"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240806020605epoutp038342cc3b46746807b59b5a7aa164b196~pAXxEffck0643506435epoutp03j
	for <linux-scsi@vger.kernel.org>; Tue,  6 Aug 2024 02:06:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240806020605epoutp038342cc3b46746807b59b5a7aa164b196~pAXxEffck0643506435epoutp03j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1722909965;
	bh=Wjd9XclQm98fGNHa1n403/XjT0pQYvGrYOFwOWSetSs=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=rsgJdEFPYBKOiF5wc2Oma82v1HcfwRdyNhebbButDhNCDhN0hoPBYfSw+ENn8Hm6w
	 xyzVG13fer4dPZJv7Bl4PHYFIiiYWky/SsxAuC3+8RamrXL33MRhkAXR9Z7XPdddyo
	 U2xjKcL9V2HtA7OucHYY62Tx8ZKF1/6Fqfq2olIM=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTP id
	20240806020605epcas2p12eb902f7945f67259dcc1cd88cbadfe0~pAXw3SHkN2742427424epcas2p1q;
	Tue,  6 Aug 2024 02:06:05 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.89]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4WdGqw4cjbz4x9QB; Tue,  6 Aug
	2024 02:06:04 +0000 (GMT)
X-AuditID: b6c32a47-ea1fa7000000271c-6b-66b1850c2bcb
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
	epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
	CA.F1.10012.C0581B66; Tue,  6 Aug 2024 11:06:04 +0900 (KST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE: [PATCH v2 2/2] scsi: ufs: Add HCI capabilities sysfs group
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From: Keoseong Park <keosung.park@samsung.com>
To: Avri Altman <avri.altman@wdc.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Bart Van
	Assche <bvanassche@acm.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20240804072109.2330880-3-avri.altman@wdc.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20240806020604epcms2p3c9b035a6ef19e3b8b241d1ecadc03043@epcms2p3>
Date: Tue, 06 Aug 2024 11:06:04 +0900
X-CMS-MailID: 20240806020604epcms2p3c9b035a6ef19e3b8b241d1ecadc03043
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplk+LIzCtJLcpLzFFi42LZdljTQpendWOawZJDshYvf15ls5j24Sez
	xctDmhaPbj9jtLi8aw6bRff1HWwWy4//Y3Jg97h8xdvj49NbLB59W1YxenzeJOfRfqCbKYA1
	KtsmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+gIJYWy
	xJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUmpBSk6BeYFecWJucWleul5eaomVoYGBkSlQYUJ2
	xtQZ95gKDphUzF+9gaWB8aZ2FyMnh4SAicSTBctYuxi5OIQEdjBK7L28kKWLkYODV0BQ4u8O
	YZAaYQF3iaObjrKD2EICShJdC7cyQ8QNJNZN3wNmswnoSUz5fYcRxBYRiJY4Om83I8hMZoFl
	jBIf+8+zQCzjlZjR/hTKlpbYvnwrWAOngLXEnbmnmSDiGhI/lvUyQ9iiEjdXv2WHsd8fm88I
	YYtItN47C1UjKPHg526ouITEuQ8LoebXS7S+P8UOcoSEwARGicZjf6AG6Utc69gIVsQr4Csx
	cSbEESwCqhKvz65hg6hxkfj08BFYnFlAXmL72znMoEBhFtCUWL9LH8SUEFCWOHKLBaKCT6Lj
	8F92mBcbNv7Gyt4x7wnUi2oSjxZsYZ3AqDwLEdKzkOyahbBrASPzKkax1ILi3PTUYqMCY3jk
	JufnbmIEp0ct9x2MM95+0DvEyMTBeIhRgoNZSYS3q3RDmhBvSmJlVWpRfnxRaU5q8SFGU6Av
	JzJLiSbnAxN0Xkm8oYmlgYmZmaG5kamBuZI4773WuSlCAumJJanZqakFqUUwfUwcnFINTIt8
	t5op3K45cFzb7I+hQOrr6U3LPzO6nrim9+VftNrjSd9KfDT1nboVHr1eIF944Fdo2Kd9wc+O
	sam7s93RvuOjNM9Y2uOCfl23b9dc/hrx2VrCVW3TN5pWbZ74reDDtONLvDKuOnBVZYYce2fp
	9V049OSvDzcMJ61Lnhkr6uW34be4l5rVXKaYG2nVR1/yhM63Xf7UcyLnpjOiIdfZN7t9ZuP/
	KB4hfV5zAptowSx1S9XotB/5fokf2WoObspbw7zt9j/m/5Naz3N9vBGuK6SYprEg+emLyqIf
	GjxVt58xT1wSIyxuEPQqSDTnUjbfyaTkBerX6hIyVym2xQsbKzGl3+6RebhIV+gVRwmbEktx
	RqKhFnNRcSIActgpkhgEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240804072321epcas2p3fbbda7858fe25be16ef6acb64b7a524e
References: <20240804072109.2330880-3-avri.altman@wdc.com>
	<20240804072109.2330880-1-avri.altman@wdc.com>
	<CGME20240804072321epcas2p3fbbda7858fe25be16ef6acb64b7a524e@epcms2p3>

Hi Avri,

> The standard register map of UFSHCI is comprised of several groups.  The
> first group (starting from offset 0x00), is the host capabilities group.
> It contains some interesting information, that otherwise is not
> available, e.g. the UFS version of the platform etc.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>  Documentation/ABI/testing/sysfs-driver-ufs | 48 +++++++++++
>  drivers/ufs/core/ufs-sysfs.c               | 95 ++++++++++++++++++++++
>  2 files changed, 143 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
> index fe943ce76c60..6c6cf12d25ca 100644
> --- a/Documentation/ABI/testing/sysfs-driver-ufs
> +++ b/Documentation/ABI/testing/sysfs-driver-ufs
> @@ -1532,3 +1532,51 @@ Contact:	Bean Huo <beanhuo@micron.com>
>  Description:
>  		rtc_update_ms indicates how often the host should synchronize or update the
>  		UFS RTC. If set to 0, this will disable UFS RTC periodic update.
> +
> +What:		/sys/bus/platform/drivers/ufshcd/ufshci_capabilities/capabilities
> +What:		/sys/bus/platform/devices/*.ufs/ufshci_capabilities/capabilities
> +Date:		August 2024
> +Contact:	Avri Altman <avri.altman@wdc.com>
> +Description:
> +		Host Capabilities register group: host controller capabiities register.

A nit: s/capabiities/capabilities

With above addressed,

Reviewed-by: Keoseong Park <keosung.park@samsung.com>

Best Regards,
Keoseong

> +		Symbol - CAP.  Offset: 0x00 - 0x03.
> +
> +What:		/sys/bus/platform/drivers/ufshcd/ufshci_capabilities/mcq_cap
> +What:		/sys/bus/platform/devices/*.ufs/ufshci_capabilities/mcq_cap
> +Date:		August 2024
> +Contact:	Avri Altman <avri.altman@wdc.com>
> +Description:
> +		Host Capabilities register group: multi-circular queue capability register.
> +		Symbol - MCQCAP.  Offset: 0x04 - 0x07.
> +
> +What:		/sys/bus/platform/drivers/ufshcd/ufshci_capabilities/version
> +What:		/sys/bus/platform/devices/*.ufs/ufshci_capabilities/version
> +Date:		August 2024
> +Contact:	Avri Altman <avri.altman@wdc.com>
> +Description:
> +		Host Capabilities register group: UFS version register.
> +		Symbol - VER.  Offset: 0x08 - 0x0B.
> +
> +What:		/sys/bus/platform/drivers/ufshcd/ufshci_capabilities/ext_capabilities
> +What:		/sys/bus/platform/devices/*.ufs/ufshci_capabilities/ext_capabilities
> +Date:		August 2024
> +Contact:	Avri Altman <avri.altman@wdc.com>
> +Description:
> +		Host Capabilities register group: extended controller capabilities register.
> +		Symbol - EXT_CAP.  Offset: 0x0C - 0x0F.
> +
> +What:		/sys/bus/platform/drivers/ufshcd/ufshci_capabilities/product_id
> +What:		/sys/bus/platform/devices/*.ufs/ufshci_capabilities/product_id
> +Date:		August 2024
> +Contact:	Avri Altman <avri.altman@wdc.com>
> +Description:
> +		Host Capabilities register group: product ID register.
> +		Symbol - HCPID.  Offset: 0x10 - 0x13.
> +
> +What:		/sys/bus/platform/drivers/ufshcd/ufshci_capabilities/man_id
> +What:		/sys/bus/platform/devices/*.ufs/ufshci_capabilities/man_id
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
