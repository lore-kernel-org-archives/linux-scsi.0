From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: RFC: Add I/O class enum values to <scsi/srp.h>
Date: Mon, 05 Jun 2006 14:40:57 -0500
Message-ID: <1149536457.3479.2.camel@mulgrave.il.steeleye.com>
References: <adaodx7o1i0.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:49354 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751310AbWFETlB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jun 2006 15:41:01 -0400
In-Reply-To: <adaodx7o1i0.fsf@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-scsi@vger.kernel.org, openib-general@openib.org

On Mon, 2006-06-05 at 12:17 -0700, Roland Dreier wrote:
> Does anyone have an objection to me merging the trivial patch below
> through my git tree?  This will be used by the IB SRP initiator to
> work with SilverStorm targets, which still implement rev. 10 of the
> SRP spec.  I could just make these values private to the IB initiator,
> but I figured that things directly from the SRP spec belong in
> <scsi/srp.h> rather than in a particular driver's private header.

No objection here ... but if you do, it will entangle our git trees even
more nastily, since the srp.h file is created in the scsi-misc-2.6 tree.

James


