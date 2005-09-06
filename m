From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dpt_i2o pci_driver model
Date: Tue, 6 Sep 2005 12:45:59 +0100
Message-ID: <20050906114559.GG5309@infradead.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F0177C1BF@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:25043 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964820AbVIFLqA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Sep 2005 07:46:00 -0400
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F0177C1BF@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Aug 19, 2005 at 11:05:41AM -0400, Salyzyn, Mark wrote:
> The sysinit structure is supposed to be a complete list of all peered
> i2o adapters. The current driver structure issued the sysinit command
> after all adapters were discovered rather than re-issuing as each was
> added.

Yeah, I noticed that, but the question is why that's nessecary, after
all the i2o layer drivers don't need that either.

