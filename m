From: Matt_Domsch@Dell.com
Subject: RE: [PATCH] SD_EXTRA_DEVS module option
Date: Sun, 28 Jul 2002 15:09:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <F44891A593A6DE4B99FDCB7CC537BBBBB83971@AUSXMPS308.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: berthiaume_wayne@emc.com
Cc: linux-scsi@vger.kernel.org

> 	Well in RH 7.1, lk 2.4.2, the option already exist under SCSI
> Support -> Maximum number of SCSI diasks that can be loaded 
> as modules. I
> haven't looked at a vanilla kernel so this may be a Red Hat addition.

Yes, but that is exactly the problem.  It's a compile time config option
(set to 40 by default, and kept that way in most distributions), which is
insufficient in the case of more than 40 disks (or 20 dual-pathed disks).
My patch was to make this a runtime configurable option that defaults to the
value of CONFIG_SD_EXTRA_DISKS, but which the user can override at module
load time.

Kurt Garloff of SuSE posted on Friday a set of patches targeted at 2.4.20pre
that extends this much further (see thread sd_many done right on
linux-kernel), and deletes CONFIG_SD_EXTRA_DISKS entirely, dynamically using
unassigned majors as needed.  I'll follow that patch progress.  If it
appears that won't make 2.4.x, then I'll see about submitting my simple
patch.

Thanks,
Matt

--
Matt Domsch
Sr. Software Engineer, Lead Engineer, Architect
Dell Linux Solutions www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
#1 US Linux Server provider for 2001 and Q1/2002! (IDC May 2002)

