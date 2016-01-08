From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] 3w-xxxx: pass through compat mode ioctls
Date: Fri, 08 Jan 2016 12:14:23 -0500
Message-ID: <yq11t9sgfio.fsf@sermon.lab.mkp.net>
References: <1451022327-26943-1-git-send-email-nemesis@icequake.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21944 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbcAHRO2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jan 2016 12:14:28 -0500
In-Reply-To: <1451022327-26943-1-git-send-email-nemesis@icequake.net> (Ryan
	C. Underwood's message of "Thu, 24 Dec 2015 21:45:27 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ryan C. Underwood" <nemesis@icequake.net>
Cc: linux-scsi@vger.kernel.org

>>>>> "Ryan" == Ryan C Underwood <nemesis@icequake.net> writes:

Ryan> This allows 32-bit userspace tools (tw_cli, smartctl) to work on a
Ryan> 64-bit system.  The command buffer is opaque to us, so, no word
Ryan> size problems.

Applied to 4.5/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
