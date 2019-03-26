From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: lpfc: avoid uninitialized variable warning
Date: Mon, 25 Mar 2019 22:17:52 -0400
Message-ID: <yq1tvfqz8dr.fsf@oracle.com>
References: <20190322142557.929966-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190322142557.929966-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Fri, 22 Mar 2019 15:25:49 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> clang -Wuninitialized incorrectly sees a variable being used without
> initialization:
>
> drivers/scsi/lpfc/lpfc_nvme.c:2102:37: error: variable 'localport' is uninitialized when used here
>       [-Werror,-Wuninitialized]
>                 lport = (struct lpfc_nvme_lport *)localport->private;
>                                                   ^~~~~~~~~
> drivers/scsi/lpfc/lpfc_nvme.c:2059:38: note: initialize the variable 'localport' to silence this warning
>         struct nvme_fc_local_port *localport;
>                                             ^
>                                              = NULL
> 1 error generated.

Applied to 5.2/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
