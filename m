From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] tcm: Convert backstore ->set_configfs_dev_params() to
 use parser.h
Date: Tue, 9 Nov 2010 05:03:59 -0500
Message-ID: <20101109100359.GA26324@infradead.org>
References: <1289296122-13152-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49441 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab0KIKEA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2010 05:04:00 -0500
Content-Disposition: inline
In-Reply-To: <1289296122-13152-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

> +	opts = kstrdup(page, GFP_KERNEL);

What do you need the this copy for?

Otherwise looks good.

