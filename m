From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH-v2 01/15] target: Convert DIF emulation to use cmd->prot_type
Date: Tue, 07 Apr 2015 19:22:52 -0400
Message-ID: <yq1wq1nh6b7.fsf@sermon.lab.mkp.net>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com>
	<1427686104-14231-2-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28991 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210AbbDGXXL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2015 19:23:11 -0400
In-Reply-To: <1427686104-14231-2-git-send-email-nab@daterainc.com> (Nicholas
	A. Bellinger's message of "Mon, 30 Mar 2015 03:28:10 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>

>>>>> "nab" == Nicholas A Bellinger <nab@daterainc.com> writes:

nab> This patch changes existing DIF emulation to check the command
nab> descriptor's prot_type, instead of what the backend device is
nab> exposing in pi_prot_type.

nab> Since this value is already set in sbc_check_prot(), go ahead and
nab> use it to allow protected fabrics to function with unprotected
nab> devices.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
