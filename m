From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 4/6] scsi: use 64-bit LUNs
Date: Mon, 02 Jun 2014 18:13:07 +0200
Message-ID: <538CA293.3020700@acm.org>
References: <1401526878-119472-1-git-send-email-hare@suse.de> <1401526878-119472-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:32963 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbaFBQNN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 12:13:13 -0400
In-Reply-To: <1401526878-119472-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

On 05/31/14 11:01, Hannes Reinecke wrote:
> -void int_to_scsilun(unsigned int lun, struct scsi_lun *scsilun)
> +void int_to_scsilun(u64 lun, struct scsi_lun *scsilun)

Nothing important, but there is a memset() at the start of
int_to_scsilun(). I think this change makes that memset() superfluous.

Bart.

