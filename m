From: Alex Williamson <alex.williamson@hp.com>
Subject: RE: mpt sets 64bit consistent mask yet requires mapping in same 4
	GB chunk?!?
Date: Wed, 18 Feb 2004 11:52:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077130375.3066.17.camel@patsy.fc.hp.com>
References: <0E3FA95632D6D047BA649F95DAB60E5703EF9372@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel9.hp.com ([156.153.255.214]:45280 "EHLO atlrel9.hp.com")
	by vger.kernel.org with ESMTP id S267841AbUBRSxG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2004 13:53:06 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5703EF9372@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: jbarnes@sgi.com, jeremy@sgi.com, bjorn.helgaas@hp.com, willy@debian.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Wed, 2004-02-18 at 11:41, Moore, Eric Dean wrote:
> Regarding last weeks thread
> on mpt fusion driver(2.6 kernel), and PrimeIocFifos:
> 
[snip... a third allocation dependency]

> If this fix is urgent, I recommend providing a quick 
> fix which is creating 32bit pci_dev mask just for these 
> three pci_alloc_consistent calls. 
> 

   The current failure mode is pretty ugly and appears fairly random.  I
would consider getting something that works reliably to be urgent.  It
sounds easy and safe to twiddle the consistent device mask in the short
term and combine these allocations in a future rev.  Thanks,

	Alex

-- 
Alex Williamson                             HP Linux & Open Source Lab

