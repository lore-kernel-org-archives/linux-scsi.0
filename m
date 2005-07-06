From: "Bhanu, Yogesh" <yogesh@gsf.de>
Subject: is there going to be aic7xxx driver update
Date: Wed, 6 Jul 2005 15:29:49 +0200
Message-ID: <0882D625EC1D3043B8F0C4C3C8F73451016FC286@ntmail.gsf.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta1.gsf.de ([146.107.3.111]:34978 "EHLO mta1.gsf.de")
	by vger.kernel.org with ESMTP id S261227AbVGGHm4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Jul 2005 03:42:56 -0400
Received: from sw-rz004.gsf.de (ntmail.gsf.de [146.107.8.104])
	by mta1.gsf.de (Postfix) with ESMTP id 8461053A4B
	for <linux-scsi@vger.kernel.org>; Thu,  7 Jul 2005 09:42:23 +0200 (CEST)
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi ,
     It is continuation to my last post regarding aic7xxx driver flaking load.
I really think this is a driver issue as I have switched several 39160 cards
all showing same result . 
I have seen adaptec has released newer drivers . But unfortunately the dont go
well with the latest 2.6 kernels has  anybody found a fix to the probelem .

I have tried 2.6.11.8, 2.6.11.10, 2.6.12, 2.6.12.2 kernel all return error
when I try to compile the adaptec driver .

This is the error message I get when I compile with 2.6.12.2 kernel. I have
replaced the original aic sources with the adaptec source.
There was a post from Martin Mokrejs last week that he had successfuly compiled the adaptec driver on 2.4.31. 

################
  CC [M]  drivers/scsi/aic7xxx/aic79xx_core.o
In file included from drivers/scsi/aic7xxx/aiclib.h:89,
                 from drivers/scsi/aic7xxx/aic79xx_osm.h:79,
                 from drivers/scsi/aic7xxx/aic79xx_core.c:44:
drivers/scsi/aic7xxx/cam.h:112: error: `SCSI_DATA_READ' undeclared here (not in a function)
drivers/scsi/aic7xxx/cam.h:112: error: enumerator value for `CAM_DIR_IN' not integer constant
drivers/scsi/aic7xxx/cam.h:113: error: `SCSI_DATA_WRITE' undeclared here (not in a function)
drivers/scsi/aic7xxx/cam.h:113: error: enumerator value for `CAM_DIR_OUT' not integer constant
drivers/scsi/aic7xxx/cam.h:115: error: `SCSI_DATA_NONE' undeclared here (not in a function)
drivers/scsi/aic7xxx/cam.h:115: error: enumerator value for `CAM_DIR_NONE' not integer constant
make[3]: *** [drivers/scsi/aic7xxx/aic79xx_core.o] Error 1
make[2]: *** [drivers/scsi/aic7xxx] Error 2
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2
############


Thanks
yogesh
