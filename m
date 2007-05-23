From: "jidong xiao" <jidong.xiao@gmail.com>
Subject: [Stgt-devel] Question about the basic concept of SCSI layer and Block layer
Date: Wed, 23 May 2007 21:55:09 +0800
Message-ID: <4104961b0705230655j32ae30f9p78b7f7d906a92a92@mail.gmail.com>
References: <4104961b0705230653y26d0f6f9k92c56d6d913b5d8f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:30386 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbXEWNzL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 May 2007 09:55:11 -0400
Received: by ug-out-1314.google.com with SMTP id j3so523805ugf
        for <linux-scsi@vger.kernel.org>; Wed, 23 May 2007 06:55:10 -0700 (PDT)
In-Reply-To: <4104961b0705230653y26d0f6f9k92c56d6d913b5d8f@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stgt-devel@lists.berlios.de, scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org

Hi,All,
  I have a question, what's the relationship between SCSI layer and
Block layer?I remember initially there are three types of device
drivers, say, char device driver, block device driver, network device
driver, so there is a directory "drivers/block",but recent years,most
part of the code for block devices have been moved out of the
directory drivers/block, but there is still a block I/O layer, so I am
wondering what's the relationship between Block layer and other
subsystem, like how to connect block layer and filesystem(VFS or the
actually file system), how to bridge it with scsi layer, for example,
the scsi disk driver, sd.o. Who can please kindly explain this for me,
thank you very much!

Best Regards
Jason
