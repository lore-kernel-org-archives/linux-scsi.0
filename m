From: Ken Schneider <kschneider@bout-tyme.net>
Subject: new driver
Date: Sat, 14 Feb 2004 19:06:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200402141906.12087.kschneider@bout-tyme.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from user224.net1222.fl.sprint-hsd.net ([69.68.131.224]:24725 "EHLO
	pc1.bout-tyme.net") by vger.kernel.org with ESMTP id S263609AbUBOAGO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Feb 2004 19:06:14 -0500
Received: from localhost (localhost [127.0.0.1])
	by pc1.bout-tyme.net (Postfix) with ESMTP id 83E2CC7B079
	for <linux-scsi@vger.kernel.org>; Sat, 14 Feb 2004 19:06:13 -0500 (EST)
Received: from pc1.bout-tyme.net ([127.0.0.1])
 by localhost (pc1 [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 01207-02 for <linux-scsi@vger.kernel.org>;
 Sat, 14 Feb 2004 19:06:12 -0500 (EST)
Received: from linux1.bout-tyme.net (unknown [192.168.1.10])
	by pc1.bout-tyme.net (Postfix) with ESMTP id 7A6E5C6B073
	for <linux-scsi@vger.kernel.org>; Sat, 14 Feb 2004 19:06:12 -0500 (EST)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have been sent the sources for the LSI LOGIC, Inc. Ultra ATA100 IDE raid 
controller as found on the mainboard of the HP ML330 computer. I requested 
information concerning the inclusion of the code into the kernel tree and 
have been informed that the source is open and can be included as stated in 
all of the .c and .h files.
Example:

/*
 * Linux MegaRAID IDEal Software RAID Stack
 * Copyright (c) 2003 LSI Logic Corporation
 *-----------------------------------------------------------------------------
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *-----------------------------------------------------------------------------
 */

Having this code included will make the life of many people much easier in 
being able to use the raid function of the controller.

I have been able (with the help of people on the SuSE mailing list) to get the 
module compiled for the 2.4 kernel. As the 2.6 tree and compilation 
procedures have changed I can no longer get the module to compile, I am not a 
programmer as I know just enough about C to be dangerous.

Copies of the correspondence and the sources are available either from me or 
tech support at LSI Logic Corp. 

Any help in this matter would be appreciated. I am also willing to be a guinea 
pig for any testing of the module.

Ken Schneider

kschneider@bout-tyme.net

