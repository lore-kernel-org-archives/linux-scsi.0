From: Tom Winkler <tom@qwws.net> (by way of Tom Winkler <tom@qwws.net>)
Subject: SCSI regression: sym53c8xxx_2 (2.6test11 vs. 2.6final)
Date: Fri, 19 Dec 2003 09:23:57 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200312190923.57405.tom@qwws.net>
Reply-To: tom@qwws.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailrelay.tu-graz.ac.at ([129.27.3.7]:7917 "EHLO
	mailrelay01.tugraz.at") by vger.kernel.org with ESMTP
	id S262063AbTLSIYE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Dec 2003 03:24:04 -0500
Received: from thunder (tlink.wnk.at [81.223.23.200])
	(authenticated bits=0)
	by mailrelay01.tugraz.at (8.12.10/8.12.10) with ESMTP id hBJ8O0VP006942
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2003 09:24:01 +0100 (CET)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

First of all: I'm not subscribed to the list so please cc me on replies.

I wanted to report a problem concerning 2.6.0 final with my Tekram DC390U2W
SCSI controller using the sym53c8xx_2 driver. The same machine was running
without problems with 2.6test11 and the exactly same .config file.

Booting 2.6.0 final results in the following messages:

[...]
sym0: <895> rev 0x1 at pci 0000:02:0a.0 irq 22
sym0: Tekram NVRAM, ID 7, Fast-40, LVD, parity checking
sym0: SCSI BUS has been reset.
scsi0: sym-2.1.18b
sym0:0:0: ABORT operation started.
sym0:0:0: ABORT oberation timed-out.
sym0:0:0: DEVICE RESET operation started.
sym0:0:0: DEVICE RESET operation timed-out.
sym0:0:0: BUS RESET operation started.
sym0:0:0: BUS RESET operation timed-out.
sym0:0:0: HOST RESET operation started.
sym0: SCSI BUS has been reset.

After the last line the machine is totally frozen and has to be reset. I'm
really wondering what is causing this since there were not many changes in
drivers/scsi from test11 to final.
Any idea what might be going wrong? test11 still boots and works like a charm
so I don't think that the hardware died over night.

If you need any further information about the specific setup please drop me a
line.

cat /proc/pci    http://www.wnk.at/tmp/pci.txt
.config    http://www.wnk.at/tmp/config_2.6.txt


Thanks,
--
Tom Winkler
e-mail: tom@qwws.net

