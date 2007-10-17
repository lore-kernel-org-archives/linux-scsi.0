From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [patch 3/7] qla2xxx printk fixes
Date: Wed, 17 Oct 2007 09:33:03 -0700
Message-ID: <20071017163303.GE15441@plap3.qlogic.org>
References: <200710162128.l9GLSLBv018170@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:32303 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763848AbXJQQdN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 12:33:13 -0400
Content-Disposition: inline
In-Reply-To: <200710162128.l9GLSLBv018170@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Tue, 16 Oct 2007, akpm@linux-foundation.org wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> 
> drivers/scsi/qla2xxx/qla_sup.c: In function 'qla24xx_write_flash_data':
> drivers/scsi/qla2xxx/qla_sup.c:655: warning: format '%llx' expects type 'long long unsigned int', but argument 6 has type 'dma_addr_t'
> drivers/scsi/qla2xxx/qla_sup.c: In function 'qla25xx_read_optrom_data':
> drivers/scsi/qla2xxx/qla_sup.c:1853: warning: format '%llx' expects type 'long long unsigned int', but argument 6 has type 'dma_addr_t'
> 
> Cc: James Bottomley <James.Bottomley@steeleye.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
