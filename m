From: Steffen Winterfeldt <snwint@suse.de>
Subject: Re: SuSE hwinfo/yast2 still confusing SYM53C8XX, killing tape backups
Date: Mon, 22 Nov 2004 14:07:10 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411221406180.22230@ligeti.suse.de>
References: <1100467267.23710.7.camel@mulgrave> <4197E4B7.3050008@pobox.com>
 <1100473795.23649.26.camel@mulgrave> <m3hdnsvvfd.fsf@merlin.emma.line.org>
 <1100477105.24921.3.camel@mulgrave> <m34qjrx6iy.fsf_-_@merlin.emma.line.org>
 <Pine.LNX.4.61.0411221102280.22230@ligeti.suse.de> <41A1D64D.4030508@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ex.suse.de ([195.135.220.2]:56041 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S262081AbUKVNHQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Nov 2004 08:07:16 -0500
In-Reply-To: <41A1D64D.4030508@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 22 Nov 2004, Douglas Gilbert wrote:

> Steffen,
> I recently noticed that VPD page 0x80 (unit serial number)
> can be tricky to decode accurately. The reason is that many
> "SCSI" devices ignore the EVPD bit and return a
> standard INQUIRY response. Previously I simply checked
> that byte 1 (origin 0) of the response of a valid VPD
> page was its code, in this case: 0x80 .
> 
> The problem is that byte 1 of a standard INQUIRY response for
> a device with removable media is also 0x80 . So now I also
> retrieve the "supported VPD pages" page (0x0) and make
> sure it is well formed and indicates that VPD page 0x80 is
> supported.
> 
> In VPD pages 0x0 and 0x80 byte 2 of the reponse should be 0x0.
> Byte 2 in a standard INQUIRY response is only zero when the device
> claims no compliance with any SCSI standard. So that is
> another possible sanity check.

Thanks for the hint, Doug, I'll give it a try.


Steffen
