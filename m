From: Yathindra <ydev@cs.utah.edu>
Subject: Simulating faulty disk
Date: Wed, 19 Oct 2011 21:18:57 -0600
Message-ID: <4E9F9321.8090704@cs.utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rio.cs.utah.edu ([155.98.64.241]:50257 "EHLO
	mail-svr1.cs.utah.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab1JTD0e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Oct 2011 23:26:34 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail-svr1.cs.utah.edu (Postfix) with ESMTP id 4EB03650123
	for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2011 21:19:02 -0600 (MDT)
Received: from mail-svr1.cs.utah.edu ([127.0.0.1])
	by localhost (mail-svr1.cs.utah.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DRhyTbaRlDyW for <linux-scsi@vger.kernel.org>;
	Wed, 19 Oct 2011 21:19:02 -0600 (MDT)
Received: from [192.168.1.30] (c-98-202-218-229.hsd1.ut.comcast.net [98.202.218.229])
	by smtps.cs.utah.edu (Postfix) with ESMTPSA id C8BDF650115
	for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2011 21:19:01 -0600 (MDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I'm trying to simulate a faulty disk behavior on linux. Basically, I 
want to inject various disk failure patterns
such as medium errors, unresponsive disk etc.

What is the best way to go about it. I heard about scsi_debug driver but 
it can only simulate medium
errors on fixed sector 0x1234. Also, scsi fault injection using 
Systemtap seems to be a user space tool
limited to files.

Any suggestions is greatly appreciated.

Thanks,
Yathi
