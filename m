From: Christoph Hellwig <hch@infradead.org>
Subject: Re: dpt_i2o in 2.6.0_test*
Date: Sat, 9 Aug 2003 21:17:06 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030809211706.A1938@infradead.org>
References: <1060459960.3882.121.camel@hammer.dale.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:17935 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S275394AbTHIURI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Aug 2003 16:17:08 -0400
Content-Disposition: inline
In-Reply-To: <1060459960.3882.121.camel@hammer.dale.ro>; from slak@dale.ro on Sat, Aug 09, 2003 at 11:12:40PM +0300
List-Id: linux-scsi@vger.kernel.org
To: "Alexandru N. Barloiu" <slak@dale.ro>
Cc: linux-scsi@vger.kernel.org

On Sat, Aug 09, 2003 at 11:12:40PM +0300, Alexandru N. Barloiu wrote:
> hello,
> I just wanted to ask if there is a fix for this.
> 
>   CC      drivers/scsi/dpt_i2o.o
> drivers/scsi/dpt_i2o.c:32:2: #error Please convert me to

According to Alan the fix is to use the i2o_scsi driver instead.
Could you try it?

