From: Jan-Frode Myklebust <mykleb@no.ibm.com>
Subject: Re: soft lockup with 2.6.14.4/ips
Date: Tue, 3 Jan 2006 19:49:40 +0100
Message-ID: <20060103184940.GA28255@99RXZYP.ibm.com>
References: <A121ABA5B472B74EB59076B8E3C8F01901C59629@rtpe2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:44176 "EHLO
	mtagate2.uk.ibm.com") by vger.kernel.org with ESMTP id S932485AbWACSt4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jan 2006 13:49:56 -0500
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate2.uk.ibm.com (8.12.10/8.12.10) with ESMTP id k03InniD154464
	for <linux-scsi@vger.kernel.org>; Tue, 3 Jan 2006 18:49:50 GMT
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com [9.149.37.216])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k03InnFI137044
	for <linux-scsi@vger.kernel.org>; Tue, 3 Jan 2006 18:49:49 GMT
Received: from d06av04.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.12.11/8.13.3) with ESMTP id k03InnqR003959
	for <linux-scsi@vger.kernel.org>; Tue, 3 Jan 2006 18:49:49 GMT
Content-Disposition: inline
In-Reply-To: <A121ABA5B472B74EB59076B8E3C8F01901C59629@rtpe2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: IpsLinux <ipslinux@Adaptec.com>
Cc: linux-scsi@vger.kernel.org

Yes, I realized this was harmless eventually... 

Have only tested it with 2.6.14.4 and 2.6.14.5 which both gave this
message. The kernel-smp-2.6.10-1.771_FC2 kernel we were running
previously didn't give this error/warning, because it wasn't yet added
to the kernel. But as far as i can recall, the ServeRAID cards are often
quite slow at initialization.

Unfortunately I woun't be able to test the latest 2.6.15 kernel, as this
is on a production system. If 2.6.14.5 fixes the stability problems we
had with kernel-smp-2.6.10-1.771_FC2, we plan on running it for quite
some time..


  -jf
