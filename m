From: "christophe.varoqui" <christophe.varoqui@free.fr>
Subject: Transport Attributes -- attempt#2
Date: Fri, 9 Jan 2004 00:24:54 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200401090024.54952.christophe.varoqui@free.fr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp6.wanadoo.fr ([193.252.22.25]:46881 "EHLO
	mwinf0601.wanadoo.fr") by vger.kernel.org with ESMTP
	id S266365AbUAHXY5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2004 18:24:57 -0500
Received: from 192.168.1.2 (AAmiens-106-1-4-104.w80-11.abo.wanadoo.fr [80.11.231.104])
	by mwinf0601.wanadoo.fr (SMTP Server) with ESMTP id 53BED3400092
	for <linux-scsi@vger.kernel.org>; Fri,  9 Jan 2004 00:24:56 +0100 (CET)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

The current patch seems to present transport info only for scaned devices. 
Wouldn't it be interesting to present the raw port database too for FC 
transport ?

With a "one sysfs-file per port in the database" representation, hotplug 
events would be triggered upon changes on fabrics, and we could trigger 
rescans from userspace.

I was investigating adding direct helper calls in a FC HBA driver to try 
solving this auto-rescan-is-needed-here problem, but the sysfs approach seems 
cleaner ... isn't it ?

regards,
cvaroqui
