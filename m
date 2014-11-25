From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 0/5] scsi_debug: switch to table based parser
Date: Tue, 25 Nov 2014 06:45:05 -0800
Message-ID: <20141125144505.GA24120@infradead.org>
References: <5473FFB9.8070206@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36731 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaKYOpG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Nov 2014 09:45:06 -0500
Content-Disposition: inline
In-Reply-To: <5473FFB9.8070206@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@ORACLE.COM>

Thanks, applied the whole series to drivers-for-3.19.  I also switched
it to use the symbolic constant as pointed out by Hannes.

