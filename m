From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 2/2] ahci_xgene: Fix the dma state machine lockup for
 the ATA_CMD_PACKET PIO mode command.
Date: Wed, 17 Dec 2014 20:32:01 +0300
Message-ID: <5491BE11.4070500@cogentembedded.com>
References: <1418748575-27301-1-git-send-email-stripathi@apm.com>	<1418748575-27301-3-git-send-email-stripathi@apm.com>	<54906CF0.9010908@cogentembedded.com> <CAOHikRCRHPnVAziU8jwD9gGFODyt_5DpL1dm7Eb8uGA-WOfxOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:40555 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaLQRcG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Dec 2014 12:32:06 -0500
Received: by mail-la0-f47.google.com with SMTP id hz20so13754407lab.34
        for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2014 09:32:04 -0800 (PST)
In-Reply-To: <CAOHikRCRHPnVAziU8jwD9gGFODyt_5DpL1dm7Eb8uGA-WOfxOw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>, patches@apm.com

Hello.

On 12/17/2014 08:21 AM, Suman Tripathi wrote:

>     This patch addresses the issue with ATA_CMD_PACKET pio mode
>     command for enumeration and device detection with ATAPI devices.It is the
>     same issue as in patch

    Ugh, HTML... Please stick to plain text when posting to the 
'vger.kernel.org' mailing lists (HTML mails are supposed to be ignored).

>     www.spinics.net/lists/linux-__ide/msg49092.html
>     <http://www.spinics.net/lists/linux-ide/msg49092.html>
>
>
>     Signed-off-by: Suman Tripathi <stripathi@apm.com <mailto:stripathi@apm.com>>
>     ---
>        drivers/ata/ahci_xgene.c | 12 +++++++-----
>        1 file changed, 7 insertions(+), 5 deletions(-)
>
>
>     diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
>     index 0ffd3c9..9730907 100644
>     --- a/drivers/ata/ahci_xgene.c
>     +++ b/drivers/ata/ahci_xgene.c
>     @@ -125,10 +125,11 @@ static int xgene_ahci_restart_engine(__struct
>     ata_port *ap)
>         * xgene_ahci_qc_issue - Issue commands to the device
>         * @qc: Command to issue
>         *
>     - * Due to Hardware errata for IDENTIFY DEVICE command, the controller cannot
>     - * clear the BSY bit after receiving the PIO setup FIS. This results in
>     the dma
>     - * state machine goes into the CMFatalErrorUpdate state and locks up. By
>     - * restarting the dma engine, it removes the controller out of lock up state.
>     + * Due to Hardware errata for IDENTIFY DEVICE command and COMMAND PACKET
>
>
>     Just PACKET.
>
>     + * command of ATAPI protocol set, the controller cannot clear the BSY bit
>     + * after receiving the PIO setup FIS. This results in the dma state machine
>
>
>     DMA.
>
>     + * goes into the CMFatalErrorUpdate state and locks up. By restarting the

>     s/goes/going/.

> [suman] : Didn't understand this. Do you mean to change to going ?

    It's a 'sed' command to replace "goes" by "going" IIRC. Yes. Also, 
s/locks/locking/.

> It is already goes there.

> [...]

> Thanks,
> with regards,
> suman

MBR, Sergei

