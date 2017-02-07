From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1 0/8] scsi: ufs: enhancements, bug fixes and debug support
Date: Tue, 07 Feb 2017 18:06:00 -0500
Message-ID: <yq160klppnr.fsf@oracle.com>
References: <1486169790-22655-1-git-send-email-subhashj@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38762 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932601AbdBGXGP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2017 18:06:15 -0500
In-Reply-To: <1486169790-22655-1-git-send-email-subhashj@codeaurora.org>
        (Subhash Jadavani's message of "Fri, 3 Feb 2017 16:56:30 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

>>>>> "Subhash" == Subhash Jadavani <subhashj@codeaurora.org> writes:

Subhash> This patch series adds following things: - Gear scaling during
Subhash> clock scaling to save additional power - Make clock scaling
Subhash> independent clock gating so that we can set lower clock gating
Subhash> timeout than clock scaling window - one bug fix to clock
Subhash> scaling - additional debug support

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
