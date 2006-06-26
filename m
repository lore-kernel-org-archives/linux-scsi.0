From: "Robert Mueller" <robm@fastmail.fm>
Subject: Re: Areca driver recap + status
Date: Tue, 27 Jun 2006 08:32:19 +1000
Message-ID: <057801c69970$70b45090$0e00cb0a@robm>
References: <09be01c695b3$2ed8c2c0$c100a8c0@robm> <20060621222826.ff080422.akpm@osdl.org> <1151333338.2673.4.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="Windows-1252";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:35793 "EHLO
	out3.smtp.messagingengine.com") by vger.kernel.org with ESMTP
	id S933114AbWFZWcZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jun 2006 18:32:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@osdl.org>
Cc: rdunlap@xenotime.net, hch@infradead.org, erich@areca.com.tw, brong@fastmail.fm, dax@gurulabs.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


> - PAE (cast of dma_addr_t to unsigned long) issues.

Can you explain a bit what this is about and what the effect is? It's just 
that we've been using the driver (older version from the areca website) in a 
PAE kernel on machines with 8G of memory and haven't had a problem yet 
(running high IO load for several weeks) but this sounds like it 
might/should cause corruption or crashing in this situation?

Rob

