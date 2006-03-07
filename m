From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: osst changes required to move forward to block request
Date: Tue, 07 Mar 2006 15:53:37 -0600
Message-ID: <1141768417.3239.52.camel@mulgrave.il.steeleye.com>
References: <20060206131944.GA1769@lst.de>
	 <1139274141l.7464l.1l@athena.riede.org>
	 <20060207091254.GA11691@infradead.org>
	 <1139687216l.24984l.0l@athena.riede.org>
	 <20060307115913.GA30421@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:21123 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964784AbWCGVx5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Mar 2006 16:53:57 -0500
In-Reply-To: <20060307115913.GA30421@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Willem Riede <osst@riede.org>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Tue, 2006-03-07 at 11:59 +0000, Christoph Hellwig wrote:
> James, could you put this into the scsi-misc tree so we don't have any ULD
> using the scsi_request APIs anymore?

OK, done ... now could someone actually test it?

James


