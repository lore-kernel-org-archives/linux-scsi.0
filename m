From: "Bhanu, Yogesh" <yogesh@gsf.de>
Subject: aic7xxx   slowness on 2.6.13
Date: Wed, 7 Sep 2005 13:15:55 +0200
Message-ID: <8306780C060A7D4790F8BA02CBA1B6910A9499@sw-rz010.gsf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta2.gsf.de ([146.107.4.111]:65452 "EHLO mta2.gsf.de")
	by vger.kernel.org with ESMTP id S932111AbVIGLQG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Sep 2005 07:16:06 -0400
Received: from sw-rz010.gsf.de (sw-rz010.gsf.de [146.107.8.106])
	by mta2.gsf.de (Postfix) with ESMTP id 4DA6D1465C0
	for <linux-scsi@vger.kernel.org>; Wed,  7 Sep 2005 13:15:55 +0200 (CEST)
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

hi ,
       I  installed 2.6.13 over the weekend  on a dual Pentium Xeon 2.4 Ghz with 6 GB RAM (My fileserver) running Debian Sarge.
My fileserver uses external infrotrend raid . 
 
On switching to 2.6.13 I also switched from my older slower Symbios 53c895   to Adaptec 3960D
 
I have noticed when using the adaptec card my file server performs slower than the Symbios 
card.
 
As an example I tried to copy my Mail folder of 66.8 M  and this is what I see .
 
with symbios 53c895 
 
bash-2.05$ time cp -pa Mail Mail.mips
real     0m6.048s
user    0m0.007s
sys     0m0.295s
 
 
with adaptec 3960D
bash-2.05$ time cp -pa Mail Mail.mips
real     0m49.543s
user    0m0.000s
sys     0m0.044s
 
 
I wonder anybody is experiencing this . 
 
Thanks
yogesh
