From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH-v2 07/15] target: Add internal READ_INSERT support
Date: Tue, 07 Apr 2015 19:34:15 -0400
Message-ID: <yq17ftnh5s8.fsf@sermon.lab.mkp.net>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com>
	<1427686104-14231-8-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28864 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbbDGXe2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2015 19:34:28 -0400
In-Reply-To: <1427686104-14231-8-git-send-email-nab@daterainc.com> (Nicholas
	A. Bellinger's message of "Mon, 30 Mar 2015 03:28:16 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>

>>>>> "nab" == Nicholas A Bellinger <nab@daterainc.com> writes:

nab> This patch adds READ_INSERT support in target_check_read_prot()
nab> that invokes sbc_dif_generate() when LIO is responsible for
nab> generating the outgoing T10-PI.

nab> Required for supporting fabrics that exchange protection
nab> information, and would like to function with un-protected devices.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
