From: "G Shyam Sundar" <callshyam@gmail.com>
Subject: Re: question about qlogic QLA2312
Date: Fri, 15 Sep 2006 19:26:46 +0530
Message-ID: <19dce7c30609150656s4397bbfeyba53586cb2105ab7@mail.gmail.com>
References: <1158307245.8103.12.camel@scarafaggio>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:28504 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S1751470AbWION4s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Sep 2006 09:56:48 -0400
Received: by nf-out-0910.google.com with SMTP id o25so2243211nfa
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2006 06:56:46 -0700 (PDT)
In-Reply-To: <1158307245.8103.12.camel@scarafaggio>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Giuseppe Sacco <giuseppe.sacco@lixper.it>
Cc: linux-scsi@vger.kernel.org

Which version of the driver are you using ?
Also, what is the version of the firmware ? You can get the version of
fimware by
# grep FW_VERSION_STRING in the source directory.

It will be helpful if you could recompile the driver with
QL_DEBUG_LEVEL_2 enabled (qla_dbg.h) and recreate the issue.


-Shyam



On 9/15/06, Giuseppe Sacco <giuseppe.sacco@lixper.it> wrote:
> Hi all,
> I installed a new machine with this SCSI controller
>
> 03:02.0 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev
> 02)
>
> The problem is that firmware cannot be loaded on this board. When
> loading the qla2xxx driver, I get these messages:
>
> QLogic Fibre Channel HBA Driver
> ACPI: PCI Interrupt 0000:03:02.0[A] -> GSI 22 (level, low) -> IRQ 177
> qla2xxx 0000:03:02.0: Found an ISP2312, irq 177, iobase
> 0xffffc20000f70000
> qla2xxx 0000:03:02.0: Configuring PCI space...
> qla2xxx 0000:03:02.0: Configure NVRAM parameters...
> qla2xxx 0000:03:02.0: Verifying loaded RISC code...
> qla2xxx 0000:03:02.0: Mailbox command timeout occured. Scheduling ISP
> abort.
> qla2xxx 0000:03:02.0: [ERROR] Failed to load segment 0 of firmware
> qla2xxx 0000:03:02.0: Failed to initialize adapter
> Trying to free free IRQ177
>
> Browsing the archives of linux-scsi I found a solution[1]: a patch
> missing from the suse linux kernel. Sadly this was about an old versione
> of the kernel, while the current one already include it.
>
> I am using kernel 2.6.16.21.
>
> Any idea about what the problem could be?
>
> Thanks,
> Giuseppe
>
> [1]http://www.spinics.net/lists/linux-scsi/msg06713.html
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
