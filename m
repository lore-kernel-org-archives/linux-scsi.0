From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/10][RFC] linux-iscsi driver
Date: Mon, 10 Jan 2005 23:24:42 +0000
Message-ID: <20050110232442.GB10138@infradead.org>
References: <41E30855.9050203@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:22664 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262606AbVAJXYm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2005 18:24:42 -0500
Content-Disposition: inline
In-Reply-To: <41E30855.9050203@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

On Mon, Jan 10, 2005 at 02:57:25PM -0800, Mike Christie wrote:
> Core iSCSI session code.

Can you kill the ugly iscsi-sfnet name?  We also don't call out networking
code ipv4-swansea ;-)  Simple iscsi should be enough, or if you think that's
confusing vs driver for hardware offload cards maybe sw-iscsi.

