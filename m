From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 5/7] gdth: kill virt_ctr option
Date: Sat, 21 Jul 2007 16:18:14 -0400
Message-ID: <46A26A06.8090001@garzik.org>
References: <20070721170203.GF4150@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:34037 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759528AbXGUUSQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jul 2007 16:18:16 -0400
In-Reply-To: <20070721170203.GF4150@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: leubner@adaptec.com, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> The virt_ctr option allows to register a new scsi_host for each bus
> on the raid controller.  This non-default option makes no sense with
> the current scsi code and prevents cleaning up the host registration,
> so remove it.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I agree the virt_ctr stuff is annoying, but this change has the clear 
potential to cause breakage.

I disagree that it prevents cleaning up host registration, since I have 
done so even with virt_ctr :)

