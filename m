From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH-v2 05/15] target: Add internal WRITE_STRIP support
Date: Tue, 07 Apr 2015 19:32:17 -0400
Message-ID: <yq1fv8bh5vi.fsf@sermon.lab.mkp.net>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com>
	<1427686104-14231-6-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32372 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbbDGXc2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2015 19:32:28 -0400
In-Reply-To: <1427686104-14231-6-git-send-email-nab@daterainc.com> (Nicholas
	A. Bellinger's message of "Mon, 30 Mar 2015 03:28:14 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>

>>>>> "nab" == Nicholas A Bellinger <nab@daterainc.com> writes:

nab> This patch adds WRITE_STRIP support in target_check_write_prot()
nab> that invokes sbc_dif_verify_write() for checking T10-PI metadata
nab> before submitting the I/O to a backend driver.

With Sagi's suggestions.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
