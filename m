From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Forcing use of sd driver on Suse 10.3 (2.6.22)
Date: Mon, 14 Jan 2008 19:31:42 +0100
Message-ID: <478BAA8E.7020703@s5r6.in-berlin.de>
References: <1200308514.4729.25.camel@desk.ty-rhos-barn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:37739 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbYANSct (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jan 2008 13:32:49 -0500
In-Reply-To: <1200308514.4729.25.camel@desk.ty-rhos-barn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bill Adair <adair@gotadsl.co.uk>
Cc: linux-scsi@vger.kernel.org

Bill Adair wrote:
> Is there any way under Linux of forcing use of the sd driver for a
> device on the bus instead of sg?

The INQUIRY data which the SCSI core gets from the device have to
indicate that the device implements SBC or RBC (is of peripheral device
type 00h or 0Eh).
-- 
Stefan Richter
-=====-==--- ---= -===-
http://arcgraph.de/sr/
