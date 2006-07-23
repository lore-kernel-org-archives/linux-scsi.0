From: David Miller <davem@davemloft.net>
Subject: Fw: Compile ESP
Date: Sun, 23 Jul 2006 01:08:41 -0700 (PDT)
Message-ID: <20060723.010841.28789139.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Sun_Jul_23_01_08_41_2006_184)--"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl027-180-168.sfo1.dsl.speakeasy.net ([216.27.180.168]:55001
	"EHLO sunset.davemloft.net") by vger.kernel.org with ESMTP
	id S1750748AbWGWIIq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Jul 2006 04:08:46 -0400
Received: from localhost (localhost [127.0.0.1])
	by sunset.davemloft.net (Postfix) with ESMTP id 126FBAE40CA
	for <linux-scsi@vger.kernel.org>; Sun, 23 Jul 2006 01:08:42 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

----Next_Part(Sun_Jul_23_01_08_41_2006_184)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Can one of the scsi folks please look into this recently
introduced build regression?  Thanks a lot.

NCR53C9x.c has a reference to the ->data_cmnd[] member as well
so would need a similar fix.

Thanks again.

----Next_Part(Sun_Jul_23_01_08_41_2006_184)--
Content-Type: Message/Rfc822
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Return-Path: <sparclinux-owner@vger.kernel.org>
X-Original-To: davem@davemloft.net
Delivered-To: davem@davemloft.net
Received: from vger.kernel.org (vger.kernel.org [209.132.176.167])
	by sunset.davemloft.net (Postfix) with ESMTP id A97A5AE40CA
	for <davem@davemloft.net>; Sun, 23 Jul 2006 01:02:35 -0700 (PDT)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751102AbWGWICP (ORCPT <rfc822;davem@davemloft.net>);
	Sun, 23 Jul 2006 04:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbWGWICO
	(ORCPT <rfc822;sparclinux-outgoing>);
	Sun, 23 Jul 2006 04:02:14 -0400
Received: from mail3.panix.com ([166.84.1.74]:26854 "EHLO mail3.panix.com")
	by vger.kernel.org with ESMTP id S1750888AbWGWICM (ORCPT
	<rfc822;sparclinux@vger.kernel.org>);
	Sun, 23 Jul 2006 04:02:12 -0400
Received: from mailspool2.panix.com (mailspool2.panix.com [166.84.1.79])
	by mail3.panix.com (Postfix) with ESMTP id 0B4D613A813
	for <sparclinux@vger.kernel.org>; Sun, 23 Jul 2006 04:02:12 -0400 (EDT)
Received: from [10.66.66.6] (barney.iacookie.net [216.254.117.142])
	by mailspool2.panix.com (Postfix) with ESMTP id C8B57F73E21
	for <sparclinux@vger.kernel.org>; Sun, 23 Jul 2006 04:02:11 -0400 (EDT)
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <EC625B79-6F87-41C4-835E-5EF2E80B7684@iacookie.net>
Content-Transfer-Encoding: 7bit
From: cookie <cookie@iacookie.net>
Subject: Compile ESP
Date: Sun, 23 Jul 2006 04:02:10 -0400
To: sparclinux@vger.kernel.org
X-Mailer: Apple Mail (2.752.2)
Sender: sparclinux-owner@vger.kernel.org
Precedence: bulk
X-Mailing-List: sparclinux@vger.kernel.org

Hello-
   I have noticed that since late 2.6.17 that I was unable to
compile ESP on my U2.  Its running Aurora Linux 2.0.  I have
not seen anyone else mention this, can someone give me a suggestion
on what I may have done wrong?  This is the verbose output from
2.6.18-rc2-git1
   Thanks
Brian


make -f scripts/Makefile.build obj=drivers/scsi
   gcc -Wp,-MD,drivers/scsi/.esp.o.d  -nostdinc -isystem /usr/lib/gcc/ 
sparc64-redhat-linux/3.4.2/include -D__KERNEL__ -Iinclude  -include  
include/linux/autoconf.h -Wall -Wundef -Wstrict-prototypes -Wno- 
trigraphs -fno-strict-aliasing -fno-common  -O2 -fomit-frame-pointer - 
m64 -pipe -mno-fpu -mcpu=ultrasparc -mcmodel=medlow -ffixed-g4 - 
ffixed-g5 -fcall-used-g7 -Wno-sign-compare -Wa,--undeclared-regs - 
Wdeclaration-after-statement     -D"KBUILD_STR(s)=#s" - 
D"KBUILD_BASENAME=KBUILD_STR(esp)"  -D"KBUILD_MODNAME=KBUILD_STR 
(esp)" -c -o drivers/scsi/esp.o drivers/scsi/esp.c
drivers/scsi/esp.c: In function `esp_should_clear_sync':
drivers/scsi/esp.c:2758: error: structure has no member named  
`data_cmnd'
make[2]: *** [drivers/scsi/esp.o] Error 1
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2



-
To unsubscribe from this list: send the line "unsubscribe sparclinux" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

----Next_Part(Sun_Jul_23_01_08_41_2006_184)----
