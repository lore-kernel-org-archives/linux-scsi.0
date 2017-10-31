From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_debug: write_same: fix error report
Date: Tue, 31 Oct 2017 08:31:58 -0400
Message-ID: <yq1k1zbcxc1.fsf@oracle.com>
References: <20171029144719.32591-1-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18299 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751746AbdJaMcI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Oct 2017 08:32:08 -0400
In-Reply-To: <20171029144719.32591-1-dgilbert@interlog.com> (Douglas Gilbert's
        message of "Sun, 29 Oct 2017 10:47:19 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, hare@suse.de


Doug,

> The scsi_debug driver incorrectly suggests there is an error with
> the SCSI WRITE SAME command when the number_of_logical_blocks is
> greater than 1. It will also suggest there is an error when NDOB
> (no data-out buffer) is set and the number_of_logical_blocks is
> greater than 0. Both are valid, fix. 

Applied to 4.15/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
