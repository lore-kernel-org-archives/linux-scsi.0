From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH: Further aacraid work
Date: 17 Jun 2004 15:56:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087505777.2210.82.camel@mulgrave>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189FD2407B@otce2k03.adaptec.com>
	<20040617203842.GC8705@devserv.devel.redhat.com>
	<20040617204828.GC1495@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:14804 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263166AbUFQU6I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2004 16:58:08 -0400
In-Reply-To: <20040617204828.GC1495@holomorphy.com>
List-Id: linux-scsi@vger.kernel.org
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Alan Cox <alan@redhat.com>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, y@redhat.com, Clay Haapala <chaapala@cisco.com>, Christoph Hellwig <hch@infradead.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-06-17 at 15:48, William Lee Irwin III wrote:
> Say, could you guys try this? jejb seemed to get decent results with it.

To quantify, my previous results showed 40 merges out of about 32k
segments.

With this patch running the same test, I show 24,007 merges out of 19513
segments (which is about a 55% merger rate).

I also see merges up to 128 segments (the maximum allowed).

James


