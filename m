From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] ipr: Properly enable/disable TCQ
Date: Sat, 28 Aug 2004 17:05:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4130F37E.2020104@pobox.com>
References: <200408282014.i7SKEl2S006092@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:25493 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267889AbUH1VFR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Aug 2004 17:05:17 -0400
In-Reply-To: <200408282014.i7SKEl2S006092@hera.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: brking@us.ibm.com

Linux Kernel Mailing List wrote:
> ChangeSet 1.1803.41.23, 2004/08/14 18:08:08-04:00, brking@us.ibm.com
> 
> 	[PATCH] ipr: Properly enable/disable TCQ
> 	
> 	This patch correctly enables tagged command queuing for the ipr driver.
> 	I had misinterpreted scsi_mid_low_api.txt. The following patch has the
> 	appropriate scsi_activate_tcq/scsi_deactivate_tcq calls.
> 	
> 	Signed-off-by: Brian King <brking@us.ibm.com>
> 	Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>


I don't think you misinterpreted scsi_mid_low_api.txt -- it only 
mentions scsi_adjust_queue_depth(), and does not mention 
scsi_[de]activate_tcq() at all.

Seems like a doc bug to me...

	Jeff, who was about to add scsi_adjust_queue_depth() to libata


