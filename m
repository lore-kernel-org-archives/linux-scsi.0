From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 1/4] scsi: remove ->change_queue_type method
Date: Fri, 28 Nov 2014 10:59:39 +0100
Message-ID: <5478478B.2000108@acm.org>
References: <1416839781-26988-1-git-send-email-hch@lst.de> <1416839781-26988-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sf2.bxl.stone.is ([5.134.1.239]:45208 "EHLO sf2.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbaK1L3f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Nov 2014 06:29:35 -0500
In-Reply-To: <1416839781-26988-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>

On 11/24/14 15:36, Christoph Hellwig wrote:
> Since we got rid of ordered tag support in 2010 the prime use case of
> switching on and off ordered tags has been obsolete.  The other function
> of enabling/dsiabling tagging entirely has only been correctly implemented
> by the 53c700 driver and isn't generally useful.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

