From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] qla2xyz: fix section mismatch
Date: Thu, 10 Jan 2008 14:41:25 -0800
Message-ID: <20080110224125.GG23535@plap3.qlogic.org>
References: <20080110143309.4eb516b0.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:3052 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbYAJWle (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2008 17:41:34 -0500
Content-Disposition: inline
In-Reply-To: <20080110143309.4eb516b0.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: scsi <linux-scsi@vger.kernel.org>, linux-driver@qlogic.com, akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>

On Thu, 10 Jan 2008, Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix section mismatch:  qla2x00_remove_one() should not be __devexit.
> 
> WARNING: vmlinux.o(.text+0xb014f5): Section mismatch: reference to .exit.text: (between 'qla2xxx_pci_error_detected' and 'qla2xxx_pci_mmio_enabled')
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Adriann B. posted this fix already:

	http://article.gmane.org/gmane.linux.scsi/36387

I was expecting it to be carried in the -mm tree since it was acked:

	http://article.gmane.org/gmane.linux.scsi/36516

I can add it to the patch queue if necessary.
