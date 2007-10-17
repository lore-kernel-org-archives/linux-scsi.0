From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 22/32] qla1280: Indentation fix
Date: Wed, 17 Oct 2007 16:15:56 -0600
Message-ID: <20071017221556.GE10980@parisc-linux.org>
References: <47164306.6090702@panasas.com> <47165001.2090204@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:53682 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758405AbXJQWP7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 18:15:59 -0400
Content-Disposition: inline
In-Reply-To: <47165001.2090204@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, Alan Stern <stern@rowland.harvard.edu>, "David S. Miller" <davem@davemloft.net>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Benny Halevy <bhalevy@panasas.com>, Pete Wyckoff <pw@osc.edu>

On Wed, Oct 17, 2007 at 08:10:09PM +0200, Boaz Harrosh wrote:
> 
>   - Indentation fix of last patch. Don't be fooled by diff,
>     all I did was back-indent from open-bracket to close-bracket,
>     and remove the brackets.

Applying 'qla1280: Indentation fix'

Adds trailing whitespace.
.dotest/patch:90: sn_pci_set_vchan(ha->pdev, 
warning: 1 line adds trailing whitespaces.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
