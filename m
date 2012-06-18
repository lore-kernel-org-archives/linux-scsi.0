From: Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [PATCH v5 04/12] libata: use correct PCI devices
Date: Mon, 18 Jun 2012 15:37:20 +0400
Message-ID: <4FDF12F0.6080205@mvista.com>
References: <1340000766-129148-1-git-send-email-ming.m.lin@intel.com> <1340000766-129148-5-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1340000766-129148-5-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, David Woodhouse <David.Woodhouse@intel.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 18-06-2012 10:25, Lin Ming wrote:

> From: Holger Macht <holger@homac.de>

> Commit 9a6d6a2ddabbd32c07f6a38b659e5f3db319fa5a

    Please also specify that commit's summary in parens.

> made ata ports parent
> devices of scsi hosts, so we need to go yet another level up to be able
> to use the correct PCI devices.

> Signed-off-by: Holger Macht <holger@homac.de>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>

MBR, Sergei
