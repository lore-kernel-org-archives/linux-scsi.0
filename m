From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] mpt fusion: add sysfs attributes to display IOC parameters
Date: Thu, 12 Jul 2007 09:12:29 -0500
Message-ID: <469636CD.8000902@linux.vnet.ibm.com>
References: <20070712082230.GA27605@lsil.com>
Reply-To: brking@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:46131 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763411AbXGLOMb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jul 2007 10:12:31 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6CECU83010756
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jul 2007 10:12:30 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6CECULu259118
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jul 2007 08:12:30 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6CECTRT024485
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jul 2007 08:12:30 -0600
In-Reply-To: <20070712082230.GA27605@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <sathya.prakash@lsi.com>
Cc: linux-scsi@vger.kernel.org, eric.moore@lsi.com

Prakash, Sathya wrote:
> +static ssize_t
> +mptscsih_version_driver_show(struct class_device *cdev, char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%s\n", MPT_LINUX_VERSION_COMMON);
> +}
> +static CLASS_DEVICE_ATTR(version_driver, S_IRUGO, mptscsih_version_driver_show, NULL);

This should be removed from the patch. This information is already
available in sysfs: /sys/module/mptscsih/version

-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center
