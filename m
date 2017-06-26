From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] virtio_scsi: let host do exception handling
Date: Mon, 26 Jun 2017 13:11:27 -0400
Message-ID: <yq1zicu65ds.fsf@oracle.com>
References: <20170621143546.5826-1-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33995 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbdFZRLm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2017 13:11:42 -0400
In-Reply-To: <20170621143546.5826-1-pbonzini@redhat.com> (Paolo Bonzini's
        message of "Wed, 21 Jun 2017 16:35:46 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, Douglas Miller <dougmill@linux.vnet.ibm.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, stable@vger.kernel.org


Paolo,

> virtio_scsi tries to do exception handling after the default 30
> seconds timeout expires.  However, it's better to let the host control
> the timeout, otherwise with a heavy I/O load it is likely that an
> abort will also timeout.  This leads to fatal errors like filesystems
> going offline.
>
> Disable the 'sd' timeout and allow the host to do exception handling,
> following the precedent of the storvsc driver.

Applied to 4.13/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
