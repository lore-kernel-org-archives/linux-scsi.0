From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 08/17] Fix a potential NULL pointer deref in the
	aic7xxx, ahc_print_register() function
Date: Tue, 02 Oct 2007 17:07:00 -0500
Message-ID: <1191362820.3530.144.camel@localhost.localdomain>
References: <200710022138.l92Lc4iM023579@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:39431 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753116AbXJBWHC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 18:07:02 -0400
In-Reply-To: <200710022138.l92Lc4iM023579@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, jesper.juhl@gmail.com

On Tue, 2007-10-02 at 14:38 -0700, akpm@linux-foundation.org wrote:
> From: Jesper Juhl <jesper.juhl@gmail.com>
> 
> The Coverity checker noticed that we have a potential NULL pointer
> deref in drivers/scsi/aic7xxx/aic7xxx_core.c::ahc_print_register().
> This patch handles it by adding the same test against NULL that is
> used elsewhere in the same function.
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

No.  Reasons formerly given here:

http://marc.info/?l=linux-scsi&m=118632919511846&w=2

James


