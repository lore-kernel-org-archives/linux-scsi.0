From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Hot plugging a disk in runtime
Date: Mon, 20 May 2002 12:57:43 +0100 (BST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E179lnL-0005Re-00@the-village.bc.nu>
References: <3CE8CDC9.7070200@galileo.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3CE8CDC9.7070200@galileo.co.il> from "Rabeeh Khoury" at May 20, 2002 01:19:53 PM
List-Id: linux-scsi@vger.kernel.org
To: Rabeeh Khoury <rabeeh@galileo.co.il>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

> 1.. How is it possible to signal SCSI mid-layer (or other layers) of a 
> presence of a newly hot-plugged disk ?

aacraid is one example that does this, but via its config tools.

> 2.. Can an adapter's device driver trigger SCSI subsystem to scan 
> channels for new LUNs / Targets ?

It is designed so user space can do so - so yes

> 3.. Is this can be handled in a kernel level ? is there a user space 
> application that can be triggered to start scanning adapters (obviously 
> through SCSI subsystem) and registering new LUNs / Targets etc... ?

echo "scsi-add-single-device a b c d" /proc/scsi/scsi 

if I remember it right

Alan
