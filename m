From: Hartmut Manz <manz@intes.de>
Subject: Which U320 SCSI controler can be used on IA64 Systems
Date: Thu, 28 Aug 2003 09:08:44 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200308271505.53086.manz__11772.8748046376$1062054540@intes.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.permas.de ([195.143.204.226]:31156 "EHLO netserv.local")
	by vger.kernel.org with ESMTP id S263734AbTH1HIq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2003 03:08:46 -0400
Received: from hardy.local ([192.168.1.71] ident=manz)
	by netserv.local with esmtp (Exim 3.35 #1 (Debian))
	id 19sGth-00079G-00
	for <linux-scsi@vger.kernel.org>; Thu, 28 Aug 2003 09:08:45 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I need to extend an ITANIUM-2 system with a 4 way striped scratch file-system.
Now I am looking for working U320 SCSI controllers.

Could anyone tell me which SCSI controller is working on IA64.

My Idea was to use the ADAPTEC Controller 39320D with 
2 * 2 external Seagate 15K3 Disk and to use softraid.
Is this a good choice? 

The used operating system is RedHat AS2.1
Compiling a new kernel is no problem.

Thank You in advance

Hartmut
-- 
-----------------------------------------------------------------------------
Hartmut Manz                                      WWW:    http://www.intes.de
INTES GmbH                                        Phone:  +49-711-78499-29
Schulze-Delitzsch-Str. 16                         Fax:    +49-711-78499-10
D-70565 Stuttgart                                 E-mail: manz@intes.de
   Ein Mensch sieht, was vor Augen ist; der Herr aber sieht das Herz an.
------------------------------------------------------- 1. Samuel 16, 7 -----

