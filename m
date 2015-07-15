From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v3] [SCSI] mpt2sas, mpt3sas: Abort initialization if no
 memory I/O resources detected
Date: Wed, 15 Jul 2015 11:28:41 -0700
Message-ID: <CAE9FiQXtxWHr0j5zFeAS2LxjqwMfecP_aeQDh93CUni+GbQxWw@mail.gmail.com>
References: <1436935796-28995-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<CAE9FiQWzbwzQ7mrtyumhMFYg0-8N18+KZhjfvMfs5j5eV0C5wA@mail.gmail.com>
	<20150715062456.GB19028@dhcp-135-24-192-118.lsi.com>
	<55A6658D.6030802@raptorengineeringinc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <55A6658D.6030802@raptorengineeringinc.com>
Sender: linux-pci-owner@vger.kernel.org
To: Timothy Pearson <tpearson@raptorengineeringinc.com>
Cc: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, James Bottomley <jejb@kernel.org>, martin.petersen@oracle.com, Linux-Scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya.Prakash@avagotech.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Bjorn Helgaas <bhelgaas@google.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 15, 2015 at 6:52 AM, Timothy Pearson
<tpearson@raptorengineeringinc.com> wrote:
>> I have just kept the same description provide by Timothy in his
>> initial patch.
>>
>> But I observe that their may be chance of getting "unable to handle
>> kernel NULL pointer dereference" kernel panic if no Memory Resource
>> available in the PCI subsystem. So agreed to the Timothy proposal of
>> aborting the driver initialization if it doesn't detect any Memory
>> resource instead of whole system get into panic state.
>>
> On some systems Linux is unable / unwilling to assign a BAR if the BIOS
> does not assign one at startup.  I didn't look into the Linux allocator
> side of things in much detail, but it is quite possible that Linux is
> unaware the device only has partial resources assigned.
>

Would be great if you can post boot log so we can figure about why those
BARs are not assigned.

Yinghai
