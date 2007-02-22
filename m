From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/2] sas_ata: Rename ata_queued_cmd->lldd_task to driver_data
Date: Thu, 22 Feb 2007 16:43:55 -0500
Message-ID: <45DE0E9B.60106@garzik.org>
References: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com> <20070130091841.31530.81645.stgit@elm3a70.beaverton.ibm.com> <45C98421.7020907@gmail.com> <45DE0DA9.7000200@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:40793 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbXBVVoB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Feb 2007 16:44:01 -0500
In-Reply-To: <45DE0DA9.7000200@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, Tejun Heo <htejun@gmail.com>, alexisb@us.ibm.com

Darrick J. Wong wrote:
> Per Tejun's request, rename the lldd_task field and add comments about it.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  drivers/scsi/libsas/sas_ata.c |    8 ++++----
>  include/linux/libata.h        |    4 +++-
>  2 files changed, 7 insertions(+), 5 deletions(-)

looks good to me

though please CC linux-ide on all libata patches...

	Jeff



