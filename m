From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Areca driver recap + status
Date: Tue, 27 Jun 2006 10:39:27 -0500
Message-ID: <1151422767.3340.29.camel@mulgrave.il.steeleye.com>
References: <09be01c695b3$2ed8c2c0$c100a8c0@robm>
	 <20060621222826.ff080422.akpm@osdl.org>
	 <1151333338.2673.4.camel@mulgrave.il.steeleye.com>
	 <057801c69970$70b45090$0e00cb0a@robm>
	 <1151422074.3340.25.camel@mulgrave.il.steeleye.com>
	 <1151423500.32186.39.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:41668 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1161105AbWF0Pjr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jun 2006 11:39:47 -0400
In-Reply-To: <1151423500.32186.39.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Robert Mueller <robm@fastmail.fm>, Andrew Morton <akpm@osdl.org>, rdunlap@xenotime.net, hch@infradead.org, erich@areca.com.tw, brong@fastmail.fm, dax@gurulabs.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 2006-06-27 at 16:51 +0100, Alan Cox wrote:
> On x86_64 the dma_addr_t and the ulong are both 64bit so the problem
> doesn't arise. 

Yes it does ... apparently 32 bit kernel on x86_64 is a lot more common
than people suppose.  In > 4GB this is exactly PAE.

James


