From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1 06/20] [SCSI] mpt3sas: Provides the physical location of sas drives
Date: Fri, 19 Jun 2015 16:22:00 -0400
Message-ID: <yq1twu3bg9j.fsf@sermon.lab.mkp.net>
References: <1434711391-10016-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47967 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbbFSUWk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2015 16:22:40 -0400
In-Reply-To: <1434711391-10016-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Fri, 19 Jun 2015 16:26:31 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, jthumshirn@suse.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org

>>>>> Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

> This Patch will provide more details of the devices such as slot
> number, enclosure logical id, enclosure level & connector name in the
> following scenarios, - When end device is added in the topology, -
> When the end device is removed from the setup, - When the SCSI mid
> layer issues TASK ABORT/ DEVICE RESET/ TARGET RESET during error
> handling, - When any command to the device fails with Sense key
> Hardware error or Medium error or Unit Attention, - When firmware
> returns device error or device not ready status for the end device, -
> When a Predicted fault is detected on an end device.

> This information can be used by the user to identify the location of
> the desired drive in the topology.

> Driver will get these information by reading the sas device page0.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
