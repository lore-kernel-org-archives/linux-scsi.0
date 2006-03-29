From: Ingo Flaschberger <if@xip.at>
Subject: Compaq Fiber Channel Array RM4000 / Kernel implementation
Date: Wed, 29 Mar 2006 15:10:52 +0200 (CEST)
Message-ID: <Pine.GSO.4.64.0603291428590.4009@filebunker.xip.at>
References: <Pine.GSO.4.64.0602250050410.27649@filebunker.xip.at>
 <Pine.GSO.4.64.0602280120290.25994@filebunker.xip.at>
 <Pine.GSO.4.64.0602280130320.25994@filebunker.xip.at>
 <20060228004043.GH27759@parisc-linux.org> <Pine.GSO.4.64.0603221911370.14214@filebunker.xip.at>
 <yq1lkv2iap8.fsf@wilson.lab.mkp.net> <Pine.GSO.4.64.0603222054520.14214@filebunker.xip.at>
 <20060322200229.GT8980@parisc-linux.org> <Pine.GSO.4.64.0603222105560.14214@filebunker.xip.at>
 <Pine.GSO.4.64.0603282134370.8439@filebunker.xip.at> <yq18xqtain6.fsf@wilson.lab.mkp.net>
 <Pine.GSO.4.64.0603291305590.4009@filebunker.xip.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.xip.at ([193.239.188.99]:164 "EHLO chile.gbit.at")
	by vger.kernel.org with ESMTP id S1750728AbWC2NKy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 08:10:54 -0500
In-Reply-To: <Pine.GSO.4.64.0603291305590.4009@filebunker.xip.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello,

I have now got the RM4000 finally running.
Following things I changed in the kernel:
*) To find the devive:
 	Lun scan code in scsi_scan.c
 	Device special flags in scsi_devinfo.c
 	The final implementation could be easy done via the flags in the
 	scsi_devinfo.c file.

*) The RM4000 make troubles when trying to write more than 1023Kbytes in
 	one cdb.
 	I have changed sd.c to avoid this and only use 512Kbyte blocks as
 	maximum.
 	The final implementation is a little bit difficult because I need
 	some flags to detect the block size problem in sd.c, sd_init_command.
 	Should I build the changed into sd.c?

Kind regards,
 	ingo flaschberger

geschaeftsleitung
crossip communications gmbH
------------------------------------------------------------------_------------
sebastian kneipp gasse 1          _____ _____ ____   _____ _____ (_)____
a-1020 wien                      / ___// ___// __ \ / ___// ___// // __ \
fix: +43-1-726 15 22-217        / /__ / /   / /_/ /(__  )(__  )/ // /_/ /
fax: +43-1-726 15 22-111        \___//_/    \____//____//____//_// .___/
mob: +43-699-105 86 719                                 _______ / /
www.xip.at                      communications gmbh    /______//_/
-------------------------------------------------------------------------------
