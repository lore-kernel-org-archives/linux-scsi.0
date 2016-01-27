From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] hisi_sas: fix v1 hw check for slot error
Date: Tue, 26 Jan 2016 21:19:29 -0500
Message-ID: <yq1twlzhiha.fsf@sermon.lab.mkp.net>
References: <1453829477-40725-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19476 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbcA0CTi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2016 21:19:38 -0500
In-Reply-To: <1453829477-40725-1-git-send-email-john.garry@huawei.com> (John
	Garry's message of "Wed, 27 Jan 2016 01:31:17 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: JBottomley@odin.com, martin.petersen@oracle.com, linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ricardo.salveti@linaro.org

>>>>> "John" == John Garry <john.garry@huawei.com> writes:

John> Completion header bit CMPLT_HDR_RSPNS_XFRD flags whether the
John> response frame is received into host memory, and not whether the
John> response frame has an error.  As such, change the decision on
John> whether a slot has an error.  Also redundant check on
John> CMPLT_HDR_CMD_CMPLT_MSK is removed.

Applied to 4.5/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
