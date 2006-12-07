From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: lsscsi version 0.19 beta
Date: Thu, 07 Dec 2006 08:52:34 +0100
Message-ID: <4577C842.80203@s5r6.in-berlin.de>
References: <4577B06D.6060701@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:44246 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031813AbWLGHwg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Dec 2006 02:52:36 -0500
In-Reply-To: <4577B06D.6060701@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> So this beta adds transport information, both target
> and initiator (host) for these transports:
>   - FC
>   - SAS
> 
> I hope to add iSCSI if I can find a way through its maze.
> Perhaps USB and 1394 are candidates as well, even SPI.

In case you find the ieee1394/sbp2 transport insufficiently integrated,
please point it out. I'd try to implement what's missing as spare time
permits and as far as it doesn't add excessive baggage.
-- 
Stefan Richter
-=====-=-==- ==-- --===
http://arcgraph.de/sr/
