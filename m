From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] libfc: don't have fc_exch_find log errors on a new exchange
Date: Wed, 26 Oct 2016 21:41:18 -0400
Message-ID: <yq1eg327em9.fsf@sermon.lab.mkp.net>
References: <1477084253-1742-1-git-send-email-cleech@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32087 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932814AbcJ0BlZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2016 21:41:25 -0400
In-Reply-To: <1477084253-1742-1-git-send-email-cleech@redhat.com> (Chris
        Leech's message of "Fri, 21 Oct 2016 14:10:53 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Leech <cleech@redhat.com>
Cc: linux-scsi@vger.kernel.org

>>>>> "Chris" == Chris Leech <cleech@redhat.com> writes:

Chris> With the error message I added in "libfc: sanity check cpu number
Chris> extracted from xid" I didn't account for the fact that
Chris> fc_exch_find is called with FC_XID_UNKNOWN at the start of a new
Chris> exchange if we are the responder.

Chris> It doesn't come up with the initiator much, but that's basically
Chris> every exchange for a target.  By checking the xid for
Chris> FC_XID_UNKNOWN first, we not only prevent the erroneous error
Chris> message, but skip the unnecessary lookup attempt as well.

Applied to 4.10/scsi-queue by hand as a result of all the libfc
changes. Please verify.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
