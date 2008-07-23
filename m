From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] 3ware add MSI support
Date: Tue, 22 Jul 2008 19:47:45 -0600
Message-ID: <20080723014745.GH7337@parisc-linux.org>
References: <b1bc6a000807221636s2c5ef1faj6ed0c375a14ee995@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49919 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbYGWBrr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jul 2008 21:47:47 -0400
Content-Disposition: inline
In-Reply-To: <b1bc6a000807221636s2c5ef1faj6ed0c375a14ee995@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Jul 22, 2008 at 04:36:32PM -0700, adam radford wrote:
> This patch for the 3w-9xxx scsi driver applies on top of the
> BKL-pushdown changes in -git9.
> 
> This patch does the following:
> 
> - Increase max AENs drained to 256.
> - Add MSI support and "use_msi" module parameter.
> - Fix bug in twa_get_param() on 4GB+.
> - Use pci_resource_len() for ioremap().

Is there a reason you default use_msi to off?  I would have thought
you'd want to enable it as widely as possible.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
