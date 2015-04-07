From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH-v2 04/15] target: Move cmd->prot_op check into target_check_write_prot
Date: Tue, 07 Apr 2015 19:30:25 -0400
Message-ID: <yq1k2xnh5ym.fsf@sermon.lab.mkp.net>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com>
	<1427686104-14231-5-git-send-email-nab@daterainc.com>
	<55190206.90207@dev.mellanox.co.il>
	<1427867667.9176.197.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31747 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933177AbbDGXam (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2015 19:30:42 -0400
In-Reply-To: <1427867667.9176.197.camel@haakon3.risingtidesystems.com>
	(Nicholas A. Bellinger's message of "Tue, 31 Mar 2015 22:54:27 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Christoph Hellwig <hch@lst.de>

>>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:

>> This patch moves the existing target_execute_cmd() check for
>> cmd->prot_op into it's own function, so it's easier to add future
>> support for WRITE STRIP.

nab> Makes sense.  Renamed to target_write_prot_action()

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
