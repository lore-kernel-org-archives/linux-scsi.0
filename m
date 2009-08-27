From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4/5] sd: Support disks formatted with DIF Type 2
Date: Thu, 27 Aug 2009 02:41:13 -0400
Message-ID: <yq1eiqx92t2.fsf@sermon.lab.mkp.net>
References: <1251267481-24135-1-git-send-email-martin.petersen@oracle.com>
	<1251267481-24135-5-git-send-email-martin.petersen@oracle.com>
	<4A9529F3.9070504@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:62668 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbZH0GlS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Aug 2009 02:41:18 -0400
In-Reply-To: <4A9529F3.9070504@panasas.com> (Boaz Harrosh's message of "Wed,
	26 Aug 2009 15:26:27 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org


>> + BUG_ON(rq->cmd_len != SCSI_EXT_CDB_SIZE);

Boaz> This is not nice you check on the rq->cmd_len but proceed to use
Boaz> the SCpnt->cmnd. Better ask for SCpnt->cmd_len, just for
Boaz> consistency

Well, I didn't actually mean to leave that BUG_ON in the hot path.  In
any case we won't get this far if the cmd_len is not 32.

-- 
Martin K. Petersen	Oracle Linux Engineering
