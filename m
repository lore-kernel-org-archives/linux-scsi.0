From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: scsi_cmnd accessors issues
Date: Wed, 13 Jun 2007 08:51:18 +0900
Message-ID: <20070613085118P.fujita.tomonori@lab.ntt.co.jp>
References: <466EDFAC.9020104@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:51188 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbXFLXvV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jun 2007 19:51:21 -0400
In-Reply-To: <466EDFAC.9020104@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, ed.lin@promise.com, g.liakhovetski@gmx.de

From: Boaz Harrosh <bharrosh@panasas.com>
Subject: scsi_cmnd accessors issues
Date: Tue, 12 Jun 2007 21:02:20 +0300

> [2]
> if I use __deprecated on request_buffer, request_bufflen, and use_sg with
> scsi_sgtable implementation Than I get below list of files complaining:

(snip)

> and also these files from scsi-ml that need changing when implementation changes:
> drivers/scsi/scsi.c
> drivers/scsi/scsi_error.c
> drivers/scsi/scsi_debug.c
> 
> (see: 0004-Convert-scsi-ml-to-use-of-new-scsi_sgtable.patch at scsi_cmnd.h)
> 
> Which of the files do you have pending patches for? Which do you need that I send
> what I have for them?

I don't think that SCSI-ml bidi will be got into 2.6.23. 2.6.23 will
convert as many LLDs as possible. I don't think that we need such
patches in scsi-misc or scsi-pending now.

We need to agree on what the scsi bidi looks like first. When we add
bidi support to scsi core, we can change scsi core (scsi.c, etc)
together.
