From: Christoph Hellwig <hch@lst.de>
Subject: Re: block: remove artifical max_hw_sectors cap
Date: Mon, 5 Jan 2015 18:17:34 +0100
Message-ID: <20150105171734.GA30028@lst.de>
References: <5497F319.20802@profihost.ag> <20141223082805.GA2303@lst.de> <549FF2DB.4000506@profihost.ag> <20141230113206.GA1461@lst.de> <54A2B37E.2090104@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55156 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340AbbAERRi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jan 2015 12:17:38 -0500
Content-Disposition: inline
In-Reply-To: <54A2B37E.2090104@profihost.ag>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Tue, Dec 30, 2014 at 03:15:26PM +0100, Stefan Priebe - Profihost AG wrote:
> > What is the max_sectors_kb value for them?
> > 
> # cat /sys/block/sdi/queue/max_sectors_kb
> 16383

That's odd, it's half of what ATA disks should support.  Is this
device attached to the HBA or an expander?

