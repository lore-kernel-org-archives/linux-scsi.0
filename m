From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi_device_put unused variable module without
	CONFIG_MODULE_UNLOAD
Date: Wed, 22 Nov 2006 09:15:27 -0600
Message-ID: <1164208527.2785.6.camel@mulgrave.il.steeleye.com>
References: <5b8c107f6d06b70065ca44309be0dcbf@pinky>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:28054 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1754665AbWKVPPb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Nov 2006 10:15:31 -0500
In-Reply-To: <5b8c107f6d06b70065ca44309be0dcbf@pinky>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>

On Wed, 2006-11-22 at 14:39 +0000, Andy Whitcroft wrote:
> scsi_device_put: unused variable module without CONFIG_MODULE_UNLOAD
> 
> When CONFIG_MODULE_UNLOAD is not defined then the module variable
> in scsi_device_put() becomes unused resulting in the warnings below.
> Move this inside the existing #ifdef.
> 
>   .../drivers/scsi/scsi.c:883: warning: unused variable 'module'

Actually, the fix for this is already in scsi-misc, so it should be
making its way into -mm.

James


