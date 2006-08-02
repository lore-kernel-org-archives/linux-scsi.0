From: Kris Vassallo <kris@linuxcertified.com>
Subject: raidutils problem with i2o + 2.6.17
Date: Wed, 02 Aug 2006 13:35:57 -0700
Message-ID: <1154550958.3519.119.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp103.sbc.mail.mud.yahoo.com ([68.142.198.202]:60029 "HELO
	smtp103.sbc.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1751306AbWHBUgC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Aug 2006 16:36:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Not sure if this is where I need to post this question since it also has
to deal with the raidutils apps so if its not I'd appreciate a shove in
the right direction. 

I'm running a 2.6.17-1.2157_FC5 kernel with the raidutils 0.6 tools
installed. I'm using an Adaptec 2015S RAID controller. I manually
modprobed the i2o_config modules (block and core are already loaded) and
then ran a raidutils -L which gives me the following:
Engine connect failed: COMPATIBILITY number
osdIOrequest : File /dev/dpti17 Could Not Be Opened

I read somewhere about there needing to be a /dev/i20/ctl device. I
don't have this, what I do have is a /dev/i2octl device. I tried
symlinking /dev/i2octl to /dev/i2o/ctl and then ran raidutils again and
I then get back: 
FailureInvalid list type
for which I can find nothing on google for. 

Any ideas on how I can get this up and running? 

Thanks, 
Kris

