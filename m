From: "werner" <w.landgraf@ru.ru>
Subject: 2.6.39-rc3-git3 problem
Date: Thu, 14 Apr 2011 18:07:56 -0400
Message-ID: <web-505236688@zbackend1.aha.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zfrontend2.aha.ru ([195.2.83.148]:55809 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754160Ab1DNXIE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Apr 2011 19:08:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, gregkh@suse.de, mingo@elte.hu, tj@kernel.org, randy.dunlap@oracle.com, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>

The problem occurs since 2.6.39-rc1 . I reported it at 
that time, but the kernel mailing list very likely put my 
e-mail on spam so that it didn't appear. In another 
reclamation, by a mistake, I wrote 2.6.36-rc1 rather than 
2.6.39-rc1 .

If one starts the computer with text mode, then it crashs 
also, but after very long time, appr. 20-40 min after 
booting.

I on my server / main computer using the fbdev driver, for 
testing out this problem also vesa.   With both it crashs 
short after starting X .

One time when I started it on a laptop, then during the 
boot time, text mode, if the screen switchs to another 
text mode, then the text became very small, 1 cm, on the 
top of the screen, several times side-on-side, so that one 
couldnt read it.  Then I waited and logged in, then I 
started startx  (normally, it goes in grafic mode 
automatically, but at that time not).  Then the grafic 
started normally, but after some 2 min. it crashed.

If the crash occurs in the grafic mode, then it switches 
instantly to the text screen, and the error message is 
visible in text-mode, as visible in the foto.

I started the computer after a crash from an USB key, for 
not overwrite dmesg. But, in none of the message files is 
any message related to the crash.

In  order not to overwrite old dmesg files, it should be 
programmed into the kernel, that dmesg get any suffix, for 
example a random number, or date-time.

I hope that informations are helpful to fix this.

If someone fix it, then it can send to me as a normal 
patch, with the kernel number, and any git number (like 
the normal git files / kernel gits), because then I can 
apply the patch and compile the kernel with my normal 
kernel-compiling script.

W.Landgraf

Linux SYS
---
Professional hosting for everyone - http://www.host.ru
