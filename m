From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Dmesg of 2.6.17-rc4-mm3
Date: Mon, 29 May 2006 19:31:37 -0500
Message-ID: <1148949097.3328.11.camel@mulgrave.il.steeleye.com>
References: <BAY112-F13079EF3266F937DEE82CAA09F0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:32386 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932096AbWE3Abk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 May 2006 20:31:40 -0400
In-Reply-To: <BAY112-F13079EF3266F937DEE82CAA09F0@phx.gbl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mun Hamlet <hamletmun@hotmail.com>
Cc: linux-scsi@vger.kernel.org

On Sat, 2006-05-27 at 20:23 -0300, Mun Hamlet wrote:
> It's me, again

This indicates that either the patch didn't work, or you have a split
bus topology.  How are these devices and CDs cabled up?  Also, what does

cat /sys/class/spi_host/host0/signalling

say?

James


