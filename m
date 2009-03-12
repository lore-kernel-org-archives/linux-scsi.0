From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC][PATCH 3/6] fnic: Add support for Fibre Channel Services
 through	libFC
Date: Thu, 12 Mar 2009 15:36:04 -0500
Message-ID: <49B97234.5040801@cs.wisc.edu>
References: <20090228022152.12158.11200.stgit@feynman.nuovasystems.com> <20090228023209.12158.30405.stgit@feynman.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37376 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbZCLUgX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Mar 2009 16:36:23 -0400
In-Reply-To: <20090228023209.12158.30405.stgit@feynman.nuovasystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Abhijeet Joglekar <abjoglek@cisco.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, jeykholt@cisco.com

Abhijeet Joglekar wrote:

> +
> +static ssize_t fnic_show_drv_version(struct device *dev,
> +				     struct device_attribute *attr, char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%s\n", DRV_VERSION);
> +}


I think in the past we were supposed to just export this with the 
MODULE_VERSION() function (you can then see it /sys/module/fnic/version).

I saw other FC drivers put it on the host now though, so maybe it is ok now.
