From: James.Smart@Emulex.Com
Subject: RE: [PATCH 9/11]  lpfc 8.1.1 : Add polled-mode support
Date: Mon, 28 Nov 2005 16:10:37 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C5F@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:21410 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932098AbVK1VKt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 16:10:49 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: linux-scsi@vger.kernel.org


> This needs some documentation for where it is useful.  Do you 
> want this
> to avoid interrupts under high loads or for something else? 

Yes - we've been asked to support this mode so that a heavily loaded
system can claim back some cpu cycles spent on interrupt processing.
(SPC benchmarks being a prime example)

We'll recut this patch with some additional text and to address the
comments.

-- james

