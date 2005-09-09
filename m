From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/5] SCSI scanning and removal fixes
Date: Fri, 09 Sep 2005 19:08:32 +0200
Message-ID: <4321C190.8090106@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0509081330530.5768-100000@iolanthe.rowland.org> <4320D066.5090806@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:55006 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1030258AbVIIRJS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Sep 2005 13:09:18 -0400
In-Reply-To: <4320D066.5090806@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, Alan Stern <stern@rowland.harvard.edu>

Luben Tuikov wrote:
> Think about this:
> 	EH is function of scsi_host.

The host does not use the EH. The EH uses the host.

> 	You can define YOUR OWN EH! in usb storage, which you control!

There are a few hotpluggable low-level providers besides usb-storage.
-- 
Stefan Richter
-=====-=-=-= =--= -=--=
http://arcgraph.de/sr/
