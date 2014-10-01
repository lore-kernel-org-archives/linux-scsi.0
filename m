From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 6/8] scsi: move more requeue handling into scsi_requeue_command
Date: Wed, 01 Oct 2014 14:33:48 +0200
Message-ID: <542BF4AC.1070008@acm.org>
References: <1410107469-896-1-git-send-email-hch@lst.de> <1410107469-896-7-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baptiste.telenet-ops.be ([195.130.132.51]:39938 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaJAMdu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2014 08:33:50 -0400
In-Reply-To: <1410107469-896-7-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 09/07/14 18:31, Christoph Hellwig wrote:
> Move a bit code out of scsi_io_completion and into scsi_requeue_command
> in preparation for further refactoring.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

