From: Andrew Morton <akpm@osdl.org>
Subject: Re: Fw: [Bugme-new] [Bug 4880] New: dpt_i2o.c does not register
 itself with sysfs
Date: Wed, 13 Jul 2005 15:56:17 -0700
Message-ID: <20050713155617.6443309f.akpm@osdl.org>
References: <20050713123250.5d3e3298.akpm@osdl.org>
	<20050713224233.GA2919@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:35978 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S262279AbVGMWz2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jul 2005 18:55:28 -0400
In-Reply-To: <20050713224233.GA2919@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, ngroot@imsa.edu

Christoph Hellwig <hch@infradead.org> wrote:
>
> Use the i2o_block and i2o_scsi drivers instead of dpt_i2o, they support
> the hardware and are written to proper APIs.

(Added originator to cc)
