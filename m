From: Andi Kleen <ak@colin2.muc.de>
Subject: Re: [PATCH] Allow x86-64 compilation for ips.c
Date: 12 Aug 2003 00:52:24 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030811225224.GA5209@colin2.muc.de>
References: <A3B9245C291EEF4785A24A1DBE8D852B3530FF@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colin2.muc.de ([193.149.48.15]:49671 "HELO colin2.muc.de")
	by vger.kernel.org with SMTP id S274882AbTHKWw2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Aug 2003 18:52:28 -0400
Date: Tue, 12 Aug 2003 00:52:24 +0200
Content-Disposition: inline
In-Reply-To: <A3B9245C291EEF4785A24A1DBE8D852B3530FF@rtpexc01.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Hammer, Jack" <Jack_Hammer@adaptec.com>
Cc: 'Andi Kleen' <ak@muc.de>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Mon, Aug 11, 2003 at 07:48:30AM -0400, Hammer, Jack wrote:
> Please do not apply this patch - It is incomplete.  A complete patch (
> there's more to x86_64 than just this one change ) to ips for x86_64 support
> is coming from the maintainers at Adaptec ( probably within a week ).

I tested with this patch on x86-64 and it worked fine.

What other changes do you intend to make? 

-Andi
