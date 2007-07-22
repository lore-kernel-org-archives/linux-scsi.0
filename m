From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/4] gdth: Split out EISA and ISA register code
Date: 22 Jul 2007 02:02:22 +0200
Message-ID: <p73d4yluwz5.fsf@bingen.suse.de>
References: <20070721022032.GA7264@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48087 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbXGUXH2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jul 2007 19:07:28 -0400
In-Reply-To: <20070721022032.GA7264@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, achim_leubner@adaptec.com, Andrew Morton <akpm@linux-foundation.org>

Jeff Garzik <jeff@garzik.org> writes:

> No code changes, only indentation and blank line additions, plus code to
> call the new split-out functions.

Could you put the ISA code into #ifdef CONFIG_ISA while you're on it? 

That would allow dropping it on x86-64 

-Andi
