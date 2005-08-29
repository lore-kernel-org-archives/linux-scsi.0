From: Christoph Hellwig <hch@infradead.org>
Subject: Re: fibre channel/multipath questions
Date: Mon, 29 Aug 2005 18:23:16 +0100
Message-ID: <20050829172316.GC7875@infradead.org>
References: <200508261812.23328.Rik.Bobbaers@cc.kuleuven.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:28322 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751137AbVH2RXS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 13:23:18 -0400
Content-Disposition: inline
In-Reply-To: <200508261812.23328.Rik.Bobbaers@cc.kuleuven.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rik Bobbaers <Rik.Bobbaers@cc.kuleuven.be>
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com

I think you can setup dm-multipath based on WWNs, so the device
numbers don't matter.  Cc'ed the dm-devel list to verify my assumption.

