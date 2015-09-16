From: Arthur Marsh <arthur.marsh@internode.on.net>
Subject: Re: [Bugfix 0/3] Convert eata driver to a normal PCI device driver
Date: Wed, 16 Sep 2015 20:59:54 +0930
Message-ID: <55F952B2.6080102@internode.on.net>
References: <CAErSpo4oignSpK-LCLO=deW_FZ-V58GUhBxJ5uvmXe4DYo4WdA@mail.gmail.com> <1442200140-30808-1-git-send-email-jiang.liu@linux.intel.com> <55F6EF40.50403@internode.on.net> <55F78306.3000802@linux.intel.com> <55F7C691.8000406@internode.on.net> <55F8F90D.2050703@linux.intel.com> <55F91C34.4070800@internode.on.net> <55F9266C.5060609@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <55F9266C.5060609@linux.intel.com>
Sender: linux-pci-owner@vger.kernel.org
To: Jiang Liu <jiang.liu@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org



Jiang Liu wrote on 16/09/15 17:51:

> Hi Arthur,
> 	It would be great if we could capture the text as in the
> picture posted by you at:
> 	http://www.users.on.net/~arthur.marsh/20150915547.jpg
> 	I guess a serial console could help us to capture those
> log messages. To use serial console, we need to setup serial cable,
> configure grub and kernel to use serial port as console.
> Thanks!
> Gerry
>
>>
>> Regards,
>>
>> Arthur.
>

I've already included the text of what appeaered in the image above:

sd 0:0:6:0: abort, mbox 63.
EATA0: abort, mbox 63 is in use.
sd 0:0:6:0: reset, enter.
EATA0: reset, mbox 63 in reset.
EATA0: reset, board reset done, enabling interrupts.
EATA0: reset, interrupts disabled, loops 100469.
EATA0: reset, mbox 63 locked, DID_RESET, done.
EATA0: reset, exit, done.
sd 0:0:6:0: qcomm, mbox 0, adapter busy, will start
sd 0:0:6:0: abort, mbox 0.
EATA0: abort, timeout error.
sd 0:0:6:0: reset, enter.
EATA0: reset, exit, timeout error.
sd 0:0:6:0 Device offlinled - not ready after error recovery
sd 0:0:6:0 rejecting I/O to offline device
sd 0:0:6:0 rejecting I/O to offline device
sd 0:0:6:0 [sda] Synchronize Cache(10) failed: Result: 
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
starting new kernel

As mentioned previously this occurred after the normal Synchronizing 
SCSI cache messages.

I don't think that there is anything else that gets sent to the console.

Arthur.
