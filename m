From: Yokota Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Subject: Re: [PATCH] update nsp_cs to use scsi_add_host / scsi_remove_host
Date: Thu, 27 Feb 2003 16:14:34 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030227161434O.yokota@netlab.is.tsukuba.ac.jp>
References: <20030226202005.A8461@lst.de>
	<20030226202611.A8526@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030226202611.A8526@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de
Cc: linux-scsi@vger.kernel.org

 Hello, Christoph.

From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] update nsp_cs to use scsi_add_host / scsi_remove_host
Date: Wed, 26 Feb 2003 20:26:11 +0100

> > This patch updates nsp_cs to use scsi_add_host / scsi_remove_host when
> > compiledfor Linux 2.5 which allows to get rid of the scsi host list
> > walks and is a preparation for allowing to support multiple cards of
> > this type.
> Sorry, I sent you the wrong paetch, here's the right one:

 Thanks.
I will apply your patch soon.

---
YOKOTA Hiroshi
E-mail: yokota@netlab.is.tsukuba.ac.jp
WWW:    http://www.netlab.is.tsukuba.ac.jp/~yokota/
