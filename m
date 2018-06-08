From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qla2xxx: Fix crash on qla2x00_mailbox_command
Date: Thu, 07 Jun 2018 20:26:33 -0400
Message-ID: <yq1sh5y86o6.fsf@oracle.com>
References: <1527530324-32359-1-git-send-email-rosattig@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1527530324-32359-1-git-send-email-rosattig@linux.vnet.ibm.com>
        (Rodrigo R. Galvao's message of "Mon, 28 May 2018 14:58:44 -0300")
Sender: linux-kernel-owner@vger.kernel.org
To: "Rodrigo R. Galvao" <rosattig@linux.vnet.ibm.com>
Cc: maurosr@linux.vnet.ibm.com, kernel@gpiccoli.net, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Rodrigo,

> This patch fixes a crash on qla2x00_mailbox_command caused when the
> driver is on UNLOADING state and tries to call qla2x00_poll, which
> triggers a NULL pointer dereference.

Applied to 4.18/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
