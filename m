From: berthiaume_wayne@emc.com
Subject: RE: Hot plugging a disk in runtime
Date: Mon, 20 May 2002 12:34:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <93F527C91A6ED411AFE10050040665D0049BFA5A@corpusmx1.us.dg.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk
Cc: linux-scsi@vger.kernel.org, rabeeh@galileo.co.il

	Will it, possibly, cause a reordering of other sd<xx> devices
already on line when scsi_init is called?

-----Original Message-----
From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
Sent: Monday, May 20, 2002 9:14 AM
To: rabeeh@galileo.co.il
Cc: alan@lxorguk.ukuu.org.uk; linux-scsi@vger.kernel.org
Subject: Re: Hot plugging a disk in runtime


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

> 3.. What about the naming of /dev/sdxx naming of newly hot-plugged SCSI
disk ? which name does it get ? (supposly I'm not using the dev filesystem)

it gets the next free one


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
