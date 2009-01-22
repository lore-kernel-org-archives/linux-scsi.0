From: "Sudhakar Pannerselvam" <sudhakarp@inmage.net>
Subject: RE: qla2xxx 0000:03:0c.0: Firmware image unavailable
Date: Thu, 22 Jan 2009 06:39:56 -0800
Message-ID: <D4B83214B57CAC4499F1114D069E451A01A7D6FA@bunker.inside.abhaisystems.com>
References: <E463DF2B2E584B4A82673F53D62C2EF45CEAB550@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 64-60-250-125.static-ip.telepacific.net ([64.60.250.125]:1315
	"EHLO bunker.inside.abhaisystems.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752000AbZAVOzL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2009 09:55:11 -0500
Content-class: urn:content-classes:message
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF45CEAB550@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>, Seokmann Ju <seokmann.ju@qlogic.com>
Cc: linux-scsi@vger.kernel.org, device-mapper development <dm-devel@redhat.com>

Firmware is loaded through udev hotplug interface i.e using
request_firmware(). Can you verify if udev hotplug is functional in your
setup.

To reproduce this in my local setup, I have kill'ed udevd daemon and
loaded qlogic module which failed with firmware unavailable message. 

Regards,
Sudhakar

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Moger, Babu
> Sent: Thursday, January 22, 2009 7:44 PM
> To: Seokmann Ju
> Cc: linux-scsi@vger.kernel.org; device-mapper development
> Subject: RE: qla2xxx 0000:03:0c.0: Firmware image unavailable
> 
> Yes, the naming conventions look good. Here is the output of ls
> 
> -rw-r--r-- 1 root root  76802 Jan 21 16:41 ql2100_fw.bin
> -rw-r--r-- 1 root root  84566 Jan 21 16:41 ql2200_fw.bin
> -rw-r--r-- 1 root root 125088 Jan 21 16:41 ql2300_fw.bin
> -rw-r--r-- 1 root root 135896 Jan 21 16:41 ql2322_fw.bin
> -rw-r--r-- 1 root root 228056 Jan 21 16:41 ql2400_fw.bin
> -rw-r--r-- 1 root root 239052 Jan 21 16:41 ql2400_fw.bin_mid
> -rw-r--r-- 1 root root 200064 Jan 21 16:41 ql2500_fw.bin
> -rw-r--r-- 1 root root 219924 Jan 21 16:41 ql2500_fw.bin_mid
> 
> Thanks
> Babu Moger 
> 
> -----Original Message-----
> From: Seokmann Ju [mailto:seokmann.ju@qlogic.com]
> Sent: Wednesday, January 21, 2009 6:26 PM
> To: Moger, Babu
> Cc: linux-scsi@vger.kernel.org; device-mapper development
> Subject: Re: qla2xxx 0000:03:0c.0: Firmware image unavailable
> 
> 
> On Jan 21, 2009, at 4:00 PM, Moger, Babu wrote:
> 
> > Hi All,
> > Have you guys seen this following error?
> >
> > Jan 21 16:30:44 txmpp2 kernel: qla2xxx 0000:03:0c.0: 
> Firmware image  
> > unavailable.
> > Jan 21 16:30:44 txmpp2 kernel: qla2xxx 0000:03:0c.0: 
> Firmware images  
> > can be retrieved from: 
> ftp://ftp.qlogic.com/outgoing/linux/firmware/.
> >
> > After this error, qlogic driver fails to detect the LUNs attached.
> >
> > I am running 2.6.29-rc2 kernel on x86_64 machine.
> >
> > I tried couple of things without any success. I downloaded all the  
> > qlogic firmwares available and kept it in /lib/firmware. Tried  
> > rebuilding the kernel. Did not help. Thanks in advance.
> Could you double check that those firmware binaries under /lib/ 
> firmware have correct naming convention as defined in qla_os.c:  
> FW_FILE_ISP2XXX?
> 
> >
> >
> >
> > Thanks
> > Babu Moger
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux- 
> > scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
