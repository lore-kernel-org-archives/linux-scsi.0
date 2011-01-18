From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] target: Fix tcm_mod_builder.py default EXTRA_CFLAGS
Date: Tue, 18 Jan 2011 22:36:04 +0100
Message-ID: <20110118213604.GA13063@lst.de>
References: <1295386222-12869-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:48552 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947Ab1ARVgI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2011 16:36:08 -0500
Content-Disposition: inline
In-Reply-To: <1295386222-12869-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On Tue, Jan 18, 2011 at 01:30:22PM -0800, Nicholas A. Bellinger wrote:
> +	buf = "EXTRA_CFLAGS += -I$(srctree)/include/ -I$(srctree)/drivers/target/" + fabric_mod_name + "\n\n"

-I$(srctree)/include/ is never needed, that's added automatically.
Similarly adding the directory of the driver itself (assuming that's
what the second one is supposed to be) is not needed either.

