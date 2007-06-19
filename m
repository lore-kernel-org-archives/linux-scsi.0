From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] aacraid: add sysfs support for driver_version
Date: Tue, 19 Jun 2007 15:27:18 -0500
Message-ID: <46783C26.7060908@linux.vnet.ibm.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF01B22E32@otce2k301.adaptec.com>
Reply-To: brking@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36829 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932242AbXFSU1W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jun 2007 16:27:22 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5JKSRms014579
	for <linux-scsi@vger.kernel.org>; Tue, 19 Jun 2007 16:28:27 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5JKRJsn465486
	for <linux-scsi@vger.kernel.org>; Tue, 19 Jun 2007 16:27:19 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5JKRJlu016048
	for <linux-scsi@vger.kernel.org>; Tue, 19 Jun 2007 16:27:19 -0400
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01B22E32@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org

Salyzyn, Mark wrote:
> Adding sysfs support for driver_version.

This is already available in /sys/module/aacraid/version

Is this insufficient?

-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center
