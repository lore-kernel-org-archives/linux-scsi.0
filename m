From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [bug report] scsi: myrs: Add Mylex RAID controller (SCSI interface)
Date: Tue, 13 Feb 2018 21:22:45 -0500
Message-ID: <yq1wozgpax6.fsf@oracle.com>
References: <20180213143727.GA21178@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35418 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966382AbeBNCWv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Feb 2018 21:22:51 -0500
In-Reply-To: <20180213143727.GA21178@mwanda> (Dan Carpenter's message of "Tue,
        13 Feb 2018 17:37:27 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de
Cc: Dan Carpenter <dan.carpenter@oracle.com>, linux-scsi@vger.kernel.org


Hannes,

> The patch 8a8606895947: "scsi: myrs: Add Mylex RAID controller (SCSI
> interface)" from Jan 24, 2018, leads to the following static checker
> warning:

I dropped the two Mylex patches from 4.17/scsi-queue for now. Please fix
the issues reported and repost.

-- 
Martin K. Petersen	Oracle Linux Engineering
