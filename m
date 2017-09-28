From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ILLEGAL REQUEST + ASC==27 => target failure
Date: Wed, 27 Sep 2017 21:56:29 -0400
Message-ID: <yq1a81f8u2a.fsf@oracle.com>
References: <20170927124419.23637-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20708 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751946AbdI1B4o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2017 21:56:44 -0400
In-Reply-To: <20170927124419.23637-1-mwilck@suse.com> (Martin Wilck's message
        of "Wed, 27 Sep 2017 14:44:19 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Wilck <mwilck@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, Martin Wilck <mwilck@suse.de>


Martin,

> ASC 0x27 is "WRITE PROTECTED". This error code is returned e.g.  by
> Fujitsu ETERNUS systems under certain conditions for WRITE SAME 16
> commands with UNMAP bit set. It should not be treated as a path
> error. In general, it makes sense to assume that being write protected
> is a target rather than a path property.

Applied to 4.14/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
