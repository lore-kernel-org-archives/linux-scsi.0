From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH] IB/iser: do I/O path allocations with GFP_NOIO
Date: Tue, 30 May 2006 13:35:37 -0700
Message-ID: <ada64jn6yjq.fsf@cisco.com>
References: <Pine.LNX.4.64.0605301448001.734@zuben>
	<447CA214.7010202@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-4.cisco.com ([171.68.10.86]:65433 "EHLO
	sj-iport-4.cisco.com") by vger.kernel.org with ESMTP
	id S932404AbWE3Uft (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 May 2006 16:35:49 -0400
In-Reply-To: <447CA214.7010202@cs.wisc.edu> (Mike Christie's message of "Tue, 30 May 2006 14:50:44 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Or Gerlitz <ogerlitz@voltaire.com>, openib-general@openib.org, linux-scsi@vger.kernel.org

    Mike> Should iser patches have linux-scsi ccd on them in the
    Mike> future? And should they go through the scsi maintainer
    Mike> normally (I understand they cannot now since James does not
    Mike> have all the infinniband bits)? I am really just trying to
    Mike> avoid any coordinatation issues that come about by having
    Mike> core iscsi and tcp iscsi patched sent to the scsi maintainer
    Mike> then having to have iser going through Roland.

    Mike> Does srp go from openib-general and Roland then to lkml? For
    Mike> iscsi we do not go through net-dev and we live in
    Mike> drivers/scsi so maybe we are the odd driver?:) What is the
    Mike> proper or normal procedure?

It's a problem because SRP and iSER are straddling both the SCSI and
IB worlds.  Probably the best policy is to cc all relevant mailing
lists (at least linux-scsi and openib-general) whenever there's a
doubt about who should see something.

As far as merging patches goes, I've been merging SRP changes directly
to Linus, except for generic fixes to <scsi/srp.h>, which I've been
sending through James.  Or felt that iSCSI should be merged through my
tree, but I have no problem if in the future patches bypass my tree.
(But I would like to be cc'ed on changes to IB stuff, especially core
things outside of specific drivers)

(Which all reminds me I have a question about SCSI EH and SRP to send
to the linux-scsi list...)

 - R.
