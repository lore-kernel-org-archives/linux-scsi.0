From: Andi Kleen <ak@suse.de>
Subject: Re: Fusion problems with 2.6.5rc1 on AMD x86-64 IV
Date: Wed, 17 Mar 2004 16:53:55 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040317165355.37c846f0.ak@suse.de>
References: <0E3FA95632D6D047BA649F95DAB60E57040DB1E2@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:33478 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S261809AbUCQQPA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2004 11:15:00 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57040DB1E2@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Emoore@lsil.com, James.Bottomley@HansenPartnership.com

On Wed, 17 Mar 2004 10:58:09 -0500
"Moore, Eric Dean" <Emoore@lsil.com> wrote:

> There is a bug in the driver where we do three
> seperate memory allocations for the request/reply FIFOs 
> that need to be on the same 4gb boundary. This is on my todo list,
> hope to fix soon.

The problem seems to be the broke consistent dma mask.

I currently just mask it with 0xffffffff in pci_alloc_consistent
and why that workaround it works.

-Andi
