From: Joern Quillmann <q-man@gmx.de>
Subject: Re: Spinup of SCSI Disks: allow_restart won't work on 2.6.18
Date: Fri, 17 Nov 2006 22:44:36 +0100
Message-ID: <455E2D44.5030903@gmx.de>
References: <455DF39A.6090209@fbihome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.188]:20449 "EHLO
	moutng.kundenserver.de") by vger.kernel.org with ESMTP
	id S1755951AbWKQVq5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Nov 2006 16:46:57 -0500
Received: from [192.168.1.30]
	by eis.satan.lan with esmtpa (Exim 4.60)
	(envelope-from <q-man@gmx.de>)
	id 1GlDQ5-0000Gh-2Z
	for linux-scsi@vger.kernel.org; Fri, 17 Nov 2006 23:46:54 +0000
In-Reply-To: <455DF39A.6090209@fbihome.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Joern Quillman wrote:

> I have now the allow_restart entry in sysfs.
> It's set to 0 in my machine and it won't let me change it with 'echo 1 > 
> allow_restart' or echo -n. I always get a write error.

I just bought an external USB->IDE converter and tested it again.
Of course due to the cheap concerter-chip the USB disk wont go to 
standby mode but I can set 'allow_restart' to 1 with this converter.

So maybe it's only about sbp2 implementation or specifically my OXFW911 
bridges?


Thanks

Joern
