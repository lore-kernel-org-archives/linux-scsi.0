From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 11/20] [SCSI] mpt3sas: Add branding string support for OEM custom HBA
Date: Fri, 19 Jun 2015 16:34:56 -0400
Message-ID: <yq1616jbfnz.fsf@sermon.lab.mkp.net>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1434102153-38581-12-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17961 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbbFSUf7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2015 16:35:59 -0400
In-Reply-To: <1434102153-38581-12-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Fri, 12 Jun 2015 15:12:23 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org

>>>>> Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

> Add the following OEM's branding to the mpt3sas driver.  "VendorID"
> "DeviceID" "SubsystemVendor ID" "SubsystemDevice ID" Cisco Branding
> String 0x1000 0x97 SVID = 0x1137 0x014C Cisco 9300-8E 12G SAS HBA

I'm not so keen on all this branding stuff. It is purely cosmetic and
doesn't change driver behavior.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
