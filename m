From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 29/30] PCI Error Recovery: Symbios SCSI base support
Date: Mon, 07 May 2007 14:48:47 -0500
Message-ID: <1178567327.3729.40.camel@mulgrave.il.steeleye.com>
References: <200704260735.l3Q7ZV7e024298@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:43271 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754728AbXEGTtU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2007 15:49:20 -0400
In-Reply-To: <200704260735.l3Q7ZV7e024298@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, linas@austin.ibm.com, willy@debian.org

On Thu, 2007-04-26 at 00:35 -0700, akpm@linux-foundation.org wrote:
> From: Linas Vepstas <linas@austin.ibm.com>
> 
> Various PCI bus errors can be signaled by newer PCI controllers.  This
> patch adds the PCI error recovery callbacks to the Symbios SCSI device
> driver.  The patch has been tested, and appears to work well.

awaiting maintainer ACK.

James


