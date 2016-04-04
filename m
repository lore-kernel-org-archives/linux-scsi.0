From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 00/14] libata: SATL update
Date: Mon, 4 Apr 2016 11:46:52 -0400
Message-ID: <20160404154652.GT7822@mtj.duckdns.org>
References: <1459763047-125551-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:34083 "EHLO
	mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938AbcDDPq4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2016 11:46:56 -0400
Content-Disposition: inline
In-Reply-To: <1459763047-125551-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>

Hello, Hannes.

Applied the series to libata/for-4.7-zac with cosmetic updates
((s64)-1 -> UINT64_MAX, kbuild warning fixes and other formatting
updates).

Thanks.

-- 
tejun
