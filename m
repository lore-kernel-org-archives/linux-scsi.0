From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/2] scsi: Add scsi_device max_cmd_len
Date: Thu, 30 Mar 2006 10:39:04 -0600
Message-ID: <442C09A8.50200@us.ibm.com>
References: <200603282217.k2SMHJTH032251@d03av04.boulder.ibm.com> <20060329091104.GB7940@infradead.org> <442B15F4.30506@pobox.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:15317 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932236AbWC3QjG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Mar 2006 11:39:06 -0500
In-Reply-To: <442B15F4.30506@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Christoph Hellwig <hch@infradead.org>, James.Bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> James Bottomley wrote:
>> This really doesn't look correct.  What you want is a sata transport
>> class with a max command length in the host device.
> 
> Christoph Hellwig wrote:
>> this sounds wrong to me.  cdb length is a limitation of the host (driver).
>> A target will reject unknown commands, no matter what length they have.
> 
> 
> In practice, CDB length may be limited by both the host and the device. 
>   This applies to ATAPI, and some USB storage too IIRC.  For ATAPI, you 
> read the CDB length from the device's IDENTIFY PACKET DEVICE info page.

So the question remains, do we need to police the CDB length on a per device
basis, or is a per host basis ok? Will we have ATAPI devices falling on the
floor if they get sent too large of a cdb?

Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
