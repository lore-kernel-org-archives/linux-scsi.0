From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 0/2] some block and scsi layer additions for ULD
	scatterlist code
Date: Mon, 05 Dec 2005 02:37:05 -0600
Message-ID: <1133771825.23619.16.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:2001 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751354AbVLEIhR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2005 03:37:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de, Linux SCSI list <linux-scsi@vger.kernel.org>

These two patches are some of the core or bugfix code for the SCSI ULD
scatterlist code. The first patch exports the block layer functions
needed to be able to do async REQ_BLOCK_PC commands and hook into the
request end_io callout and it adds the max_hw_sectors code. And the
second patch fixes a bug in st where it allows SCSI-ml to retry commands
and reverts SCSI-ml back to its previous behavior where it does not
allow scsi_io_completion to retry REQ_BLOCK_PC (previously special
requests) commands.

These patches were made against linux-2.6-block, but apply with some
offset to scsi-misc.

