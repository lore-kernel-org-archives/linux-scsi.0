From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi_debug: implement IMMED bit
Date: Tue, 13 Feb 2018 21:29:07 -0500
Message-ID: <yq1lgfwpamk.fsf@oracle.com>
References: <20180210023639.8280-1-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39292 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966382AbeBNC3S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Feb 2018 21:29:18 -0500
In-Reply-To: <20180210023639.8280-1-dgilbert@interlog.com> (Douglas Gilbert's
        message of "Fri, 9 Feb 2018 21:36:39 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, hare@suse.de, bart.vanassche@wdc.com


Doug,

> The Start Stop Unit (SSU) command takes in the order of a second to
> complete on some SAS SSDs and longer on hard disks. Synchronize Cache
> (SC) can also take some time. Both commands have an IMMED bit in their
> cdbs for those apps that don't want to wait. This patch introduces a
> long delay for those commands when the IMMED bit is clear.  Since SC
> is a media access command then when the fake_rw option is active, its
> cdb processing is skipped and it returns immediately. The SSU command
> is not altered by the setting of the fake_rw option. These actions are
> not changed by this patch.

Applied to 4.17/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
