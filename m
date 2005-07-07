From: Yogesh Bhanu <yogesh@gsf.de>
Subject: aic7xxx  driver issue..
Date: Thu, 07 Jul 2005 09:24:44 +0200
Message-ID: <42CCD8BC.7060804@gsf.de>
Reply-To: yogesh@gsf.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta2.gsf.de ([146.107.4.111]:52695 "EHLO mta2.gsf.de")
	by vger.kernel.org with ESMTP id S261226AbVGGHXw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2005 03:23:52 -0400
Received: from [146.107.217.179] (cavy.gsf.de [146.107.217.179])
	by mta2.gsf.de (Postfix) with ESMTP id 379CB53824
	for <linux-scsi@vger.kernel.org>; Thu,  7 Jul 2005 09:23:52 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi ,
      Probably this mail might be in duplicate as we are experiencing some mail 
troubles.
      It is in continuation to my last post regarding aic7xxx driver flaking 
load.I really think this is a driver issue as I have switched several 39160 
cards. all showing same result . I have not seen and/or received any further 
updates on the list . I have seen adaptec has newer drivers . But unfortunately 
they dont go well with the latest 2.6 kernels has  anybody found a fix to the 
problem .
It will be great if the adaptec and/or aic7xxx maintainers have a look into this.

I have tried 2.6.11.8, 2.6.11.10, 2.6.12, 2.6.12.2 kernel all return error
when I try to compile the adaptec driver .

This is the error message I get when I compile with 2.6.12.2 kernel. I have
replaced the original aic sources with the adaptec source.
There was a post from Martin Mokrejs last week that he had successfuly compiled 
the adaptec driver on 2.4.31.

################
   CC [M]  drivers/scsi/aic7xxx/aic79xx_core.o
In file included from drivers/scsi/aic7xxx/aiclib.h:89,
                  from drivers/scsi/aic7xxx/aic79xx_osm.h:79,
                  from drivers/scsi/aic7xxx/aic79xx_core.c:44:
drivers/scsi/aic7xxx/cam.h:112: error: `SCSI_DATA_READ' undeclared here (not in 
a function)
drivers/scsi/aic7xxx/cam.h:112: error: enumerator value for `CAM_DIR_IN' not 
integer constant
drivers/scsi/aic7xxx/cam.h:113: error: `SCSI_DATA_WRITE' undeclared here (not in 
a function)
drivers/scsi/aic7xxx/cam.h:113: error: enumerator value for `CAM_DIR_OUT' not 
integer constant
drivers/scsi/aic7xxx/cam.h:115: error: `SCSI_DATA_NONE' undeclared here (not in 
a function)
drivers/scsi/aic7xxx/cam.h:115: error: enumerator value for `CAM_DIR_NONE' not 
integer constant
make[3]: *** [drivers/scsi/aic7xxx/aic79xx_core.o] Error 1
make[2]: *** [drivers/scsi/aic7xxx] Error 2
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2
############


Thanks
yogesh
