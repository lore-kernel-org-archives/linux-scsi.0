From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] IB/srp: Fix SCSI scanning
Date: Mon, 20 Jun 2011 07:37:36 -0400
Message-ID: <20110620113736.GA406@infradead.org>
References: <201106191348.24122.bvanassche@acm.org>
 <1308504469.14467.5.camel@obelisk.thedillows.org>
 <BANLkTi=5nBDB-SGd0U0UZDgR4gKBDqaj0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46898
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751669Ab1FTLhq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2011 07:37:46 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTi=5nBDB-SGd0U0UZDgR4gKBDqaj0w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: David Dillow <dillowda@ornl.gov>, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, Roland Dreier <roland@purestorage.com>, Brian King <brking@linux.vnet.ibm.com>

We really shouldn't require workaround for this in every SCSI driver.

scsi_scan_host_selected already makes sure never to scan above
shost->max_channel.  Could it be that you don't have that one set
properly in the srp driver?  It not we'll need to debug why it happens
instead of adding hacks like this.

