From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] 2.6: modular scsi/mca_53c9x doesn't work (fwd)
Date: Mon, 14 Jun 2004 20:22:15 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040614192215.GA5360@infradead.org>
References: <20040614185256.GJ13951@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:9438 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S263802AbUFNTWR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jun 2004 15:22:17 -0400
Content-Disposition: inline
In-Reply-To: <20040614185256.GJ13951@fs.tum.de>
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@fs.tum.de>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Jun 14, 2004 at 08:52:56PM +0200, Adrian Bunk wrote:
> The issue described in the mail forwarded below is still present in 
> 2.6.7-rc3-mm2 (but not specific to -mm).
> 
> I'd suggest the following workaround:

Please add the exports instead.  It'll affect all the other 53C9X-based
drivers aswell.
