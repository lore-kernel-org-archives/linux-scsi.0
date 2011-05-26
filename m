From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 3/9] [SCSI] mvsas: Add driver version and interrupt
 coalescing to device 	attributes in sysfs
Date: Wed, 25 May 2011 19:18:09 -0700
Message-ID: <20110526021809.GA22496@kroah.com>
References: <mvsas-intr-coal>
 <1306247507-6136-1-git-send-email-yxlraid@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1306247507-6136-1-git-send-email-yxlraid@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: yxlraid@gmail.com
Cc: James.Bottomley@suse.de, jslaby@suse.cz, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, yuxiangl@marvell.com, jfeng@marvell.com
List-Id: linux-scsi@vger.kernel.org

On Tue, May 24, 2011 at 10:31:47PM +0800, yxlraid@gmail.com wrote:
> From: Xiangliang Yu <yuxiangl@marvell.com>
> 
> -- Add support for driver version and interrupt coalescing device attributes.

When you add a sysfs file, you must also add a Documentation/ABI file as
well.  Please do that here.

thanks,

greg k-h
