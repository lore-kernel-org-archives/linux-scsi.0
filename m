From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 8/10] megaraid_sas : Fix validHandles check in io path
Date: Thu, 03 Sep 2015 23:34:03 -0400
Message-ID: <yq1pp1y97tg.fsf@sermon.lab.mkp.net>
References: <201508311159.t7VBxUKb031439@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19398 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbbIDDel (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2015 23:34:41 -0400
In-Reply-To: <201508311159.t7VBxUKb031439@palmhbs0.lsi.com> (sumit saxena's
	message of "Mon, 31 Aug 2015 17:24:01 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sumit.saxena@avagotech.com
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, kiran-kumar.kasturi@avagotech.com, uday.lingala@avagotech.com

>>>>> "Sumit" == sumit saxena <sumit.saxena@avagotech.com> writes:

Sumit> Syncro firmware supports round robin IO switch on dual path. For
Sumit> this driver use validHandles as a check for dual path. This check
Sumit> suppose to be > 1 (not > 2)

Sumit> Without this patch, earlier driver code does not use dual path
Sumit> functionality.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
