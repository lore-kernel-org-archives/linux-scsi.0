From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 1/9] ufs: sysfs: device descriptor
Date: Wed, 27 Dec 2017 16:19:04 +0100
Message-ID: <20171227151904.GA20967@kroah.com>
References: <1514387627-27817-1-git-send-email-stanislav.nijnikov@wdc.com>
 <1514387627-27817-2-git-send-email-stanislav.nijnikov@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1514387627-27817-2-git-send-email-stanislav.nijnikov@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, alex.lemberg@wdc.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 27, 2017 at 05:13:39PM +0200, Stanislav Nijnikov wrote:
> +EXPORT_SYMBOL(ufs_sysfs_add_device_management);

Whhy is this exported?  What external module uses it?

> +
> +void ufs_sysfs_remove_device_management(struct ufs_hba *hba)
> +{
> +	sysfs_remove_groups(&hba->dev->kobj, ufs_sysfs_groups);
> +}
> +EXPORT_SYMBOL(ufs_sysfs_remove_device_management);
> +
> +MODULE_LICENSE("GPL");

Are you sure you didn't just put 2 module license fields in the same
module?

Other than those nits, looks good!

thanks,

greg k-h
