From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Hot plugging a disk in runtime
Date: Mon, 20 May 2002 14:14:25 +0100 (BST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E179mzZ-0005b2-00@the-village.bc.nu>
References: <3CE8EB14.8060803@galileo.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3CE8EB14.8060803@galileo.co.il> from "Rabeeh Khoury" at May 20, 2002 03:24:52 PM
List-Id: linux-scsi@vger.kernel.org
To: Rabeeh Khoury <rabeeh@galileo.co.il>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi <linux-scsi@vger.kernel.org>

> 	 * Usage: echo "scsi add-single-device 0 1 2 3" >/proc/scsi/scsi
> 	 * with  "0 1 2 3" replaced by your "Host Channel Id Lun".
> 	 * Consider this feature BETA.
> 	 *     CAUTION: This is not for hotplugging your peripherals. As
> 	 *     SCSI was not designed for this you could damage your
> 	 *     hardware !
> 	 * However perhaps it is legal to switch on an
> 	 * already connected device. It is perhaps not
> 	 * guaranteed this device doesn't corrupt an ongoing data transfer.
> 	 */
> 
> 1.. What is meant by "SCSI was not designed for this ..." ?

SCSI itself is not. People had a habit of blowing up scsi kit trying to
hot plug stuff that was not meant that way. Obviously thats different for
hot plug certified SCA2 equipment

> 3.. What about the naming of /dev/sdxx naming of newly hot-plugged SCSI disk ? which name does it get ? (supposly I'm not using the dev filesystem)

it gets the next free one


