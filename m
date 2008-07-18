From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [patch 9/9] drivers/scsi/qla2xxx/qla_os.c: suppress
	uninitialized-var warning
Date: Thu, 17 Jul 2008 17:02:35 -0700
Message-ID: <20080718000235.GC1763@n8027av35btxc1.qlogic.org>
References: <200806092336.m59NaP8R014837@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:53620 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760253AbYGRACg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jul 2008 20:02:36 -0400
Content-Disposition: inline
In-Reply-To: <200806092336.m59NaP8R014837@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Mon, 09 Jun 2008, akpm@linux-foundation.org wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> 
> drivers/scsi/qla2xxx/qla_os.c: In function 'qla2x00_post_work':
> drivers/scsi/qla2xxx/qla_os.c:2158: warning: 'flags' may be used uninitialized in this function
> 
> Acked-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

I'll carry this one in my patch-tree as well.

Thanks, av
