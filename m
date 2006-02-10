From: Christoph Hellwig <hch@infradead.org>
Subject: Re: cpqfc
Date: Fri, 10 Feb 2006 12:59:11 +0000
Message-ID: <20060210125911.GA29078@infradead.org>
References: <Pine.GSO.4.64.0602061840520.24390@filebunker.xip.at> <200602061923.31944@bilbo.math.uni-mannheim.de> <Pine.GSO.4.64.0602061921160.94@filebunker.xip.at> <200602070855.34920@bilbo.math.uni-mannheim.de> <Pine.GSO.4.64.0602071058530.26505@filebunker.xip.at> <Pine.GSO.4.64.0602101220450.2743@filebunker.xip.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:54999 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751244AbWBJM7M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2006 07:59:12 -0500
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.64.0602101220450.2743@filebunker.xip.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Flaschberger <if@xip.at>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@mkp.net>

On Fri, Feb 10, 2006 at 12:26:27PM +0100, Ingo Flaschberger wrote:
> Hello again,
> 
> I have not received any answer regarding implementation of a new driver 
> for the cpqfc adapter.
> 
> In one week I will start to port the old 2.4 driver to 2.6; with all its 
> "not nice" code, because it works!

The driver was in 2.6.x until a while ago, so that might be an easier
starting point.  Either variant is very broken so we're not going to put
it in again, though.

