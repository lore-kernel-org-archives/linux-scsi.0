From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 2/5] target: Split
 transport_send_check_condition_and_sense()
Date: Wed, 8 Jul 2015 03:15:51 -0700
Message-ID: <20150708101551.GA14466@infradead.org>
References: <1436188508-1539-1-git-send-email-sagig@mellanox.com>
 <1436188508-1539-3-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38228 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932710AbbGHKPw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2015 06:15:52 -0400
Content-Disposition: inline
In-Reply-To: <1436188508-1539-3-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

> +	if (r == (__force int)TCM_CHECK_CONDITION_UNIT_ATTENTION) {

You probably want to compare reason here to avoid the cast.

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
