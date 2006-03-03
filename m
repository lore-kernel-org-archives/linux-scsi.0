From: Brian King <brking@us.ibm.com>
Subject: Re: ATA Pass-Through support
Date: Fri, 03 Mar 2006 10:38:17 -0600
Message-ID: <440870F9.20505@us.ibm.com>
References: <DF9C50EF9E8CDA45A06FE8735C68F85E569309@earthex2.power.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:397 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932303AbWCCQjA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2006 11:39:00 -0500
In-Reply-To: <DF9C50EF9E8CDA45A06FE8735C68F85E569309@earthex2.power.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Quat Le <Quat.Le@dothill.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, "Moore, Eric" <Eric.Moore@lsil.com>, dougg@torque.net, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

Quat Le wrote:
> I'm not familiar with the ipr driver. Is this for IBM PowerPC RAID? How
> will this work for me? I don't really need RAID. What I have is a
> Pentium-based machine.  I want to be able to talk to SATA drives on a
> SAS expander.

There is really two parts to my patchset. One is some general libata changes
needed for any SAS HBA that wants to use libata to attach SATA devices, and
the second part is the changes to ipr to use that function.

Doug had mentioned a while back that he might look into using libata to attach
SATA devices to aic94xx adapters. Doug, are you still planning to look
at this, or is someone else working on this?

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
