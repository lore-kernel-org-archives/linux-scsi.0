From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] hpsa: add missing pci_set_master in kdump path
Date: Thu, 25 Sep 2014 19:01:32 +0200
Message-ID: <20140925170132.GA17892@infradead.org>
References: <5412EA9F.4060703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48776 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaIYQ7K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Sep 2014 12:59:10 -0400
Content-Disposition: inline
In-Reply-To: <5412EA9F.4060703@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, elliott@hp.com, steve.cameron@hp.com, Christoph Hellwig <hch@infradead.org>, "Handzik, Joe" <joseph.t.handzik@hp.com>

Thanks, applied to drivers-for-3.18.
