From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PATCH [0/3]   qla2xxx: new experimental changes...
Date: Fri, 4 Feb 2005 20:35:01 +0000
Message-ID: <20050204203501.GA25239@infradead.org>
References: <1107544908.14183.11.camel@plap.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from pentafluge.infradead.org ([213.146.154.40]:28818 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S263950AbVBDUfJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Feb 2005 15:35:09 -0500
Content-Disposition: inline
In-Reply-To: <1107544908.14183.11.camel@plap.san.rr.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

patch3 seems to not have made it to the list.  From a quick view
the first three patches look fine, except for backing out one msleep
conversion and the superflous return at the end of qla2xxx_slave_destroy

