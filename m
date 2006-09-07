From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic94xx: Fix incorrect memory allocation size
Date: Thu, 07 Sep 2006 14:38:56 -0500
Message-ID: <1157657936.3462.81.camel@mulgrave.il.steeleye.com>
References: <20060907183936.GA3713@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:8881 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751833AbWIGTi7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Sep 2006 15:38:59 -0400
In-Reply-To: <20060907183936.GA3713@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: malahal@us.ibm.com
Cc: linux-scsi@vger.kernel.org

On Thu, 2006-09-07 at 11:39 -0700, malahal@us.ibm.com wrote:
> This patch corrects the size passed to kmalloc in asd_register_sas_ha()

Actually, could you fix this properly?  It should be in the scsi host
structure or something related so its lifetime is that of the SCSI host,
then we don't need to worry about tracking it.  The kmalloc was only a
first approximation hack to get the driver to work with multiple
controllers.

Thanks,

James


