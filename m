From: Douglas Gilbert <dougg@torque.net>
Subject: Re: sg_scan -i /dev/sg[0123] /dev/hd[abcd] /dev/scd[0123]
Date: Fri, 12 Dec 2003 23:00:35 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FD9BBF3.1030209@torque.net>
References: <1070670440.3056.7.camel@patibmrh9>	 <3FD43229.7070708@torque.net>  <1070906283.2263.101.camel@patibmrh9>	 <1070908146.2263.121.camel@patibmrh9> <1071172941.2868.26.camel@patibmrh9>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:12307 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S264562AbTLLNC5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2003 08:02:57 -0500
In-Reply-To: <1071172941.2868.26.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

Pat LaVarre wrote:
> Doug G:
> 
> Thank you, I see sg_scan now lets me name the devices to scan, including
> lk 2.6 block devices:
> 
> The inline patch of this e-mail then also omits and scans past the
> "Stopping because there are too many error" message in configurations
> with few devices present, ....

Pat,
Patch applied, uploaded to the sg webpage.

Willem Riede wrote:
 > > Maybe sg_scan should renamed sam_scan (sadly apart from INQUIRYs
 > > on st and osst devices).
 >             ^^^^
 > Is there something I can/should do to enable that?

No, the problem is in sg_scan. The version I just uploaded
falls back to the SCSI_IOCTL_SEND_COMMAND if the SG_IO
ioctl fails. This should make INQUIRYs work on st and osst
devices.

Doug Gilbert


