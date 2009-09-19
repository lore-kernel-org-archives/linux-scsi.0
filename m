From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Queue depth adjustments to scsi-ml
Date: Fri, 18 Sep 2009 17:11:33 -0700
Message-ID: <B221F493-51BD-41D6-9F95-99EA7EFF8D5F@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v912)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:45129 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbZISALa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Sep 2009 20:11:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vasu.dev@intel.com
Cc: Mike Christie <michaelc@cs.wisc.edu>, Andrew Vasquez <andrew.vasquez@qlogic.com>, LinuxSCSI <linux-scsi@vger.kernel.org>

Hi Vasu Dev,

I am trying to apply your patches to test the recent scsi queue depth  
changes on qla2xxx driver. I see two set of patches submitted on   
2009-08-26 and 2009-09-03 at http://marc.info/?l=linux-scsi&w=2&r=1&s=vasu+dev&q=b

I tried to apply the recent patches ( submitted on 2009-09-03 - 10  
patches) and it fails.

Do I need to pick both sets of patches. In first set of patches I am  
seeing some of the patches missing ( 1/9, 2/9, 3/9).
Can u please let me know which patches need to be picked up for  
testing the changes.

Thanks,
Giridhar Malavali

  24. 2009-09-03  [PATCH 08/10]  
fcoe,                                   linux-scs Vasu Dev
  25. 2009-09-03  [PATCH 10/10] zfcp: Adapt change_queue_depth for  
queu linux-scs Vasu Dev
  26. 2009-09-03  [PATCH 09/10] libfc: adds queue_depth ramp up to  
libf linux-scs Vasu Dev
  27. 2009-09-03  [PATCH 07/10] scsi: add common queue_depth ramp up  
co linux-scs Vasu Dev
  28. 2009-09-03  [PATCH 05/10] scsi: updates sdev to add queue_depth  
r linux-scs Vasu Dev
  29. 2009-09-03  [PATCH 06/10] scsi: adds sdev->queue_ramp_up_period  
t linux-scs Vasu Dev
  30. 2009-09-03  [PATCH 04/10] drivers: convert fc drivers  
calling     linux-scs Vasu Dev
  31. 2009-09-03  [PATCH 03/10] drivers: convert drivers setting the  
ch linux-scs Vasu Dev
  32. 2009-09-03  [PATCH 02/10] scsi error: have scsi-ml call  
change_qu linux-scs Vasu Dev
  33. 2009-09-03  [PATCH 01/10] scsi-ml: modify change_queue_depth to  
t linux-scs Vasu Dev
  34. 2009-09-03  [PATCH 00/10] handles queue_depth adjustments in  
scsi linux-scs Vasu Dev

_____

  49. 2009-08-26  [RFC PATCH 6/9] scsi: adds sdev- 
 >queue_ramp_up_period linux-scs Vasu Dev
  50. 2009-08-26  [RFC PATCH 9/9] libfc: adds queue_depth ramp up to  
li linux-scs Vasu Dev
  51. 2009-08-26  [RFC PATCH 8/9]  
fcoe,                                 linux-scs Vasu Dev
  52. 2009-08-26  [RFC PATCH 7/9] scsi: add common queue_depth ramp  
up  linux-scs Vasu Dev
  53. 2009-08-26  [RFC PATCH 5/9] scsi: updates sdev to add  
queue_depth linux-scs Vasu Dev
  54. 2009-08-26  [RFC PATCH 4/9] drivers: convert fc drivers  
calling   linux-scs Vasu Dev
  55. 2009-08-26  [RFC PATCH 0/9] RFC: handle queue_depth adjustments  
b linux-scs Vasu Dev

