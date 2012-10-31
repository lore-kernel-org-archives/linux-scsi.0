From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v8 05/11] libata-eh: allow defer in ata_exec_internal
Date: Wed, 31 Oct 2012 14:52:13 -0700
Message-ID: <20121031215213.GD2945@htj.dyndns.org>
References: <1351501298-3716-1-git-send-email-aaron.lu@intel.com>
 <1351501298-3716-6-git-send-email-aaron.lu@intel.com>
 <20121029152051.GK5171@htj.dyndns.org>
 <508F42C0.8070807@intel.com>
 <20121030030144.GG4066@htj.dyndns.org>
 <508F44E1.3000801@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56025 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482Ab2JaVwS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2012 17:52:18 -0400
Content-Disposition: inline
In-Reply-To: <508F44E1.3000801@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

Hello,

On Tue, Oct 30, 2012 at 11:09:21AM +0800, Aaron Lu wrote:
> I'm not aware of a place to store such ODD specific information when
> probing the device.

You can always add some fields. :)

> I'm currently storing the loading mech type in structure zpodd, which
> gets created after the corresponding SCSI device gets created in
> ata_scsi_scan_host, so at the probe time, the zpodd structure does not
> exist yet. And the reason I create the zpodd sturcture this late is
> that, it is only created when the ODD together the platform is ZPODD
> capable, and to find out if this platform is ZPODD capbale, ACPI binding
> has to occur first, and ACPI binding happens when SCSI device is added
> to the device tree.

Hmm... I see.  Which ACPI binding is it?  The ATA ACPI binding happens
during probing.  It's a different one, I presume?

Thanks.

-- 
tejun
