From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi:fnic Avoid sending reset to fnic firmware when another reset is already in progress
Date: Thu, 05 Jan 2017 20:42:32 -0500
Message-ID: <yq11swhj75j.fsf@oracle.com>
References: <1481750441-15755-1-git-send-email-satishkh@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35856 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752624AbdAFBmy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jan 2017 20:42:54 -0500
In-Reply-To: <1481750441-15755-1-git-send-email-satishkh@cisco.com> (Satish
        Kharat's message of "Wed, 14 Dec 2016 13:20:41 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Satish Kharat <satishkh@cisco.com>
Cc: linux-scsi@vger.kernel.org, Sesidhar Baddela <sebaddel@cisco.com>

>>>>> "Satish" == Satish Kharat <satishkh@cisco.com> writes:

Satish,

Satish> This fix is to avoid calling fnic_fw_reset_handler through
Satish> fnic_host_reset when a finc reset is alreay in progress.

Applied to 4.10/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
