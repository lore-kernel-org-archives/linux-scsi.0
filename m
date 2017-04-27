From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] lpfc: Fix panic on BFS configuration.
Date: Thu, 27 Apr 2017 12:22:47 -0400
Message-ID: <yq1efwd95wo.fsf@oracle.com>
References: <20170426191926.6061-1-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51752 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755474AbdD0QXb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Apr 2017 12:23:31 -0400
In-Reply-To: <20170426191926.6061-1-jsmart2021@gmail.com> (jsmart's message of
        "Wed, 26 Apr 2017 12:19:26 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org, jthumshirn@suse.de, linux-nvme@lists.infradead.org, emilne@redhat.com, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>


James,

Please run checkpatch on your submissions.

> This issue was introduced by this patch:
> http://www.spinics.net/lists/linux-scsi/msg105908.html
> which is in the stable pools with commit id:
> 96418b5e2c8867da3279d877f5d1ffabfe460c3d

This information needs to go in the tag section:

Fixes: 96418b5e2c88 ("scsi: lpfc: Fix eh_deadline setting for sli3 adapters.")


> This patch was cut against the scsi.git tree, misc branch and should
> be pulled in via the scsi tree.
>
> This patch needs to be applied to the stable trees where ever the
> introducing patch exists.

The above commentary needs to go below the --- separator.


And finally:

drivers/scsi/lpfc/lpfc_init.c: In function ‘lpfc_handle_deferred_eratt’:
drivers/scsi/lpfc/lpfc_init.c:1428:3: error: ‘rc’ undeclared (first use in this function)
   rc = lpfc_sli_chipset_init(phba);
   ^
drivers/scsi/lpfc/lpfc_init.c:1428:3: note: each undeclared identifier is reported only once for each function it appears in
drivers/scsi/lpfc/lpfc_init.c:1430:4: warning: ‘return’ with a value, in function returning void [enabled by default]
    return (uint64_t)-1;
    ^
make[3]: *** [drivers/scsi/lpfc/lpfc_init.o] Error 1
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [drivers/scsi/lpfc] Error 2
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2

-- 
Martin K. Petersen	Oracle Linux Engineering
