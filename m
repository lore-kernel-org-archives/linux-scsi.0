From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 6/10] megaraid_sas : Chip reset if driver fail to bring ioc ready
Date: Thu, 03 Sep 2015 23:31:35 -0400
Message-ID: <yq1y4gm97xk.fsf@sermon.lab.mkp.net>
References: <201508311159.t7VBxAP7031418@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18882 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbbIDDcP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2015 23:32:15 -0400
In-Reply-To: <201508311159.t7VBxAP7031418@palmhbs0.lsi.com> (sumit saxena's
	message of "Mon, 31 Aug 2015 17:23:41 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sumit.saxena@avagotech.com
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, kiran-kumar.kasturi@avagotech.com, uday.lingala@avagotech.com

>>>>> "Sumit" == sumit saxena <sumit.saxena@avagotech.com> writes:

Sumit> This patch will try to do chip reset from driver load time.
Sumit> Driver load time, if firmware is not comming to ready state,
Sumit> driver try chip reset calling adp_reset() callback. For fusion
Sumit> adapter, that call back was void, so it will not do any chip
Sumit> reset.

Sumit> Now, using this patch megasas_adp_reset_fusion() will have chip
Sumit> reset logic for Fusion adapter.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
