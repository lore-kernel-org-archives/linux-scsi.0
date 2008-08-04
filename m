From: castet.matthieu@free.fr
Subject: Re: [usb-storage] USB storage devices and SAT
Date: Mon, 04 Aug 2008 12:08:40 +0200
Message-ID: <1217844520.4896d52835e81@imp.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wmproxy1-g27.free.fr ([212.27.42.91]:27200 "EHLO
	wmproxy1-g27.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbYHDKOv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Aug 2008 06:14:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>

Hi,

Matthew Dharm wrote:
> Personally, I hate having to make dynamic decisions in usb-storage.  The
> more we try to do there, the more likely we are to get it wrong.
>
Did you see the patch I proposed at
http://marc.info/?l=linux-usb&m=121762869915609&w=2 ?

The idea is to keep a list of whitelist of device that support SAT.
The problem is we should add each new devices to this list (or hope vendor will
report SPC3 device).


Matthieu

