From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH v3 0/7] ZPODD patches for scsi tree
Date: Thu, 26 Jul 2012 14:04:00 -0400
Message-ID: <50118690.7030501@pobox.com>
References: <1343297129-28174-1-git-send-email-aaron.lu@amd.com> <50114989.3010900@pobox.com> <20120726144108.GA2724@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120726144108.GA2724@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@amd.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Lin Ming <minggr@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On 07/26/2012 10:41 AM, Aaron Lu wrote:
> On Thu, Jul 26, 2012 at 09:43:37AM -0400, Jeff Garzik wrote:
>> On 07/26/2012 06:05 AM, Aaron Lu wrote:
>>> I can't set a flag in libata-acpi.c since a related function is
>>> missing in scsi-misc tree. Will fix this when 3.6-rc1 released.

>> What does this mean?  Would you be more specific?

> The patch "libata-acpi: add ata port runtime D3Cold support" by Lin Ming
> introduced a function ata_acpi_wake_dev in libata-acpi.c, and only lives
> in libata-next tree but not scsi-misc tree.
[...]
> Another minor issue is, I need to use the can_power_off and
> wakeup_by_user flag of the scsi_device structure in sr patches, but
> they are all introduced in patches in libata-next tree, so I have to
> re-define them in this patch set. Will cause conflict if James send
> these sr patches to Linus. Any way to avoid this?


Linus said he just merged the libata patches, so they should appear in 
the torvalds/linux.git as soon as he pushes out (in the next 12 hours, 
I'm guessing).

Up to James how he wants to coordinate after that...  he might pull in 
Linus's tree into scsi-misc or another solution.

	Jeff


