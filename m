From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] kill tmscsim ->proc_info
Date: Tue, 24 Aug 2004 13:31:11 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040824113111.GA16477@lst.de>
References: <20040817161858.GA16589@lst.de> <4122366E.1040204@yk.rim.or.jp> <20040817164824.GA17074@lst.de> <41223A5A.8090409@yk.rim.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:20891 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S267486AbUHXLbO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Aug 2004 07:31:14 -0400
Content-Disposition: inline
In-Reply-To: <41223A5A.8090409@yk.rim.or.jp>
List-Id: linux-scsi@vger.kernel.org
To: Chiaki <ishikawa@yk.rim.or.jp>
Cc: Christoph Hellwig <hch@lst.de>, g.liakhovetski@gmx.de, linux-scsi@vger.kernel.org

On Wed, Aug 18, 2004 at 02:03:22AM +0900, Chiaki wrote:
> In the removed code section, there is a loop
> that begins with
> "for (dev = 0; dev < pACB->DCBCnt; dev++)".

We should get all the information back in sysfs once the driver is
changed to use the SPI transport class.

