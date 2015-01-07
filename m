From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 5/8] megaraid_sas : Complete outstanding IOCTLs before killing adapter
Date: Tue, 06 Jan 2015 19:32:53 -0500
Message-ID: <yq1387n77m2.fsf@sermon.lab.mkp.net>
References: <201501051440.t05EeK2W030041@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31962 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbbAGAdX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2015 19:33:23 -0500
In-Reply-To: <201501051440.t05EeK2W030041@palmhbs0.lsi.com> (Sumit Saxena's
	message of "Mon, 5 Jan 2015 20:06:18 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

>>>>> "Sumit" ==   <Sumit.Saxena@avagotech.com> writes:

Sumit> Driver calls megasas_complete_cmd() to call wake_up() for each
Sumit> MFI frame that was issued through the ioctl() interface prior to
Sumit> the kill adapter.  This ensures userspace ioctl() system calls
Sumit> issued just before a kill adapter don't get stuck in wait state
Sumit> and IOCTLs are returned to application.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
