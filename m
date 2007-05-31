From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Patch added to scsi-pending-2.6:   [SCSI] qla2xxx: convert to use the data buffer accessors
Date: Thu, 31 May 2007 06:29:46 -0700
Message-ID: <20070531132946.GB24289@plap.qlogic.org>
References: <200705310515.l4V5FOBn009160@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:21211 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbXEaN3u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 May 2007 09:29:50 -0400
Content-Disposition: inline
In-Reply-To: <200705310515.l4V5FOBn009160@hera.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@SteelEye.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 31 May 2007, James Bottomley wrote:

> Your commit:
> 
>     [SCSI] qla2xxx: convert to use the data buffer accessors
>     
>     - remove the unnecessary map_single path.
>     
>     - convert to use the new accessors for the sg lists and the
>     parameters.
>     
>     Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>     Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
>     Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
> 
> has been added to the pending SCSI tree

Acked-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
