From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Dmesg of 2.6.17-rc4-mm3
Date: Tue, 30 May 2006 15:43:06 -0500
Message-ID: <1149021786.3545.13.camel@mulgrave.il.steeleye.com>
References: <BAY112-F143F3D9A825305B0A57787A0920@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:11210 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932402AbWE3UnL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 May 2006 16:43:11 -0400
In-Reply-To: <BAY112-F143F3D9A825305B0A57787A0920@phx.gbl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mun Hamlet <hamletmun@hotmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2006-05-30 at 11:53 -0300, Mun Hamlet wrote:
> Well, cat /sys/class/spi_host/host0/signalling says "unknown"

Are you sure the patch was applied?  It shouldn't have said unknown.

> 29160
> 50-pin = empty = empty = empty = empty =Yamaha CRW4260 = UltraPlextor = 
> Iomega ZIP (terminated)
> 68-pin LVD = empty = empty = Western Digital = empty = terminator

So this is a dual cable assembly ... I think the card is probably also
dual transciever.  It looks like there's some type of transceiver error
which is signalling LVD on a SE bus or vice versa.  What happens if you
pull the narrow cable off and boot (and also with the wide cable off).

James


