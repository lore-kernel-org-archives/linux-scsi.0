From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sg: Re-fix off by one in sg_fill_request_table()
Date: Tue, 17 Oct 2017 22:41:48 -0400
Message-ID: <yq1po9luqhf.fsf@oracle.com>
References: <20171015171633.rphqeyc46uy4l5tx@xylophone.i.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171015171633.rphqeyc46uy4l5tx@xylophone.i.decadent.org.uk>
        (Ben Hutchings's message of "Sun, 15 Oct 2017 18:16:33 +0100")
Sender: stable-owner@vger.kernel.org
To: Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Dan Carpenter <dan.carpenter@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Ben,

> Commit 109bade9c625 ("scsi: sg: use standard lists for sg_requests")
> introduced an off-by-one error in sg_ioctl(), which was fixed by
> commit bd46fc406b30 ("scsi: sg: off by one in sg_ioctl()").
>
> Unfortunately commit 4759df905a47 ("scsi: sg: factor out
> sg_fill_request_table()") moved that code, and reintroduced the
> bug (perhaps due to a botched rebase).  Fix it again.

Applied to 4.14/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
