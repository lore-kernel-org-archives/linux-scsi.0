From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: hpsa: remove memory allocate failure message
Date: Wed, 14 Dec 2016 15:35:27 -0500
Message-ID: <yq1k2b2b65s.fsf@sermon.lab.mkp.net>
References: <1481540661-18493-1-git-send-email-kushwaha.a@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19370 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753849AbcLNUgH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2016 15:36:07 -0500
In-Reply-To: <1481540661-18493-1-git-send-email-kushwaha.a@samsung.com>
        (kushwaha a.'s message of "Mon, 12 Dec 2016 16:34:21 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kushwaha.a@samsung.com
Cc: don.brace@microsemi.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, akkushwaha9896@gmail.com, vidushi.koul@samsung.com

>>>>> "Amit" == kushwaha a <kushwaha.a@samsung.com> writes:

Amit> This patch cleanup warning reported by checkpatch.pl WARNING:
Amit> Possible unnecessary 'out of memory' message With no available
Amit> memory, a warn on message already gets printed by page alloc apis
Amit> and modified goto use if memory unallocated.

Applied to 4.10/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
