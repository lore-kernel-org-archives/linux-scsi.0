From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] include/scsi/scsi.h replace u8 in 2.5.69
Date: Wed, 14 May 2003 09:02:18 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030514090218.A7371@infradead.org>
References: <3EC1E4AF.6040404@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([195.224.96.167]:57871 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261158AbTENHtc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2003 03:49:32 -0400
Content-Disposition: inline
In-Reply-To: <3EC1E4AF.6040404@torque.net>; from dougg@torque.net on Wed, May 14, 2003 at 04:39:43PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Wed, May 14, 2003 at 04:39:43PM +1000, Douglas Gilbert wrote:
> Here is a simple patch to replace the single occurrence
> of "u8" with "u_char" in include/scsi/scsi.h .

That's wrong.  No userland should include kernwel headers.
(and u_char is a non-standard type, too).

