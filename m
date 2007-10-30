From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: iterate over devices individually for /proc/scsi/scsi
Date: Tue, 30 Oct 2007 10:17:11 +0000
Message-ID: <20071030101711.GA23907@infradead.org>
References: <461E89C8.7040507@suse.com> <20070413072506.GA20326@infradead.org> <472655A8.1090700@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:52801 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbXJ3KRM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Oct 2007 06:17:12 -0400
Content-Disposition: inline
In-Reply-To: <472655A8.1090700@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Mahoney <jeffm@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

This patch looks a lot better and is how seq_file should be used.  I'm still
not entirely happy about adding more features to this long-deprecated interface,
but if others agree with this patch you'll get my ACK aswell.

