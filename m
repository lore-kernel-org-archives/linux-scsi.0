From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] IB/iser: do I/O path allocations with GFP_NOIO
Date: Wed, 31 May 2006 23:29:30 +0900
Message-ID: <20060531232930L.fujita.tomonori@lab.ntt.co.jp>
References: <Pine.LNX.4.64.0605301448001.734@zuben>
	<447CA214.7010202@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:31104 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP id S965037AbWEaO3c
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 May 2006 10:29:32 -0400
In-Reply-To: <447CA214.7010202@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: ogerlitz@voltaire.com, rdreier@cisco.com, openib-general@openib.org, linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] IB/iser: do I/O path allocations with GFP_NOIO
Date: Tue, 30 May 2006 14:50:44 -0500

> Should iser patches have linux-scsi ccd on them in the future? And
> should they go through the scsi maintainer normally (I understand they
> cannot now since James does not have all the infinniband bits)? I am
> really just trying to avoid any coordinatation issues that come about by
> having core iscsi and tcp iscsi patched sent to the scsi maintainer then
> having to have iser going through Roland.
> 
> For example I left a bit in the core iscsi code so I would not break
> iser. Now iser is updating their code, so we do not need that bit, but
> Or's patch missed the cleanup. If we sent everything through one
> maintainer then we could have cleaned everything up in one pass.

Roland, as proposed in the past, how about moving the iSER and SRP
drivers to drivers/scsi? As you said, they straddle in SCSI and IB
worlds, however, they are just LLDs like iscsi_tcp, which straddle in
SCSI and TCP worlds.

That would help to avoid coordinatation issues too.
