From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH 2.6] cciss typo fix
Date: Mon, 10 Jan 2005 09:50:38 -0600
Message-ID: <1105372238.4477.5.camel@mulgrave>
References: <D4CFB69C345C394284E4B78B876C1CF107DC0188@cceexc23.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:2001 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262304AbVAJPvY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2005 10:51:24 -0500
In-Reply-To: <D4CFB69C345C394284E4B78B876C1CF107DC0188@cceexc23.americas.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Miller, Mike (OS Dev)" <mike.miller@hp.com>
Cc: Jens Axboe <axboe@suse.de>, Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-01-10 at 09:45 -0600, Miller, Mike (OS Dev) wrote:
> Even if it were added to the compat header; is using __be32 correct in this context?

They should be.  The __be annotations track unconverted big endian
numbers.  be32_to_cpu checks that it's only taking __be annotated
variables (at least when sparse tracks it), so the cast is correct and
prevents sparse from warning.

James


