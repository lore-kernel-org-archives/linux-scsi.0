From: Matt_Domsch@Dell.com
Subject: Re: Cannot get device recognized on a megaraid
Date: Mon, 24 Nov 2003 17:21:51 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069716110.4123.382.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausadmmsrr502.aus.amer.dell.com ([143.166.83.89]:52238 "HELO
	AUSADMMSRR502.aus.amer.dell.com") by vger.kernel.org with SMTP
	id S261602AbTKXXWT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2003 18:22:19 -0500
List-Id: linux-scsi@vger.kernel.org
To: micah@riseup.net
Cc: linux-scsi@vger.kernel.org

> I've been fighting a megaraid card with one device, just trying to get
> it recognized. The card has the latest bios, the drive is in a RAID 0
> container.
>
> > What is the card type please?  What does lspci -vv and lspci -vvn
> > show for it?
> 
> I need to look up what the card type is, but until then...


00:11.0 RAID bus controller: CMD Technology Inc: Unknown device 0680 (rev
02)
        Subsystem: LSI Logic / Symbios Logic (formerly NCR): Unknown device
0524
00:11.0 Class 0104: 1095:0680 (rev 02)
        Subsystem: 1000:0524

OK, best as I know, this isn't a card that 'megaraid' supports.  More
likely 'megaide'.

http://www.lsilogic.com/techlib/techdocs/storage_stand_prod/RAIDpage/
may have docs you're looking for.


-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

