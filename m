From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] Use ctlr directly in rdac_failover_get()
Date: Tue, 23 May 2017 21:55:19 -0400
Message-ID: <yq160grxblk.fsf@oracle.com>
References: <1495232608.2581.3.camel@sandisk.com>
        <1495267090-8591-1-git-send-email-asavkov@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1495267090-8591-1-git-send-email-asavkov@redhat.com> (Artem
        Savkov's message of "Sat, 20 May 2017 09:58:10 +0200")
Sender: stable-owner@vger.kernel.org
To: Artem Savkov <asavkov@redhat.com>
Cc: hare@suse.de, axboe@fb.com, hch@lst.de, martin.petersen@oracle.com, Bart Van Assche <Bart.VanAssche@sandisk.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Artem,

> rdac_failover_get references struct rdac_controller as
> ctlr->ms_sdev->handler_data->ctlr for no apparent reason. Besides being
> inefficient this also introduces a null-pointer dereference as
> send_mode_select() sets ctlr->ms_sdev to NULL before calling
> rdac_failover_get():

Applied to 4.12/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
