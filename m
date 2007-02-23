From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: aacraid not detecting drives if compiled into kernel
Date: Fri, 23 Feb 2007 08:04:21 -0500
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF015BC88A@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:54505 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbXBWNEX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Feb 2007 08:04:23 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: pcaldes <pcaldes@attglobal.net>
Cc: linux-scsi@vger.kernel.org

The driver in RHEL3 is old (1.1.5-2412ish, so not that old), use the
Adaptec supplied sources and we will investigate. You can find them in
our download section, just pick a 'modern' aac based card and browse for
the latest. I believe I fixed the last set of problems associate with
compiling the driver static in the kernel in 1.1.5-2415. The testing was
done under a 2.6 kernel though so we may have a new set of issues to
work through ...

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of pcaldes
> Sent: Thursday, February 22, 2007 8:35 PM
> To: linux-scsi@vger.kernel.org
> Subject: aacraid not detecting drives if compiled into kernel
> 
> 
> I'm using the Redhat kernel-2.4.21-47.EL on an IBM x3550 server which 
> has a IBM ServeRAID 8k-l controller.
> I recompiled kernel to include the aacraid driver in the 
> kernel (not as 
> a module) for use with a bootcd.
> CONFIG_SCSI=y
> CONFIG_BLK_DEV_SD=y
> CONFIG_SCSI_AACRAID=y
> 
> When the kernel loads, the aacraid driver initializes but it does not 
> find the drive.
> If I force the SCSI subsystem to rescan the host adapters, 
> the aacraid 
> driver finds the drive.
>     # echo "scsi scan-new-devices" > /dev/scsi/scsi
> 
> However, if I compile the aacraid driver as a module, when I do a 
> 'modprobe aacraid' the driver loads and finds the drive.
> 
> Any ideas on what is wrong and how to get around this?
> I really need to have the aacraid driver compiled into the kernel for 
> various reasons to avoid using an initrd.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
