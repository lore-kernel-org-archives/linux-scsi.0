From: Manu <nobody@guzu.net>
Subject: Re: [BUG] Fusion MPT 2.6.8 driver and multi LUN device
Date: Tue, 01 Mar 2005 14:04:25 +0100
Message-ID: <42246859.8090006@guzu.net>
References: <42243E15.5070502@guzu.net> <4224484D.5090900@torque.net>
Reply-To: linux-kernel@guzu.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Received: from 26.mail-out.ovh.net ([213.186.42.179]:34225 "EHLO
	26.mail-out.ovh.net") by vger.kernel.org with ESMTP id S261892AbVCANEf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 08:04:35 -0500
In-Reply-To: <4224484D.5090900@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dougg@torque.net

Douglas Gilbert wrote:
> 
> Perhaps you could try the sg_luns utility from the
> sg3_utils package ( http://www.torque.net/sg )
> with either the 2.4 or 2.6 kernel. It should be sent
> to lun 0 (i.e. the tape drive), for example:
>   sg_luns /dev/st0
> 
> [I'm not sure whether st devices support the SG_IO
> ioctl in lk 2.6.8; they do now. If that fails use the
> sg_map utility to find the corresponding sg device and
> apply sg_luns to that sg device.]

It doesn't work with /dev/st0 or /dev/nst0 but either work with /dev/sg1 
and /dev/sg2 which are respectively the drive and the changer. But it 
reports the same things that I reported.

> If the sg_luns response shows an offset result for the
> tape changer (lun 1), then you should be looking to see
> if HP has new firmware for that tape autoloader.

OK.
I tried to force the kernel to register the LUN 1 (by modifying the 
scsi_scan.c code) but the kernel crashes...

See you.
