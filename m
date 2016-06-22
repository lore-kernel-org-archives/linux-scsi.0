From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/3] scsi: disable VPD page check on error
Date: Tue, 21 Jun 2016 22:54:41 -0400
Message-ID: <yq137o62ary.fsf@sermon.lab.mkp.net>
References: <1466405868-87720-1-git-send-email-hare@suse.de>
	<1466405868-87720-3-git-send-email-hare@suse.de>
	<1466429138.4039.15.camel@localhost.localdomain>
	<1466430242.2350.4.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:18477 "EHLO
	userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbcFVECw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jun 2016 00:02:52 -0400
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
	by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u5M2ug4h019590
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jun 2016 02:56:42 GMT
In-Reply-To: <1466430242.2350.4.camel@HansenPartnership.com> (James
	Bottomley's message of "Mon, 20 Jun 2016 06:44:02 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: emilne@redhat.com, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

James> I also don't really like this.  If the device has a failure like
James> the QEMU one where it just hangs up, this won't help because the
James> problem already happened.  Conversely, if the device replies in
James> the negative, it should always do so, so I can't see what this
James> buys us, except the possibility of doing the wrong thing on a
James> transient error

Yeah.

James> I'd be much happier if you can point to a problem that this would
James> solve.

I'd like more details as well.

If we are going to entertain skipping VPD pages on error I would like it
to be as a result of a clear indication that it's the VPD that's the
problem and not just any error returned while querying the page.

-- 
Martin K. Petersen	Oracle Linux Engineering
