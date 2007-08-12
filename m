From: "Harrosh, Boaz" <bharrosh@panasas.com>
Subject: RE: [PATCH] microtek: convert to use the data buffer accessors
Date: Sun, 12 Aug 2007 11:01:20 -0400
Message-ID: <E472128B1EB43941B4E7FB268020C89B0250BA18@riverside.int.panasas.com>
References: <20070811072657A.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:2357 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936006AbXHLPGf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Aug 2007 11:06:35 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>, linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, greg@kroah.com, fujita.tomonori@lab.ntt.co.jp

FUJITA Tomonori wrote ...
> Subject: [PATCH] microtek: convert to use the data buffer accessors
>
> - remove the unnecessary map_single path.
> 
> - convert to use the new accessors for the sg lists and the
> parameters.
> 
> TODO: sg chaining support
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Is this not the same as the patch I sent at 2007-07-12
http://marc.info/?l=linux-scsi&m=118424592500438&w=4

And was ACKed by one of the maintainers:
http://marc.info/?l=linux-scsi&m=118426360825803&w=4

Boaz
