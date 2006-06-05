From: Roland Dreier <rdreier@cisco.com>
Subject: Re: RFC: Add I/O class enum values to <scsi/srp.h>
Date: Mon, 05 Jun 2006 12:55:43 -0700
Message-ID: <adafyijnzr4.fsf@cisco.com>
References: <adaodx7o1i0.fsf@cisco.com>
	<1149536457.3479.2.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-5.cisco.com ([171.68.10.87]:40791 "EHLO
	sj-iport-5.cisco.com") by vger.kernel.org with ESMTP
	id S1751343AbWFETzs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jun 2006 15:55:48 -0400
In-Reply-To: <1149536457.3479.2.camel@mulgrave.il.steeleye.com> (James Bottomley's message of "Mon, 05 Jun 2006 14:40:57 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, openib-general@openib.org

    James> No objection here ... but if you do, it will entangle our
    James> git trees even more nastily, since the srp.h file is
    James> created in the scsi-misc-2.6 tree.

No, I think we're OK.  srp.h is already in Linus's tree (it went in as
part of the original IB SRP initiator merge), and scsi-misc doesn't have
any changes after ec448a0a36 (which is already upstream) in it.  So
putting the IO Class change in my tree actually reduces the dependency
between our trees, since I can put the IB SRP changes in my tree
without worrying about you merging the srp.h change first.

 - R.
