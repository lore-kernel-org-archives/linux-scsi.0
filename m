From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] scsi: scsi inquiry timeout config option
Date: Tue, 4 Oct 2005 19:46:01 +0100
Message-ID: <20051004184601.GA30667@infradead.org>
References: <200510032026.j93KQViR015934@d01av04.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55237 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964913AbVJDSqE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Oct 2005 14:46:04 -0400
Content-Disposition: inline
In-Reply-To: <200510032026.j93KQViR015934@d01av04.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, linuxppc64-dev@ozlabs.org

On Mon, Oct 03, 2005 at 03:26:30PM -0500, brking@us.ibm.com wrote:
> 
> Add a .config option to default the scsi scan inquiry timeout.
> Due to a broken device (SCSI/ATA converter card) that is very
> common on IBM iSeries/pSeries machines, these architectures
> need a longer default inquiry timeout.

This is really not something that should be a CONFIG_ symbol.
We have a perfectly fine working module option for it.

