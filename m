From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3] lpfc: Fix panic on BFS configuration.
Date: Mon, 08 May 2017 21:26:11 -0400
Message-ID: <yq1h90uu8gc.fsf@oracle.com>
References: <20170427220826.12693-1-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170427220826.12693-1-jsmart2021@gmail.com> (jsmart's message
        of "Thu, 27 Apr 2017 15:08:26 -0700")
Sender: stable-owner@vger.kernel.org
To: jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, stable@vger.kernel.org, loberman@redhat.com, jthumshirn@suse.de, emilne@redhat.com, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>
List-Id: linux-scsi@vger.kernel.org


James,

> Fix is to reset the sli-3 function before sending the mailbox command,
> thus synchronizing the function/driver on mailbox location.

Applied to 4.12/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
