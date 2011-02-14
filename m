From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: scsi_mod issue
Date: Mon, 14 Feb 2011 14:08:14 +0000
Message-ID: <4D59374E.2020607@redhat.com>
References: <AANLkTikyGMHeE-k8J=j7axdjzcJKoHedOLfk3YuK7N5_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207Ab1BNOIR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Feb 2011 09:08:17 -0500
In-Reply-To: <AANLkTikyGMHeE-k8J=j7axdjzcJKoHedOLfk3YuK7N5_@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Reynolds <bigjohn067@gmail.com>
Cc: linux-scsi@vger.kernel.org

On 02/13/2011 02:07 PM, John Reynolds wrote:
> it would appear the scsi module does recognise the vendor and module
> as a scsi block device.
> I have tried adding the following lines to /etc/modprobe.conf.local
> options scsi_mod dev_flags="IET:VIRTUAL-DISK:0x240"
> or
> options scsi_mod dev_flags="IET:VIRTUAL-DISK:0x1000240"
> 
> rebooted several times, with the same error message
> even added the scsi_mod.dev_flags=IET:VIRTUAL-DISK:0x240 to the kernel
> boot options, again the same error.

Did you rebuild the initramfs image after modifying these options?

Also, I don't think anything in the standard module-init-tools checks for a
modprobe.conf.local - most distributions today either still use
/etc/modprobe.conf for everything (it's been deprecated for some time) or have
switched to using .conf files in /etc/modprobe.d.

Regards,
Bryn.
