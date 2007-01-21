From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] sd: implement stop_on_shutdown
Date: Sun, 21 Jan 2007 23:47:46 +0100
Message-ID: <45B3ED92.9050807@s5r6.in-berlin.de>
References: <20070119170122.GS10987@htj.dyndns.org> <45B15575.5090806@torque.net> <45B18A12.5060605@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:47772 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbXAUWsH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Jan 2007 17:48:07 -0500
In-Reply-To: <45B18A12.5060605@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: dougg@torque.net, James.Bottomley@SteelEye.com, Jeff Garzik <jgarzik@pobox.com>, hmh@hmh.eng.br, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Tejun Heo wrote:
> This is just
> for small little machines running SATA and possibly USB disks (dunno
> their SAT implement START_STOP tho) which are currently having problems
> shutting down its disks on sleep to disk and sometimes poweroff.

It's also useful for FireWire HDDs. Those are basically all RBC disks
and should therefore support START_STOP_UNIT. It's also interesting in
the PM suspend case.
-- 
Stefan Richter
-=====-=-=== ---= =-=-=
http://arcgraph.de/sr/
