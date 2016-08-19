From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC PATCH 0/4] libfc: Do not send ABTS when resetting exchanges
Date: Thu, 18 Aug 2016 22:36:22 -0400
Message-ID: <yq137m1iixl.fsf@sermon.lab.mkp.net>
References: <1470401703-87045-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40665 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754838AbcHSCgp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Aug 2016 22:36:45 -0400
In-Reply-To: <1470401703-87045-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Fri, 5 Aug 2016 14:54:59 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Hi all, here's a patchset to fixup an issue reported by QLogic:
Hannes> when running against a certain target the libfc stack would get
Hannes> in an infinite loop sending ABTS when trying to reset a
Hannes> connection.  The problem is that the libfc stack is sending ABTS
Hannes> for any open exchanges when removing an rport, totally ignorant
Hannes> of the fact that in most cases we are already logged out of the
Hannes> said remote port.  This patchset alters the handling slightly so
Hannes> that we will only ever reset open exchanges after we have either
Hannes> logged out of the port or an implicit logout can be assumed.
Hannes> With that we don't need to send ABTS any more during rport
Hannes> reset.

Applied to 4.9/scsi-queue. I had to do patch 2 by hand. Please check.

-- 
Martin K. Petersen	Oracle Linux Engineering
