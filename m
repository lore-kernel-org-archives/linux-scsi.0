From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/8] megaraid_sas : Fix the problem of non-existing VD exposed to host
Date: Tue, 06 Jan 2015 19:25:39 -0500
Message-ID: <yq1fvbn77y4.fsf@sermon.lab.mkp.net>
References: <201501051440.t05EeAgb029989@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29269 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbbAGA0J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2015 19:26:09 -0500
In-Reply-To: <201501051440.t05EeAgb029989@palmhbs0.lsi.com> (Sumit Saxena's
	message of "Mon, 5 Jan 2015 20:06:08 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

>>>>> "Sumit" ==   <Sumit.Saxena@avagotech.com> writes:

Sumit> For legacy firmware(64 VD firmware), invalidates LD(by setting LD
Sumit> value to 0xff) in LdTgtIdtoLd[] array for device index beyond
Sumit> 127, so that invalid LD(0xff) value should be returned beyond
Sumit> device index beyond 127.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
