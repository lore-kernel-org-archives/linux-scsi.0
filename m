From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 2/3] target: Split
 transport_send_check_condition_and_sense()
Date: Mon, 6 Jul 2015 02:05:55 -0700
Message-ID: <20150706090555.GB15996@infradead.org>
References: <1436169747-28834-1-git-send-email-sagig@mellanox.com>
 <1436169747-28834-3-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46448 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbbGFJF4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2015 05:05:56 -0400
Content-Disposition: inline
In-Reply-To: <1436169747-28834-3-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

> +static void translate_sense_reason(struct se_cmd *cmd, int r)
> +{

Can you please pass the sense_reason_t argument to this function
and do all the __force int casting inside this function?

