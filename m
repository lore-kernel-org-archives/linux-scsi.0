From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 10/10] scsi: Implement blk_mq_ops.show_rq()
Date: Mon, 24 Apr 2017 19:33:44 -0400
Message-ID: <yq1r30hfkiv.fsf@oracle.com>
References: <20170421234026.18970-1-bart.vanassche@sandisk.com>
        <20170421234026.18970-11-bart.vanassche@sandisk.com>
        <yq1k269ij5f.fsf@oracle.com> <1493070575.3394.19.camel@sandisk.com>
        <yq1zif5fl61.fsf@oracle.com>
        <20170424232359.GA21578@vader.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38068 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S978950AbdDXXfA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2017 19:35:00 -0400
In-Reply-To: <20170424232359.GA21578@vader.DHCP.thefacebook.com> (Omar
        Sandoval's message of "Mon, 24 Apr 2017 16:23:59 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "hare@suse.com" <hare@suse.com>, "axboe@kernel.dk" <axboe@kernel.dk>


Omar,

> The debugfs infrastructure is already there, and it already supports
> showing requests. Bart is just exposing the SCSI information.

That's fine.

I was merely objecting to the fact that we already have umpteen existing
interfaces for displaying SCSI command information.

-- 
Martin K. Petersen	Oracle Linux Engineering
