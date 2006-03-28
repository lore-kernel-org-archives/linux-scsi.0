From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/2] scsi: Add scsi_device max_cmd_len
Date: Tue, 28 Mar 2006 16:49:06 -0600
Message-ID: <1143586146.3353.51.camel@mulgrave.il.steeleye.com>
References: <200603282217.k2SMHJTH032251@d03av04.boulder.ibm.com>
	 <1143584967.3353.47.camel@mulgrave.il.steeleye.com>
	 <4429BB02.80304@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4429BB02.80304@us.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: brking@us.ibm.com
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2006-03-28 at 16:38 -0600, Brian King wrote:
> My direction at this point has been to move away from
> the virtual scsi host device for SATA devices attached
> to SAS HBAs. This seemed to me to be the clearest implementation.
> Then you have 1 SAS HBA = 1 struct scsi_host, no matter
> how many SATA devices are attached underneath it either
> via direct attach or via an expander.

That's what a transport class implementation would allow you to do.  As
long as the representation of the host controller device (be it PCI,
SCSI IDE or whatever) has an embedded generic device, the class can
attach and carry attributes.

James


