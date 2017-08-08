From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: megaraid_sas: fix error handle in megasas_probe_one
Date: Mon, 07 Aug 2017 21:55:58 -0400
Message-ID: <yq1mv7a961d.fsf@oracle.com>
References: <20170807172650.GA33146@bogon.didichuxing.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47120 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751583AbdHHB4G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2017 21:56:06 -0400
In-Reply-To: <20170807172650.GA33146@bogon.didichuxing.com> (weiping zhang's
        message of "Tue, 8 Aug 2017 01:26:57 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: weiping zhang <zhangweiping@didichuxing.com>
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org


weiping,

> megasas_mgmt_info.max_index has increased by 1 before
> megasas_io_attach, if megasas_io_attach return error, then goto
> fail_io_attach, megasas_mgmt_info.instance has a wrong index here. So
> first reduce max_index and then set that instance to NULL.

Applied to 4.13/scsi-fixes, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
