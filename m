From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 7/8] megaraid_sas : Remove redundant code of memset load_balance_info to zero
Date: Tue, 06 Jan 2015 19:40:12 -0500
Message-ID: <yq1ppar5spf.fsf@sermon.lab.mkp.net>
References: <201501051440.t05EeUX5030081@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34390 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335AbbAGAkl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2015 19:40:41 -0500
In-Reply-To: <201501051440.t05EeUX5030081@palmhbs0.lsi.com> (Sumit Saxena's
	message of "Mon, 5 Jan 2015 20:06:28 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

>>>>> "Sumit" ==   <Sumit.Saxena@avagotech.com> writes:

Sumit> struct fusion_context *fusion is already memset to '0', so remove
Sumit> redundant code of meset "fusion->load_balance_info" to '0'.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
