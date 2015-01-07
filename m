From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/8] megaraid_sas : Support for secure JBOD
Date: Tue, 06 Jan 2015 19:30:10 -0500
Message-ID: <yq1bnmb77ql.fsf@sermon.lab.mkp.net>
References: <201501051440.t05Ee5m5029978@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19544 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391AbbAGAas (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2015 19:30:48 -0500
In-Reply-To: <201501051440.t05Ee5m5029978@palmhbs0.lsi.com> (Sumit Saxena's
	message of "Mon, 5 Jan 2015 20:06:03 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

>>>>> "Sumit" ==   <Sumit.Saxena@avagotech.com> writes:

Sumit> This patch will add support for Secure Encrypting Drives(SED) in
Sumit> JBOD mode. below are the key points- 1) If Firmware supports SED
Sumit> JBOD, all non Read Write commands to JBODs will be sent via
Sumit> Firmware path and Read write commands to JBOD will be sent via
Sumit> fastpath.  2) If firmware does not support SED JBOD, driver will
Sumit> fall back to old design .i.e send all JBOD IOs via fastpath.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
