From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH] IB/iser: do I/O path allocations with GFP_NOIO
Date: Wed, 31 May 2006 07:41:33 -0700
Message-ID: <adalksi2r4y.fsf@cisco.com>
References: <Pine.LNX.4.64.0605301448001.734@zuben>
	<447CA214.7010202@cs.wisc.edu>
	<20060531232930L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-5.cisco.com ([171.68.10.87]:3866 "EHLO
	sj-iport-5.cisco.com") by vger.kernel.org with ESMTP
	id S965044AbWEaOlh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 May 2006 10:41:37 -0400
In-Reply-To: <20060531232930L.fujita.tomonori@lab.ntt.co.jp> (FUJITA Tomonori's message of "Wed, 31 May 2006 23:29:30 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: michaelc@cs.wisc.edu, ogerlitz@voltaire.com, openib-general@openib.org, linux-scsi@vger.kernel.org

    > Roland, as proposed in the past, how about moving the iSER
    > and SRP drivers to drivers/scsi? As you said, they
    > straddle in SCSI and IB worlds, however, they are just
    > LLDs like iscsi_tcp, which straddle in SCSI and TCP
    > worlds.

I have no problem with that, although in general I'm not thrilled
about moving files around, since it usually is churn without a
technical advantage.

If SRP and iSER were in drivers/scsi, would that mean James would have
to maintain them?  That would be a change in workflow.

 - R.
