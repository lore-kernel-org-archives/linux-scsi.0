From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [RFC] IBM Power RAID driver (ipr)
Date: Mon, 19 Jan 2004 11:33:54 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040119193354.GC967@beaverton.ibm.com>
References: <40085EDA.4010802@us.ibm.com> <20040119183400.A4182@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:5020 "EHLO e35.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S261973AbUASTaN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 14:30:13 -0500
Content-Disposition: inline
In-Reply-To: <20040119183400.A4182@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org

Christoph Hellwig [hch@infradead.org] wrote:
> +/**
> + * ipr_version_show - Show the driver version
> + * @dd:	device driver struct
> + * @buf:	buffer
> + * 
> + * Return value:
> + * 	number of bytes printed to buffer
> + **/
> +static ssize_t ipr_version_show(struct device_driver *dd, char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%s\n", IPR_DRIVER_VERSION);
> +}
> +
> +static DRIVER_ATTR(version, S_IRUGO, ipr_version_show, NULL);
> 
> Please don't do this in sysfs.  We're still hoping for a MODULE_VERSION
> macro, but every driver crafting it's own version telling mechanism
> doesn't scale.
> 

This is my fault. We recommended not to include procfs info in this
driver and pointed to sysfs. Do we have a timeline on MODULE_VERSION?

-andmike
--
Michael Anderson
andmike@us.ibm.com

