From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 4/4] scsi: remove scsi_set_tag_type
Date: Fri, 28 Nov 2014 11:00:17 +0100
Message-ID: <547847B1.2070507@acm.org>
References: <1416839781-26988-1-git-send-email-hch@lst.de> <1416839781-26988-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sf1.bxl.stone.is ([87.238.167.36]:36256 "EHLO sf1.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbaK1KQE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Nov 2014 05:16:04 -0500
In-Reply-To: <1416839781-26988-5-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>

On 11/24/14 15:36, Christoph Hellwig wrote:
> There is no benefit over just setting sdev->simple_tags directly.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

