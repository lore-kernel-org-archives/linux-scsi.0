From: Sebastian Just <zeeman@gmx.net>
Subject: Problem: DC390/AM53/79C974 can't compile
Date: Sun, 24 Aug 2003 12:02:53 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F488D4D.4090804@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:11403 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S265920AbTHXKCu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Aug 2003 06:02:50 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi!

I tried the kernel 2.6test3 and 2.6test4.

I can configure both and compile them without problems.

But if I try to add scsi-controller-support for the Tekram DC390 or the 
  AM53/79C974 I can't compile the kernel.
There is no difference between compiling the scsi-card-support as modul 
or direct into the kernel.
Alwasy it stops with
drivers/scsi/tmscsim.c: In function `dc390_Query_append':
drivers/scsi/tmscsim.c:872: structure has no member named `next'
drivers/scsi/tmscsim.c:877: structure has no member named `next'
drivers/scsi/tmscsim.c: In function `dc390_Query_get':
drivers/scsi/tmscsim.c:889: structure has no member named `next'
drivers/scsi/tmscsim.c:890: structure has no member named `next'
[...]
drivers/scsi/tmscsim.c: In function `DC390_proc_info':
drivers/scsi/tmscsim.c:2935: structure has no member named `next'
drivers/scsi/tmscsim.c: At top level:
drivers/scsi/tmscsim.c:3060: `DC390_T' undeclared here (not in a function)
drivers/scsi/tmscsim.c:3061: syntax error before '.' token
drivers/scsi/tmscsim.c:277: warning: `tmscsim_pci_tbl' defined but not used
make[2]: *** [drivers/scsi/tmscsim.o] Error 1
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2

Is there a way to get the kernel working?

I use at the moment Debian Woody 3.0rc1, GCC 3.2.3 and the kernel 2.4.21


Greetings
Sebastian

