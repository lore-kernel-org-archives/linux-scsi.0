From: "c.hota" <cghota@mail.midsouth.ualr.edu>
Subject: Problem on Dell PE2650/aacraid
Date: Mon, 02 Aug 2004 08:56:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <410E4802.1090707@midsouth.ualr.edu>
Reply-To: cghota@mail.midsouth.ualr.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.ualr.edu ([144.167.10.21]:61645 "EHLO mail.ualr.edu")
	by vger.kernel.org with ESMTP id S266538AbUHBN4y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2004 09:56:54 -0400
Received: from mfilter1.ualr.edu (mfilter.ualr.edu [144.167.10.248])
 by mail.ualr.edu (iPlanet Messaging Server 5.2 Patch 1 (built Aug 19 2002))
 with ESMTP id <0I1T00FCBO2R85@mail.ualr.edu> for linux-scsi@vger.kernel.org;
 Mon, 02 Aug 2004 08:56:51 -0500 (CDT)
Received: from [144.167.14.19] (helo=mail.midsouth.ualr.edu)
	by mfilter1.ualr.edu with esmtp (Exim 4.34)
	id 1BrdI8-0002f2-LA	for linux-scsi@vger.kernel.org; Mon,
 02 Aug 2004 08:55:52 -0500
Received: from [144.167.14.88] by mail.midsouth.ualr.edu
 (iPlanet Messaging Server 5.2 HotFix 1.21 (built Sep  8 2003))
 with ESMTP id <0I1T00AWSNOI2P@mail.midsouth.ualr.edu> for
 linux-scsi@vger.kernel.org; Mon, 02 Aug 2004 08:48:18 -0500 (CDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all-

Just built a (gentoo 2004.2) 2.4.27 kernel on a Dell PowerEdge 2650 
(with PERC 3/di) using aacraid.  Upon boot, I'm getting the following 
message:

Loading Adaptec I20 RAID: Version 2.4 Build 5
Detecting Adaptec I20 RAID controllers...
Re Hat/Adaptec aacraid driver (1.1-3 Jul 31 2004 19:50:19)
AAC0: kernel 2.7.4 build 3170
AAC0: monitor 2.7.4 build 3170
AAC0: bios 2.7.4 build 3170
AAC0: serial 7bd881d3fafaf001
scsi0: percraid

And then the system just stops...

I'm pretty new to all this, so I'm not sure what to do.  Any ideas?  I 
looked through the linux-aacraid-devl list archives, and couldn't find 
anyone with the same problem; and it said to go to this list.

Thanks,

Chris

---

Chris Hota
cghota@midsouth.ualr.edu
(501)683-7339 desk
(501)413-1176 cell
http://www.midsouth.ualr.edu/
