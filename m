From: Radu Alexa <radu.alexa@mobilcom.de>
Subject: compaq smart array 5i raid controller
Date: Fri, 12 Apr 2002 14:24:02 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CB6D1E2.1030309@mobilcom.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vgate1.mobilcom.de (vgate1.mobilcom.de [10.35.128.25])
	by apollo.mobilcom.de (8.9.3/8.9.3) with ESMTP id OAA02583
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2002 14:21:44 +0200
Received: from mobilcom.de (sagitta [10.10.132.102])
	by hermes.mobilcom.de (8.12.2/8.12.1) with ESMTP id g3CCLfIR023779
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2002 14:21:41 +0200 (MEST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

hello,

I have a compaq dl380g2 server with a smart array 5i raid controller and 
a dat dds4 scsi tape drive attached to it. distribution suse7.3, kernel 
2.4.16 from suse. I'm using the cciss driver but I can't access the tape 
drive - it is not recognized.
in documenation/cciss.txt of kernel 2.4.18 it is written:
<quote>
SCSI tape drive and medium changer support
------------------------------------------

SCSI sequential access devices and medium changer devices are supported and
appropriate device nodes are automatically created.  (e.g.
/dev/st0, /dev/st1, etc.  See the "st" man page for more details.)
You must enable "SCSI tape drive support for Smart Array 5xxx" and
"SCSI support" in your kernel configuration to be able to use SCSI
tape drives with your Smart Array 5xxx controller.
</quote>

I could not find the option "SCSI tape drive support for Smart Array 
5xxx" in kernel configuration.
can someone enlighten me?

10x



