From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 5/8] scsi: move scsi_dispatch_cmd to scsi_lib.c
Date: Wed, 01 Oct 2014 14:30:20 +0200
Message-ID: <542BF3DC.9070609@acm.org>
References: <1410107469-896-1-git-send-email-hch@lst.de> <1410107469-896-6-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:43804 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaJAMaV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2014 08:30:21 -0400
In-Reply-To: <1410107469-896-6-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 09/07/14 18:31, Christoph Hellwig wrote:
> scsi_lib.c is where the rest of the I/O submission path lives, so move
> scsi_dispatch_cmd there and mark it static.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

