From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/2] scsi: Add scsi_device max_cmd_len
Date: Tue, 28 Mar 2006 18:03:00 -0600
Message-ID: <4429CEB4.4050608@us.ibm.com>
References: <200603282217.k2SMHJTH032251@d03av04.boulder.ibm.com>	 <1143584967.3353.47.camel@mulgrave.il.steeleye.com>	 <4429BB02.80304@us.ibm.com> <1143586146.3353.51.camel@mulgrave.il.steeleye.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1143586146.3353.51.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Tue, 2006-03-28 at 16:38 -0600, Brian King wrote:
>> My direction at this point has been to move away from
>> the virtual scsi host device for SATA devices attached
>> to SAS HBAs. This seemed to me to be the clearest implementation.
>> Then you have 1 SAS HBA = 1 struct scsi_host, no matter
>> how many SATA devices are attached underneath it either
>> via direct attach or via an expander.
> 
> That's what a transport class implementation would allow you to do.  As
> long as the representation of the host controller device (be it PCI,
> SCSI IDE or whatever) has an embedded generic device, the class can
> attach and carry attributes.

I'm still struggling a little with where you want to head here. Are you
proposing a scsi_transport_sata in addition to the existing scsi transports,
or are you proposing adding to the existing scsi_transport_sas code?
I assume it is the latter, since a single SAS HBA will be supporting
both SAS and SATA devices at the same time and currently scsi core only
handles a single transport per scsi_host.


Thanks,

Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
