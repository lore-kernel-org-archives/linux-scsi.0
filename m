From: Alex Deucher <alexdeucher@gmail.com>
Subject: Emulex fibre channel HBA support and SAN connection
Date: Thu, 28 Apr 2005 18:02:43 -0400
Message-ID: <a728f9f905042815021a39e811@mail.gmail.com>
Reply-To: Alex Deucher <alexdeucher@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.196]:16313 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262276AbVD1WCp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Apr 2005 18:02:45 -0400
Received: by rproxy.gmail.com with SMTP id a41so448546rng
        for <linux-scsi@vger.kernel.org>; Thu, 28 Apr 2005 15:02:43 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Can someone point me to some documentation on setting up a fibre
channel HBA in linux?  I can't seem to find any useful information.  I
have a Sun 220R running 2.6.12-rc3 with an emulex LP9000 HBA connected
to a Nexsan ATABEAST SAN.  I'm using the HBA driver included with the
2.6.12rc3 kernel.  I cannot find any information about the GPLed
emulex driver as far as configuration goes.  The driver seems to come
up ok, but then I get a series of error codes:

Emulex LightPulse Fibre Channel SCSI driver 8.0.28
scsi0 :  on PCI bus 00 device 20 irq 8255744
lpfc 0001:00:04.0: 0:1303 Link Up Event x1 received Data: x1 x1 x8 x2
lpfc 0001:00:04.0: 0:0321 Unknown IOCB command Data: x0, xa2 x0 x900 x2600
...
lpfc 0001:00:04.0: 0:0748 abort handler timed out waiting for abort to
complete. Data: x0 x0 x0 x1
lpfc 0001:00:04.0: 0:0327 Rsp ring 0 error -  command completion for
iotag xa00 not found
lpfc 0001:00:04.0: 0:0327 Rsp ring 0 error -  command completion for
iotag x0 not found
lpfc 0001:00:04.0: 0:0713 SCSI layer issued LUN reset (0, 0) Data: x2 x0 x0
lpfc 0001:00:04.0: 0:0327 Rsp ring 0 error -  command completion for
iotag xb00 not found
lpfc 0001:00:04.0: 0:0327 Rsp ring 0 error -  command completion for
iotag x0 not found
lpfc 0001:00:04.0: 0:0714 SCSI layer issued Bus Reset Data: x2003
scsi: Device offlined - not ready after error recovery: host 0 channel
0 id 0 lun 0
lpfc 0001:00:04.0: 0:0327 Rsp ring 0 error -  command completion for
iotag x0 not found

I noticed here:
http://marc.theaimsgroup.com/?l=linux-scsi&m=111383889908554&w=2
that there is a new FC API. Was this merged into rc3 or will this
happen after 2.6.12?  If it's not supported yet in rc3, how does one
go about configuring it?  I'm willing to test any available tools.

Any help will be greatly appreciated.  I'll be able to test on SPARC64
right now and on AMD64 in the next few days.

Thanks,

Alex

PS, please CC: me as I'm not subscribed.
