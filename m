From: Matt_Domsch@Dell.com
Subject: RE: [PATCH] SD_EXTRA_DEVS module option
Date: Thu, 25 Jul 2002 16:12:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <F44891A593A6DE4B99FDCB7CC537BBBBB8395F@AUSXMPS308.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> +MODULE_PARM_DESCRIPTION(sd_extra_devs, "Number of extra SCSI disks
allowed");

Of course, that's MODULE_PARM_DESC().
-Matt

--
Matt Domsch
Sr. Software Engineer, Lead Engineer, Architect
Dell Linux Solutions www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
#1 US Linux Server provider for 2001 and Q1/2002! (IDC May 2002)

