From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v4 02/10] ufs: sysfs: device descriptor
Date: Thu, 1 Feb 2018 18:00:28 +0100
Message-ID: <20180201170028.GB12838@kroah.com>
References: <1517501746-19075-1-git-send-email-stanislav.nijnikov@wdc.com>
 <1517501746-19075-3-git-send-email-stanislav.nijnikov@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47572 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752864AbeBARAc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Feb 2018 12:00:32 -0500
Content-Disposition: inline
In-Reply-To: <1517501746-19075-3-git-send-email-stanislav.nijnikov@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jaegeuk@kernel.org, alex.lemberg@wdc.com

On Thu, Feb 01, 2018 at 06:15:38PM +0200, Stanislav Nijnikov wrote:
> +#define UFS_DESC_PARAM(_name, _puname, _duname, _size)                        \
> +static ssize_t _name##_show(struct device *dev,                               \
> +	struct device_attribute *attr, char *buf)                             \
> +{                                                                             \
> +	struct ufs_hba *hba = dev_get_drvdata(dev);                           \
> +	return ufs_sysfs_read_desc_param(hba, QUERY_DESC_IDN_##_duname,       \
> +		0, _duname##_DESC_PARAM##_puname,                             \
> +		buf, UFS_PARAM_##_size##_SIZE);                               \
> +}                                                                             \
> +static DEVICE_ATTR_RO(_name)

Nit, use tabs in your lines here to line up the trailing \

Same for other places in this patch series.

thanks,

greg k-h
