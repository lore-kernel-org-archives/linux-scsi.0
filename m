From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] qla2xyz: fix section mismatch
Date: Fri, 11 Jan 2008 18:56:42 +0100
Message-ID: <20080111175642.GF28624@uranus.ravnborg.org>
References: <20080110143309.4eb516b0.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:51568 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760434AbYAKR4h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jan 2008 12:56:37 -0500
Content-Disposition: inline
In-Reply-To: <20080110143309.4eb516b0.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: scsi <linux-scsi@vger.kernel.org>, linux-driver@qlogic.com, akpm <akpm@linux-foundation.org>

On Thu, Jan 10, 2008 at 02:33:09PM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix section mismatch:  qla2x00_remove_one() should not be __devexit.
> 
> WARNING: vmlinux.o(.text+0xb014f5): Section mismatch: reference to .exit.text: (between 'qla2xxx_pci_error_detected' and 'qla2xxx_pci_mmio_enabled')
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>

This could oops under the wrong conditions.

	Sam
