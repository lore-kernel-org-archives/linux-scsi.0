Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948D31E32C3
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2025 08:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750838407; cv=none; b=kMUPcrKcF8GTHa+f1rPkZsUzhPjuIhmuhEBIsSrdhDGVVxZslJ+RkyKE1fAKMD1beM7ikH/bVj5efdPo0l48CZx8wT2+CcZk/LQ3FP9ETpDrAoIO8Y4GMkS7O0IO3GPVmuUwmzf51wk/5lXeN6ZCcCpKA2JajbrCLc2sJhVZL4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750838407; c=relaxed/simple;
	bh=lVa1TE20rmEJJ2Mq0lv+gfs/2O65C3Y/q0L4yQkrcjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jpVJeRmnG7bVQp3YTv8dybxa356U4kAl6EVNH9epVpnAloIXbe1HHqFXiBRsyOxI3lbW20oPFEkdq/xdkIHocsT0wFVMyyrDnmMimxDXwrvXRodoRaDniG4fkjITQQipknSHHTNfkVUGln6G58WX+VHsLsJV8XvZ3uU+ZwMjO6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b8nFAegU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b8nFAegU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85BFC4CEF1;
	Wed, 25 Jun 2025 08:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750838407;
	bh=lVa1TE20rmEJJ2Mq0lv+gfs/2O65C3Y/q0L4yQkrcjU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b8nFAegUqIVbcANtCTFxwKluIPekVjt/DVSQHt/BcgOQeA+ji2mbeaeVTrsiuZk6c
	 NRCHoLDOoG3lUioARrZHGgPTZMWIvH7F48IDOe8y05UZZHbJOyuS9ymqO9S5BZDw6/
	 BDLpj+PcL3OTZbN0DjUpm2uFpHUSbIatnXbNvLyE=
Date: Wed, 25 Jun 2025 09:00:02 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Bean Huo <huobean@gmail.com>, Huan Tang <tanghuan@vivo.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Ziqi Chen <quic_ziqichen@quicinc.com>,
	Keoseong Park <keosung.park@samsung.com>,
	Gwendal Grignou <gwendal@chromium.org>,
	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] scsi: ufs: core: Fix spelling of a sysfs attribute name
Message-ID: <2025062523-cheesy-engaged-88e9@gregkh>
References: <20250624181658.336035-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250624181658.336035-1-bvanassche@acm.org>

On Tue, Jun 24, 2025 at 11:16:44AM -0700, Bart Van Assche wrote:
> Change "resourse" into "resource" in the name of a sysfs attribute.
> 
> Fixes: d829fc8a1058 ("scsi: ufs: sysfs: unit descriptor")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  Documentation/ABI/testing/sysfs-driver-ufs | 2 +-
>  drivers/ufs/core/ufs-sysfs.c               | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
> index f3de8c521bbd..a90612ab5780 100644
> --- a/Documentation/ABI/testing/sysfs-driver-ufs
> +++ b/Documentation/ABI/testing/sysfs-driver-ufs
> @@ -711,7 +711,7 @@ Description:	This file shows the thin provisioning type. This is one of
>  
>  		The file is read only.
>  
> -What:		/sys/class/scsi_device/*/device/unit_descriptor/physical_memory_resourse_count
> +What:		/sys/class/scsi_device/*/device/unit_descriptor/physical_memory_resource_count
>  Date:		February 2018

As you are changing the name of a sysfs file that has been in the kernel
for a very long time, what userspace code is now going to break that was
using the old name?

thanks,

greg k-h
