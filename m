From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/4] scsi: always use format argumets for dev_printk
Date: Sun, 18 Jan 2015 07:22:48 -0800
Message-ID: <1421594568.2080.1.camel@HansenPartnership.com>
References: <1421593891-19984-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47913 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504AbbARPWu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Jan 2015 10:22:50 -0500
In-Reply-To: <1421593891-19984-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On Sun, 2015-01-18 at 16:11 +0100, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks.  Ideally I would have preferred them folded into the logging
series, but if that's not going to be forthcoming, then this works.

For the series:

Reviewed-by: James Bottomley <JBottomley@Parallels.com>

James


