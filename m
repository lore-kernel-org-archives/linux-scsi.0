From: Kurt Miller <kurt@intricatesoftware.com>
Subject: Re: LSI SAS2008 SATA TRIM not working
Date: Fri, 07 Feb 2014 15:52:43 -0500
Message-ID: <1391806363.2761.8.camel@sonic.justonedata.com>
References: <1391730975.3449.16.camel@sonic.justonedata.com>
	 <yq1vbwqslek.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 4133fa24.cst.lightpath.net ([65.51.250.36]:8552 "EHLO
	mail1.intricatesoftware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753072AbaBGUxI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2014 15:53:08 -0500
In-Reply-To: <yq1vbwqslek.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2014-02-07 at 15:44 -0500, Martin K. Petersen wrote:
> >>>>> "Kurt" == Kurt Miller <kurt@intricatesoftware.com> writes:
> 
> Kurt> Is TRIM working for anyone using LSI SAS2008 controllers?
> 
> Yes. But its SAT appears to be somewhat selective about which devices it
> flags as capable.
> 
> Please send me the output of:
> 
> # sg_readcap -l /dev/sdc
> # sg_vpd -p bl /dev/sdc
> # sg_vpd -p lbpv /dev/sdc
> 

Hi Martin,

Thank you for your reply. Below is the output you requested. Note that
when the EVO's are connected to a SATA AHCI port on my desktop
motherboard, TRIM works okay. Please let me know if you need additional
information.

Regards,
-Kurt

# sg_readcap -l /dev/sdc
Read Capacity results:
   Protection: prot_en=0, p_type=0, p_i_exponent=0
   Logical block provisioning: lbpme=0, lbprz=0
   Last logical block address=976773167 (0x3a38602f), Number of logical
blocks=976773168
   Logical block length=512 bytes
   Logical blocks per physical block exponent=0
   Lowest aligned logical block address=0
Hence:
   Device size: 500107862016 bytes, 476940.0 MiB, 500.11 GB

# sg_vpd -p bl /dev/sdc
Block limits VPD page (SBC):
  Write same no zero (WSNZ): 0
  Maximum compare and write length: 0 blocks
  Optimal transfer length granularity: 0 blocks
  Maximum transfer length: 0 blocks
  Optimal transfer length: 0 blocks
  Maximum prefetch length: 0 blocks
  Maximum unmap LBA count: 0
  Maximum unmap block descriptor count: 0
  Optimal unmap granularity: 0
  Unmap granularity alignment valid: 0
  Unmap granularity alignment: 0
  Maximum write same length: 0x0 blocks

# sg_vpd -p lbpv /dev/sdc
Logical block provisioning VPD page (SBC):
  Unmap command supported (LBPU): 0
  Write same (16) with unmap bit supported (LBWS): 0
  Write same (10) with unmap bit supported (LBWS10): 0
  Logical block provisioning read zeros (LBPRZ): 0
  Anchored LBAs supported (ANC_SUP): 0
  Threshold exponent: 0
  Descriptor present (DP): 0
  Provisioning type: 0


