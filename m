From: Ingo Flaschberger <if@xip.at>
Subject: Compaq Fiber Channel Array RM4000 / Scsi middle ware driver
Date: Sat, 25 Feb 2006 00:55:50 +0100 (CET)
Message-ID: <Pine.GSO.4.64.0602250050410.27649@filebunker.xip.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.xip.at ([193.239.188.99]:61366 "EHLO chile.gbit.at")
	by vger.kernel.org with ESMTP id S964806AbWBXXzx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Feb 2006 18:55:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello,

I would like to implement the "black magic" from the cpqfc driver for the 
RM4x00 arrays into a seperate module for the 2.6 series kernel.

As far as I know, there should be written a middleware because of the raid 
disk type and the lun numbers.

Because thats my first kernel project and I'm not shure how and where into 
the scsi framework this should be implemented, I as for some 
guide/hints/whatever; and yes, I'm able to code and understand C.

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
