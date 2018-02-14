From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: scsi_debug: Fix pointer stying issues
Date: Tue, 13 Feb 2018 21:27:20 -0500
Message-ID: <yq1po58papj.fsf@oracle.com>
References: <1518228763-12937-1-git-send-email-jpittman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:38270 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966382AbeBNC12 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Feb 2018 21:27:28 -0500
In-Reply-To: <1518228763-12937-1-git-send-email-jpittman@redhat.com> (John
        Pittman's message of "Fri, 9 Feb 2018 21:12:43 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Pittman <jpittman@redhat.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org


John,

> Pointer styling issues exposed by checkpatch.pl in scsi_debug.c:
>
>    ERROR: "foo * bar" should be "foo *bar"
>
> Fixed 37 total errors reported.

Applied to 4.17/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
