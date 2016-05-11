From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 2/6] mpt3sas: Handle active cable exception event
Date: Wed, 11 May 2016 16:00:03 +0200
Message-ID: <57333AE3.3090205@redhat.com>
References: <1462525171-6877-1-git-send-email-chaitra.basappa@broadcom.com>
 <1462525171-6877-3-git-send-email-chaitra.basappa@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462525171-6877-3-git-send-email-chaitra.basappa@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chaitra P B <chaitra.basappa@broadcom.com>, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@broadcom.com, suganath-prabu.subramani@broadcom.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 6.5.2016 10:59, Chaitra P B wrote:
> In-order to handle this 'MPI2_EVENT_ACTIVE_CABLE_EXCEPTION' event,
> driver need to follow below steps,
> 1. Unmask the 'MPI2_EVENT_ACTIVE_CABLE_EXCEPTION' event,
> so that FW can notify this event to host driver.
> 2. After receiving this event, add this event to AEN event queue,
> for notifying this event to applications.
> 3. Then Print below message in kernel logs if the event data's reason
> code is zero,
> "Currently an active cable with ReceptacleID <ID_Value> cannot be powered
> and devices connected to this active cable will not be seen. This active
> cable requires <PowerValue_in_mW> of power"
>
> This event is only for Intruder/Cutlass HBAs.
>
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
