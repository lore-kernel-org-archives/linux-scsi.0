From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 3/4] scsi: remove scsi_get_tag_type
Date: Fri, 28 Nov 2014 11:00:05 +0100
Message-ID: <547847A5.2060705@acm.org>
References: <1416839781-26988-1-git-send-email-hch@lst.de> <1416839781-26988-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sf2.bxl.stone.is ([5.134.1.239]:54005 "EHLO sf2.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbaK1KRS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Nov 2014 05:17:18 -0500
In-Reply-To: <1416839781-26988-4-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>

On 11/24/14 15:36, Christoph Hellwig wrote:
> Both remaining users are better of just checking sdev->simple_tags
> directly.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

