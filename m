From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Fw: [Bugme-new] [Bug 4880] New: dpt_i2o.c does not register itself with sysfs
Date: Wed, 13 Jul 2005 23:42:33 +0100
Message-ID: <20050713224233.GA2919@infradead.org>
References: <20050713123250.5d3e3298.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:13499 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262652AbVGMWmh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jul 2005 18:42:37 -0400
Content-Disposition: inline
In-Reply-To: <20050713123250.5d3e3298.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org

Use the i2o_block and i2o_scsi drivers instead of dpt_i2o, they support
the hardware and are written to proper APIs.

