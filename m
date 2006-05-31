From: Or Gerlitz <ogerlitz@voltaire.com>
Subject: Re: [PATCH] IB/iser: do I/O path allocations with GFP_NOIO
Date: Wed, 31 May 2006 15:55:28 +0300
Message-ID: <447D9240.3010106@voltaire.com>
References: <Pine.LNX.4.64.0605301448001.734@zuben>	<447CA214.7010202@cs.wisc.edu> <ada64jn6yjq.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from taurus.voltaire.com ([193.47.165.240]:42383 "EHLO
	taurus.voltaire.com") by vger.kernel.org with ESMTP id S964988AbWEaMzd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 May 2006 08:55:33 -0400
In-Reply-To: <ada64jn6yjq.fsf@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Roland Dreier <rdreier@cisco.com>, openib-general@openib.org, linux-scsi@vger.kernel.org

Roland Dreier wrote:
> It's a problem because SRP and iSER are straddling both the SCSI and
> IB worlds.  Probably the best policy is to cc all relevant mailing
> lists (at least linux-scsi and openib-general) whenever there's a
> doubt about who should see something.

We are monitoring linux-scsi for tracking iscsi upstream updates.

> As far as merging patches goes, I've been merging SRP changes directly
> to Linus, except for generic fixes to <scsi/srp.h>, which I've been
> sending through James.  Or felt that iSCSI should be merged through my
> tree, but I have no problem if in the future patches bypass my tree.
> (But I would like to be cc'ed on changes to IB stuff, especially core
> things outside of specific drivers)

At this point, we prefer that iser related updates/merges would go 
through Roland, the IB maintainer, if this poses a problem for 
scsi/iscsi updates we are open to send our updates/merges via the scsi 
maintainer.

Or.



