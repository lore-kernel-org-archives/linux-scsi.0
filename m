From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: SG TUR and AIO
Date: Fri, 15 Jun 2007 09:18:22 +0900
Message-ID: <20070615091822J.fujita.tomonori@lab.ntt.co.jp>
References: <1181775543.20149.180.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:41586 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757965AbXFOASN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jun 2007 20:18:13 -0400
In-Reply-To: <1181775543.20149.180.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: christophe.varoqui@free.fr
Cc: linux-scsi@vger.kernel.org

From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: SG TUR and AIO
Date: Thu, 14 Jun 2007 00:59:03 +0200

> Hi,
> 
> I'm trying to make multipath daemon checking asynchronous, and most path
> checkers use SG. Please bare with some questions on this wild wild topic
> (to search engine criteria).
> 
> Is it possible to submit through AIO (libaio API) any SG command forged
> with struct sg_io_hdr ?
> 
> I've seen the INQ example in the sg3_utils package, so I guess it should
> work there. But what about "Test Unit Ready" command ?

I don't think that it is supported though sg_simple_aio.c uses
io_submit().

 
> Also why in the example, only the SG IO write is asynchronous ? Is the
> inquiry response read qaranteed to be non-blocking ? Would an pread io
> work at all ?
> 
> Is there other pointers to code snippets showing these two subsystems
> together ?

I think that you can handle a SG command asynchronously by using
read/write interface with a non-blocking fd.
