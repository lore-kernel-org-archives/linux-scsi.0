From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: PATCH [0/3]   qla2xxx: new experimental changes...
Date: Fri, 04 Feb 2005 13:09:02 -0800
Message-ID: <1107551342.14183.41.camel@plap.san.rr.com>
References: <1107544908.14183.11.camel@plap.san.rr.com>
	 <20050204203501.GA25239@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from avexch01.qlogic.com ([198.70.193.200]:16956 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S266254AbVBDVIm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Feb 2005 16:08:42 -0500
In-Reply-To: <20050204203501.GA25239@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-02-04 at 20:35 +0000, Christoph Hellwig wrote:
> patch3 seems to not have made it to the list.

I'll resend...

>   From a quick view
> the first three patches look fine, except for backing out one msleep
> conversion and the superflous return at the end of qla2xxx_slave_destroy
> 

I'll send an incremental patch which fixes this.

--
AV
