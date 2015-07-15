From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v3] [SCSI] mpt2sas, mpt3sas: Abort initialization if no
 memory I/O resources detected
Date: Tue, 14 Jul 2015 22:36:58 -0700
Message-ID: <CAE9FiQWzbwzQ7mrtyumhMFYg0-8N18+KZhjfvMfs5j5eV0C5wA@mail.gmail.com>
References: <1436935796-28995-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1436935796-28995-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-pci-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: tpearson@raptorengineeringinc.com, James Bottomley <jejb@kernel.org>, martin.petersen@oracle.com, Linux-Scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya.Prakash@avagotech.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Bjorn Helgaas <bhelgaas@google.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 14, 2015 at 9:49 PM, Sreekanth Reddy
<sreekanth.reddy@avagotech.com> wrote:
> Driver crashes if the BIOS do not set up at least one
> memory I/O resource. This failure can happen if the device is too
> slow to respond during POST and is missed by the BIOS, but Linux
> then detects the device later in the boot process.

But pci subsystem should assign resources to those unassigned BAR.

Do you mean even kernel can not assign resource to them? or it takes so long for
mpt FW to get ready?

Thanks

Yinghai
