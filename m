From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] add transport class symlink to device object
Date: Tue, 16 Aug 2005 09:37:18 -0400
Message-ID: <4301EC0E.6090406@adaptec.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AD39@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:20427 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S965211AbVHPNhX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Aug 2005 09:37:23 -0400
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AD39@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: James.Bottomley@SteelEye.com, matthew@wil.cx, greg@kroah.com, akpm@osdl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, rmk@arm.linux.org.uk

On 08/15/05 20:52, James.Smart@Emulex.Com wrote:
> Actually, I view this as being a little odd...
> 
> What is "0000:00:04:0" in this case ? The "device" is not a serial
> port, which is what the ttyXX back link would lead you to believe.
> Thus, it's a serial port multiplexer that supports up to N ports,
> right ? and wouldn't the more correct representation have been to
> enumerate a device for each serial port ? (e.g. 0000:00:04.0/line0,
> 0000:00:04.0/line1, or similar)
> 
> Think if SCSI used this same style of representation. For example,
> if there was no scsi target device entity, but class entities did
> exist and they just pointed back to the scsi host device entry.
> 
> My vote is to make the multiplexor instantiate each serial line
> as a separate device.

Hi James,

Yes, you're absolutely and completely correct.  I think the same
way as you do.

	Luben

