From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] ses: Fix SAS device detection in enclosure
Date: Tue, 17 Jan 2017 14:02:24 -0500
Message-ID: <yq1h94xo6gv.fsf@oracle.com>
References: <1483997616-18900-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25360 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750863AbdAQTCb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2017 14:02:31 -0500
In-Reply-To: <1483997616-18900-1-git-send-email-emilne@redhat.com> (Ewan
        D. Milne's message of "Mon, 9 Jan 2017 16:33:36 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org

>>>>> "Ewan" == Ewan D Milne <emilne@redhat.com> writes:

Ewan> The call to scsi_is_sas_rphy() needs to be made on the SAS
Ewan> end_device, not on the SCSI device.

Applied to 4.10/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
