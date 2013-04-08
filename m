From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 3/3] PCI, scsi, ahci: Unify usages of 0x1b4b vendor ID
 to use PCI_VENDOR_ID_MARVELL_EXT
Date: Mon, 08 Apr 2013 14:40:10 -0400
Message-ID: <51630F0A.2090108@pobox.com>
References: <20130321043449.7229.81056.stgit@amt.stowe> <20130321043509.7229.93525.stgit@amt.stowe> <CAErSpo77UWR3u+DfdaOW0hG6FXQv+ADsb24bjKQ3fJOR5SFBZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f177.google.com ([209.85.216.177]:44045 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935073Ab3DHSkP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Apr 2013 14:40:15 -0400
In-Reply-To: <CAErSpo77UWR3u+DfdaOW0hG6FXQv+ADsb24bjKQ3fJOR5SFBZg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Myron Stowe <myron.stowe@redhat.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>

On 04/04/2013 02:23 PM, Bjorn Helgaas wrote:
> On Wed, Mar 20, 2013 at 10:35 PM, Myron Stowe <myron.stowe@redhat.com> wrote:
>> With the 0x1b4b vendor ID #define in place, convert hard-coded ID values.
>> Also, unify the previous SCSI specific use of this vendor ID to the new
>> macro.
>>
>> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
>> ---
>>
>>   drivers/ata/ahci.c           |   10 +++++-----
>>   drivers/scsi/mvsas/mv_init.c |    6 +++---
>>   drivers/scsi/mvumi.c         |    4 ++--
>>   drivers/scsi/mvumi.h         |    1 -
>>   4 files changed, 10 insertions(+), 11 deletions(-)
>
> Jeff & James, if you don't object to these, I can push them through my
> PCI tree along with the corresponding pci_ids.h addition.

ACK



