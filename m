From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Warning: about not setting max_sectors
Date: Wed, 11 Dec 2002 08:37:53 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200212111437.gBBEbri01981@localhost.localdomain>
References: <hch@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id GAA27461
	for <linux-scsi@vger.kernel.org>; Wed, 11 Dec 2002 06:38:01 -0800
In-Reply-To: Message from Christoph Hellwig <hch@infradead.org>
   of "Wed, 11 Dec 2002 10:57:47 GMT." <20021211105747.A32363@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

hch@infradead.org said:
> Yepp.  Will you fix it or should I send a patch?

I'll do it (I may even look at adjusting the maximum based on the device).

James


