From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/10] ipr: Disk remove path cleanup
Date: Wed, 29 Mar 2006 16:10:00 +0100
Message-ID: <20060329151000.GB14690@infradead.org>
References: <200603291438.k2TEcJj0006799@d01av02.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:7833 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750791AbWC2PKE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 10:10:04 -0500
Content-Disposition: inline
In-Reply-To: <200603291438.k2TEcJj0006799@d01av02.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

On Wed, Mar 29, 2006 at 08:38:18AM -0600, Brian King wrote:
> 
> Instead of NULLing the resource entry pointer when a disk
> goes away to prevent any new commands being sent to it,
> set the adapter resource handle to an invalid value so
> new ops getting sent to it will fail with a selection timeout
> response. This patch is needed for future SATA patches.

It would help greatly if you could split out the patches that don't
require libata changes so they could go into scsi-misc already.

