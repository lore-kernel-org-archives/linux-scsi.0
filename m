From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 16/20] [SCSI] mpt3sas: Added support for customer specific branding
Date: Fri, 19 Jun 2015 16:44:46 -0400
Message-ID: <yq1k2uza0n5.fsf@sermon.lab.mkp.net>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1434102153-38581-17-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43390 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276AbbFSUpP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2015 16:45:15 -0400
In-Reply-To: <1434102153-38581-17-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Fri, 12 Jun 2015 15:12:28 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org

>>>>> Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

> Added support for below customer specific brandings "VendorID"
> "DeviceID" "SubsystemVendor ID" "SubsystemDevice ID" Cisco Branding
> String 0x1000 0x97 0x1137 0x154 Cisco 9300-8i 12Gbps SAS HBA 0x1000
> 0x97 0x1137 0x155 Cisco 12G Modular SAS Pass through Controller 0x1000
> 0x97 0x1137 0x156 UCS C3X60 12G SAS Pass through Controller

Same comment about not actually changing driver behavior.

These changes belong in pci.ids, not in a driver.

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
