From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] clean up drivers/scsi/scsi.h
Date: Mon, 14 Feb 2005 11:09:58 +0000
Message-ID: <20050214110958.GB2367@infradead.org>
References: <200502141157.30447@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from pentafluge.infradead.org ([213.146.154.40]:60358 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261415AbVBNLJ7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Feb 2005 06:09:59 -0500
Content-Disposition: inline
In-Reply-To: <200502141157.30447@bilbo.math.uni-mannheim.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Feb 14, 2005 at 11:57:29AM +0100, Rolf Eike Beer wrote:
> Hi,
> 
> this patch removes some useless struct declarations from drivers/scsi/scsi.h.
> All this structs are already defined in the header files included above
> except Scsi_Host, for which we now directly include <scsi/scsi_host.h>

No, this is totally wrong.  If you only use pointers to structs always
use forward declarations instead of pulling in a full header.

