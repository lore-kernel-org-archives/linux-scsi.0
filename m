From: Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: Re: 2.6.6-rc2-mm2 + Adaptec I2O
Date: Wed, 28 Apr 2004 19:13:39 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <408FE643.8000608@shadowconnect.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.133.118.2] ([213.133.118.2]:17117 "EHLO
	mail.shadowconnect.com") by vger.kernel.org with ESMTP
	id S264983AbUD1RKL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Apr 2004 13:10:11 -0400
Received: from p50807ae1.dip.t-dialin.net ([80.128.122.225] helo=shadowconnect.com)
	by mail.shadowconnect.com with asmtp (TLSv1:AES256-SHA:256)
	(Exim 4.21)
	id 1BIsZU-00067t-TP
	for linux-scsi@vger.kernel.org; Wed, 28 Apr 2004 19:10:09 +0200
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello,

i don't know if you already know, but there is a own I2O subsystem, 
which is working in 2.6 on 32-bit and 64-bit systems. At the moment, i 
still try to get the patches into the main 2.6 kernel, but it would help 
me very much, if you could give it a try. All patches you need, could be 
downloaded from http://i2o.shadowconnect.com/.

Please note, that because the I2O subsystem does not depend on SCSI, 
your devices will be called /dev/i2o/hda, /dev/i2o/hdb, ...

A short description and FAQ section is also on the site.

And if you still have problems, i would be glad, if you could contact 
me. I'll try my best to help you. Even it works, there is still one 
point (expect getting the patches into the kernel) on the ToDo list:

- Add Adaptec's specific 64-bit SG support

A complete list of things to be done (not kernel related) is on the site 
too.

If you have further suggestions/comments please feel free to contact me.


Thank you very much, for giving it a try.


Best regards,


Markus Lidel
------------------------------------------
Markus Lidel (Senior IT Consultant)

Shadow Connect GmbH
Carl-Reisch-Weg 12
D-86381 Krumbach
Germany

Phone:  +49 82 82/99 51-0
Fax:    +49 82 82/99 51-11

E-Mail: Markus.Lidel@shadowconnect.com
URL:    http://www.shadowconnect.com

