From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] MegaRAID RAID driver version 2.00 - introduced as new megaraid2 in 2.4.x and 2.5.x
Date: Wed, 13 Nov 2002 01:33:10 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021113013310.A2830@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E570185ED7B@EXA-ATLANTA.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570185ED7B@EXA-ATLANTA.se.lsil.com>; from atulm@lsil.com on Tue, Nov 12, 2002 at 08:24:57PM -0500
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <atulm@lsil.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

[could you cut down the Cc list to something reasonable next time?]

On Tue, Nov 12, 2002 at 08:24:57PM -0500, Mukker, Atul wrote:
> Alan et al,
> 
> Attached please find the megaraid driver version 2.00, which is to be
> introduced as megaraid2 in 2.4.x and 2.5.x kernels. The mail has two
> attachments:
> 1.	megaraid v200 for 2.4.x kernels - megaraid2-v200.tar.gz
> 2.	patch for 2.5.x kernels - megaraid2-v200-24x-25x.patch.gz
> 
> Other people on linux lists: Driver is not attached for lists. Please await
> announcement from Matt Domsch after he has updated the appropriate download
> sites.

Please don't add another driver.  From what I've seen the megaraid2
is nothing but the bugfixes/partial rewrite RH did for their Advanced
Server.  Just add it to 2.5 and maybe 2.4-ac instead of the current driver,
if it proves stable it can go into 2.4 later.

