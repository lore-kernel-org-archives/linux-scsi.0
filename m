From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: how to handle QUEUE_FULL/SAM_STAT_TASK_SET_FULL in userspace?
Date: Thu, 15 Nov 2007 12:59:29 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D70B345BE@NAMAIL4.ad.lsil.com>
References: <473CA173.7080902@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:64685 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758529AbXKOT7t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Nov 2007 14:59:49 -0500
Content-class: urn:content-classes:message
In-Reply-To: <473CA173.7080902@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, Chris Friesen <cfriesen@nortel.com>
Cc: "Stephens, Larry" <Larry.Stephens@lsi.com>, linux-scsi@vger.kernel.org, dgilbert@interlog.com, James.Bottomley@SteelEye.com, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>

On  Thursday, November 15, 2007 12:44 PM, James Smart wrote:
> The midlayer doesn't do this automatically. The LLDD has to note the
> QUEUE_FULL/TASK_SET_FULL status, then call scsi_adjust_queue_depth()
> to manipulate things. And this gets really hairy to decrease 
> load, then
> ramp back up.
> 

yeah I need to do that, but the customer should do it via sysfs, as I
previously noted, he is on 2.6.14 kernel.
