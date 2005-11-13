From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] scsi: remove usage of proc_name from scsi_host_alloc
Date: Sun, 13 Nov 2005 17:07:12 +0000
Message-ID: <20051113170712.GA9740@infradead.org>
References: <200511131619.jADGJFwQ032002@einhorn.in-berlin.de> <20051113164222.GA9308@infradead.org> <43776EA3.3010607@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40655 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964942AbVKMRHN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Nov 2005 12:07:13 -0500
Content-Disposition: inline
In-Reply-To: <43776EA3.3010607@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org

On Sun, Nov 13, 2005 at 05:49:39PM +0100, Stefan Richter wrote:
> >->name is not mandatory.  You may just implement ->info
> 
> No, ->info is optional according to a current comment, and according to 
> the implementation as far as I have seen.
> 
> Also, ->name is used in a number of places if some other host template 
> members are not provided, i.e. it is practically mandatory.

Well, the original plan was that a host implements either ->name or
->info.  The first in case the information is static and the latter in
case it's dynamic.  I think it's a bit complex and would prefer to have
just one of them long term or rather just a routine that prints a trivial
name, similar to the current ->proc_info.
