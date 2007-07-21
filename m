From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/4] gdth: Split out EISA and ISA register code
Date: Fri, 20 Jul 2007 22:50:20 -0400
Message-ID: <46A1746C.3060300@garzik.org>
References: <20070721022032.GA7264@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:57181 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169AbXGUCu0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jul 2007 22:50:26 -0400
In-Reply-To: <20070721022032.GA7264@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: achim_leubner@adaptec.com, Andrew Morton <akpm@linux-foundation.org>

Notes:

1) If this is stomping on Christoph's work or anyone else's, feel free 
to discard.  This is some "I was bored" PCI hotplug prep work, not a 
high priority at all.

2) This is to be applied on top of the previous gdth patch "remove 
redundant PCI stuff".

3) These changes can be found via git at 
git://git.kernel.org/.../jgarzik/misc-2.6.git#gdth


