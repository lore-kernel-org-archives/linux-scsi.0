From: Andi Kleen <ak@colin2.muc.de>
Subject: Re: [PATCH] Allow x86-64 compilation for ips.c
Date: 12 Aug 2003 00:57:36 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030811225736.GB5209@colin2.muc.de>
References: <A3B9245C291EEF4785A24A1DBE8D852B3530FF@rtpexc01.adaptec.com> <20030811225224.GA5209@colin2.muc.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colin2.muc.de ([193.149.48.15]:14088 "HELO colin2.muc.de")
	by vger.kernel.org with SMTP id S274877AbTHKW5k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Aug 2003 18:57:40 -0400
Date: Tue, 12 Aug 2003 00:57:36 +0200
Content-Disposition: inline
In-Reply-To: <20030811225224.GA5209@colin2.muc.de>
List-Id: linux-scsi@vger.kernel.org
To: "Hammer, Jack" <Jack_Hammer@adaptec.com>
Cc: 'Andi Kleen' <ak@muc.de>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Tue, Aug 12, 2003 at 12:52:24AM +0200, Andi Kleen wrote:
> On Mon, Aug 11, 2003 at 07:48:30AM -0400, Hammer, Jack wrote:
> > Please do not apply this patch - It is incomplete.  A complete patch (
> > there's more to x86_64 than just this one change ) to ips for x86_64 support
> > is coming from the maintainers at Adaptec ( probably within a week ).
> 
> I tested with this patch on x86-64 and it worked fine.
> 
> What other changes do you intend to make? 

Ok one issue I see is that you do not test the return value of pci_map_sg()
Hopefully that's fixed in the upcomming patchkit.

-Andi
