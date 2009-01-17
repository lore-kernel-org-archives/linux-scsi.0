From: fangxiaozhi 00110321 <huananhu@huawei.com>
Subject: Can not send SCSI command to the cdrom device.
Date: Sat, 17 Jan 2009 17:02:54 +0800
Message-ID: <face93d65cecd.5cecdface93d6@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:33519 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235AbZAQJH5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Jan 2009 04:07:57 -0500
Received: from huawei.com (szxga03-in [172.24.2.9])
 by szxga03-in.huawei.com (iPlanet Messaging Server 5.2 HotFix 2.14 (built Aug
 8 2006)) with ESMTP id <0KDL00KW4YGU4W@szxga03-in.huawei.com> for
 linux-scsi@vger.kernel.org; Sat, 17 Jan 2009 17:02:55 +0800 (CST)
Received: from huawei.com ([172.17.1.31])
 by szxga03-in.huawei.com (iPlanet Messaging Server 5.2 HotFix 2.14 (built Aug
 8 2006)) with ESMTP id <0KDL005EDYGUCT@szxga03-in.huawei.com> for
 linux-scsi@vger.kernel.org; Sat, 17 Jan 2009 17:02:54 +0800 (CST)
Content-language: zh-CN
Content-disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dear all:
 
  I have a CDROM device, and after I plug it into the Linux system, the Linux system will generate three device files in the directory of /dev/, such as:
  scd1: block special (11/0)
  sr1:  link to scd1
  sg1: character special(21/1)
 
  And I write a c program to send the SCSI command of SPACE to my CDROM device. Such as :
 
   fd = open("/dev/sg1", 0_RDWR);
   ioctl(fd, SCSI_IOCTL_SEND_COMMAND, cmdbuff);
 
  And I found that I can send the SPACE command to my CDROM device, if I open the file of /dev/sg1.
  But if I open the file of /dev/scd1, then I can not send the SPACE command to my CDROM device.
 
   Why I can not send SCSI command through /dev/scd1 ?
 
   What difference between /dev/sg1 and /dev/scd1 ?
 
   And how can I send send the command through /dev/scd1?
 
   Wait for the help, thanks.
 
Best Regards,
 
Franko Fang
2009-1-17


******************************************************************************************
 This email and its attachments contain confidential information from HUAWEI, which is intended only for the person or entity whose address is listed above. Any use of the information contained here in any way (including, but not limited to, total or partial disclosure, reproduction, or dissemination) by persons other than the intended recipient(s) is prohibited. If you receive this email in error, please notify the sender by phone or email
 immediately and delete it!
 *****************************************************************************************
