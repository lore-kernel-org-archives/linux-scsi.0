From: Rabeeh Khoury <rabeeh@galileo.co.il>
Subject: Re: Hot plugging a disk in runtime
Date: Mon, 20 May 2002 15:24:52 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CE8EB14.8060803@galileo.co.il>
References: <E179lnL-0005Re-00@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi <linux-scsi@vger.kernel.org>



Alan Cox wrote:

>echo "scsi-add-single-device a b c d" /proc/scsi/scsi 
>  
>
from drivers/scsi/scsi.c : (kernel 2.4.18)

	/*
	 * Usage: echo "scsi add-single-device 0 1 2 3" >/proc/scsi/scsi
	 * with  "0 1 2 3" replaced by your "Host Channel Id Lun".
	 * Consider this feature BETA.
	 *     CAUTION: This is not for hotplugging your peripherals. As
	 *     SCSI was not designed for this you could damage your
	 *     hardware !
	 * However perhaps it is legal to switch on an
	 * already connected device. It is perhaps not
	 * guaranteed this device doesn't corrupt an ongoing data transfer.
	 */

1.. What is meant by "SCSI was not designed for this ..." ?
2.. SCSI architecture model (SAM-2 at least) does not mention hot-plugging storage device into a running system ; but doing so is a very common task. So, are all the SCSI hot-plug systems in the world are based on proprietry methods of hot-plug ?
3.. What about the naming of /dev/sdxx naming of newly hot-plugged SCSI disk ? which name does it get ? (supposly I'm not using the dev filesystem)



