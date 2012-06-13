From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH v4 02/13] libata: bind the Linux device tree to the ACPI
 device tree
Date: Wed, 13 Jun 2012 16:03:23 +0800
Message-ID: <CAF1ivSYBjw+UP3vP8RHaftjR8NJZEaHA1rtJ5ujDjkj-djHLTQ@mail.gmail.com>
References: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
	<1338181720-4149-3-git-send-email-ming.m.lin@intel.com>
	<20120528105131.67d74d45@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120528105131.67d74d45@pyramind.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jgarzik@pobox.com>, David Woodhouse <David.Woodhouse@intel.com>, Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, May 28, 2012 at 5:51 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wr=
ote:
>> +static int is_pci_ata(struct device *dev)
>> +{
>> + =A0 =A0 struct pci_dev *pdev;
>> +
>> + =A0 =A0 if (!is_pci_dev(dev))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> + =A0 =A0 pdev =3D to_pci_dev(dev);
>> +
>> + =A0 =A0 if ((pdev->class >> 8) !=3D PCI_CLASS_STORAGE_SATA &&
>> + =A0 =A0 =A0 =A0 (pdev->class >> 8) !=3D PCI_CLASS_STORAGE_IDE)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>
> This needs a better name. It doesn't check if a device is PCI ATA or
> anything of the sort, it checks if its probably a device in compatibi=
lity
> mode. A lot of controllers will in fact report RAID class or similar =
in
> native mode.

How about compat_pci_ata?

>
> Alan
