From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v8 6/7] sd: Implement support for ZBC devices
Date: Tue, 18 Oct 2016 20:44:35 -0400
Message-ID: <yq1y41lf9qk.fsf@sermon.lab.mkp.net>
References: <1476772835-18541-1-git-send-email-damien.lemoal@wdc.com>
        <1476772835-18541-7-git-send-email-damien.lemoal@wdc.com>
        <x498ttlvbks.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21941 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752683AbcJSAo6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2016 20:44:58 -0400
In-Reply-To: <x498ttlvbks.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
        message of "Tue, 18 Oct 2016 12:58:11 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun@tancheff.com>, Damien Le Moal <damien.lemoal@hgst.com>

>>>>> "Jeff" == Jeff Moyer <jmoyer@redhat.com> writes:

Jeff,

Jeff> Are power of 2 zone sizes required by the standard?  I see why
Jeff> you've done this, but I wonder if we're artificially limiting the
Jeff> implementation, and whether there will be valid devices on the
Jeff> market that simply won't work with Linux because of this.

Standards are deliberately written to be permissive. But Linux doesn't
support arbitrary sector sizes either even though the spec allows it. We
always pick a reasonably sane subset of features to implement and this
case is no different.

After some discussion we decided to rip out all the complexity that was
required to facilitate crazy drive layouts. As a result, the code is now
in a state where we can actually merge it. The hope is that by picking a
specific configuration subset and widely advertising it we can influence
the market.

Also, I am not aware of anybody actually asking the drive vendors to
support crazy zone configurations.

-- 
Martin K. Petersen	Oracle Linux Engineering
