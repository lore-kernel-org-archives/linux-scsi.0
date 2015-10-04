From: Christoph Hellwig <hch@lst.de>
Subject: Re: [REGRESSION v4.3] scsi_dh: use-after-free when removing scsi
	device
Date: Sun, 4 Oct 2015 09:43:34 +0200
Message-ID: <20151004074334.GB13912@lst.de>
References: <20150930003549.GA4857@xzibit.linux.bs1.fc.nec.co.jp> <20150930151857.GA26594@lst.de> <20151001005640.GA4821@xzibit.linux.bs1.fc.nec.co.jp> <20151001043844.GA8397@xzibit.linux.bs1.fc.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49799 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbbJDHng (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Oct 2015 03:43:36 -0400
Content-Disposition: inline
In-Reply-To: <20151001043844.GA8397@xzibit.linux.bs1.fc.nec.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

This patch looks fine to me:

Acked-by: Christoph Hellwig <hch@lst.de>
