From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] scsi: netlink: avoid including netlink interface in scsi
 module
Date: Thu, 19 May 2011 21:06:59 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1105192105140.8008@frira.zrqbmnf.qr>
References: <1305753940-18570-1-git-send-email-jengelh@medozas.de> <20110518174857.77dbda09.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:39022 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933727Ab1ESTHB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 May 2011 15:07:01 -0400
In-Reply-To: <20110518174857.77dbda09.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

On Thursday 2011-05-19 02:48, Randy Dunlap wrote:

>On Wed, 18 May 2011 23:25:39 +0200 Jan Engelhardt wrote:
>
>> Only scsi_transport_fc needs it, so don't include it in scsi_mod
>> if fc=m.
>
>BTW, scsi_transport_iscsi.c also makes netlink calls (but it's missing the
>needed header files).

What, where?

>and what about pmcraid.c ?

I have both enabled, and the patch does not make any new warnings w.r.t. 
missing prototypes or otherwise pop up. So there does not seem to be 
anything missing.

>> Cc: Randy Dunlap <randy.dunlap@oracle.com>   // was not cc:ed

I had hoped git send-email would scan through the commit message, 
and add Ccs, apparently it did not.

