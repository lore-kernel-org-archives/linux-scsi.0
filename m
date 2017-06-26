From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Remove the definition of VLC_SA_RECEIVE_CREDENTIAL
Date: Mon, 26 Jun 2017 13:39:18 -0400
Message-ID: <yq1wp7y4pix.fsf@oracle.com>
References: <20170623173239.16901-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49011 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbdFZRkR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2017 13:40:17 -0400
In-Reply-To: <20170623173239.16901-1-bart.vanassche@wdc.com> (Bart Van
        Assche's message of "Fri, 23 Jun 2017 10:32:39 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>


Bart,

> The symbolic name VLC_SA_RECEIVE_CREDENTIAL is not used anywhere in
> the kernel. Additionally, since SPC 5 the RECEIVE CREDENTIAL command
> is obsolete. The VLC_SA_RECEIVE_CREDENTIAL definition is misleading
> since it occurs outside the list of other variable length CDB service
> action codes (READ_32, WRITE_32, ...). Hence remove this definition.

Applied to 4.13/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
