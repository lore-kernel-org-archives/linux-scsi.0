From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 1/2] scsi: Add scsi_device max_cmd_len
Date: Wed, 29 Mar 2006 18:22:09 -0500
Message-ID: <442B16A1.10401@pobox.com>
References: <200603282217.k2SMHJTH032251@d03av04.boulder.ibm.com> <1143584967.3353.47.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1143584967.3353.47.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Brian King <brking@us.ibm.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Tue, 2006-03-28 at 16:17 -0600, Brian King wrote:
>> Add a max_cmd_len field to the scsi_device struct
>> to allow for per device limits of allowable command
>> lengths. This will be used by libata, which is currently
>> using the max_cmd_len field in the scsi_host struct,
>> which doesn't work for attaching libata controlled
>> SATA devices to SAS HBAs.
> 
> This really doesn't look correct.  What you want is a sata transport
> class with a max command length in the host device.

Note that Tejun added an easy-to-miss ATA transport starter class in the
eh_timed_out patches.

I've always supported the additional of (and fleshing out of) an ATA 
transport class.

	Jeff


