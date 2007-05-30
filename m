From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch 6/7] ps3: ROM Storage Driver
Date: Wed, 30 May 2007 21:45:55 +1000
Message-ID: <1180525555.19517.268.camel@localhost.localdomain>
References: <20070525083607.784351000@sonycom.com>
	 <20070525083632.677742000@sonycom.com> <20070529104948.GC29351@lst.de>
	 <Pine.LNX.4.62.0705291308280.7698@pademelon.sonytel.be>
	 <20070530101348.GD24586@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:56072 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbXE3Lq3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2007 07:46:29 -0400
In-Reply-To: <20070530101348.GD24586@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, linuxppc-dev@ozlabs.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 2007-05-30 at 12:13 +0200, Christoph Hellwig wrote:
> 
> For any sane hypervisor or hardware the copy should be worth
> than that.  Then again a sane hardware or hypervisor would support
> SG requests..

Agreed... Sony should fix that, it's a bit ridiculous.

Ben.


