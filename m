From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: qla2xxx and feral ISP updates in their respective BK trees
Date: Fri, 20 Jun 2003 17:59:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EF383D1.7070900@pobox.com>
References: <1055971780.2075.484.camel@mulgrave> <20030620101224.B305@wonky.in0.lcl> <1056129548.2102.19.camel@mulgrave> <20030620102448.O305@wonky.in0.lcl> <1056133068.1804.22.camel@mulgrave> <20030620183417.GB9164@gtf.org> <20030620113759.B305@wonky.in0.lcl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:14771 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264899AbTFTVp6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jun 2003 17:45:58 -0400
In-Reply-To: <20030620113759.B305@wonky.in0.lcl>
List-Id: linux-scsi@vger.kernel.org
To: mjacob@feral.com
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Vasquez <praka@san.rr.com>, Andrew Morton <akpm@digeo.com>

Matthew Jacob wrote:
> a) Historically, MMIO has been buggy on ia32. This is no longer the
> case, but there definitely were a lot of platforms with this broken.

Could you elaborate?

What I've mostly found is (in order of frequency):  coders unfamiliar 
with x86 CPU write coalescing/posting rules, and PCI boards whose 
hardware designs contain inherent races when driven in MMIO mode 
(particularly on CPUs with deeply posted writes).


> b) MMIO is consumption of mapping resources, while PIO isn't.

agreed

	Jeff



