From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: usage of max_sectors in scsi_host_template
Date: Wed, 07 Nov 2007 19:53:55 +0100
Message-ID: <473209C3.3080008@s5r6.in-berlin.de>
References: <47304E70.9090005@Voltaire.COM> <4730B359.8020806@s5r6.in-berlin.de> <4731CFE1.1070904@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:40693 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbXKGSx5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Nov 2007 13:53:57 -0500
In-Reply-To: <4731CFE1.1070904@Voltaire.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Erez Zilber <erezz@Voltaire.COM>
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

Erez Zilber wrote:
> I'm running sgp_dd (on RHAS 4 up4 - kernel version is 2.6.9), so it 
> calls scsi-ml directly (without going through ll_rw_blk).
...
> I guess that the max_sectors value is never used. Am I right?

I have no idea.  However you might be able to track how max_sectors
trickles through the layers via LXR:
http://lxr.free-electrons.com/ident?i=max_sectors
(Not all of the LXR sites out there support search for struct members
but free-electrons' does.)
-- 
Stefan Richter
-=====-=-=== =-== --===
http://arcgraph.de/sr/
