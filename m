From: Alan Cox <alan@redhat.com>
Subject: Re: I have modified the megaraid driver v2.00.5 from kernel 2.6 t o 2 .4.22-prex-ac1
Date: Thu, 24 Jul 2003 09:09:39 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200307241309.h6OD9dg06659@devserv.devel.redhat.com>
References: <20030724114156.GC1485@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pix-525-pool.redhat.com ([66.187.233.200]:35298 "EHLO
	devserv.devel.redhat.com") by vger.kernel.org with ESMTP
	id S263930AbTGXMyh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jul 2003 08:54:37 -0400
In-Reply-To: <20030724114156.GC1485@parcelfarce.linux.theplanet.co.uk> from "Matthew Wilcox" at Gor 24, 2003 12:41:56 
List-Id: linux-scsi@vger.kernel.org
Cc: Tomita Haruo <haruo.tomita@toshiba.co.jp>, Matthew Wilcox <willy@debian.org>, atulm@lsil.com, Matt Domsch <Matt_Domsch@dell.com>, linux-megaraid-devel@dell.com, linux-scsi@vger.kernel.org, Tomita Haruo <htomita@pcs.pc.ome.toshiba.co.jp>

> No, not at all.  I'm criticising the original code here, not your patch.
> In my opinion, we should simply delete these lines:

That would be a bad idea. Some of the devices share the same non subsys id
with non megaraid cards (INTEL I960) and the result is that megaraid cards
fall out with some other stuff.

