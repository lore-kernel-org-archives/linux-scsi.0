From: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 2.6 ] MPT Fusion driver 3.01.02 update
Date: Thu, 18 Mar 2004 02:09:48 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040318020948.2f884e89.ak@suse.de>
References: <0E3FA95632D6D047BA649F95DAB60E57040DB25E@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:20144 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S262279AbUCRBKC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2004 20:10:02 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57040DB25E@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, Alexander.Stohr@gmx.de, rddunlap@osdl.org

On Wed, 17 Mar 2004 14:43:21 -0500
"Moore, Eric Dean" <Emoore@lsil.com> wrote:

> This is an update for the MPT Fusion drivers 2.6 kernel.
> Version 3.01.02.
> 
This doesn't seem to fix the bug I'm running into all the time:

you set a 64bit consistent dma mask, but assume in PrimeIocFifos 
that two calls to pci_alloc_consistent() end in the same 4GB 
segment, which cannot work.

As a workaround i just reverted it to a 4GB consistent mask for now.

-Andi



