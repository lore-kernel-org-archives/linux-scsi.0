From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [Bug 14159] AIC79xx is not working properly with an attached
 scsi tape since 2.6.29
Date: Mon, 14 Sep 2009 09:25:12 -0500
Message-ID: <1252938312.8584.37.camel@mulgrave.site>
References: <bug-14159-11613@http.bugzilla.kernel.org/>
	 <200909140718.n8E7ImIE010519@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <200909140718.n8E7ImIE010519@demeter.kernel.org>
Sender: linux-acpi-owner@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> --- Comment #3 from g.giorgetti@teamsystem.com  2009-09-14 07:18:46 ---
> today after building and installing the latest stable kernel 2.6.31 I can tell
> you that the problem is still there.
> 
> Here is the machine's /proc/interrups
> 
>            CPU0       CPU1       
>   0:         44          0   IO-APIC-edge      timer
>   1:          0          2   IO-APIC-edge      i8042
>   3:          0          0   IO-APIC-fasteoi   ehci_hcd:usb2, ohci_hcd:usb5,
> ohci_hcd:usb6
>   4:          0          2   IO-APIC-edge    
>   8:          0          1   IO-APIC-edge      rtc0
>   9:          0          0   IO-APIC-fasteoi   acpi, sata_svw
>  12:          0          4   IO-APIC-edge      i8042
>  14:         63      92631   IO-APIC-edge      ide0
>  19:          0          0   IO-APIC-fasteoi   aic79xx

So this is the problem, as predicted: the card isn't getting interrupts.
This would strongly suggest an ACPI problem.  Can you try booting with
pci=noacpi?

Thanks,

James


