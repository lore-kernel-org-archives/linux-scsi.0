From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [patch 08/15] libata: Add ability to prevent PRD from being allocated
Date: Thu, 09 Feb 2006 04:22:10 -0500
Message-ID: <43EB09C2.6080000@pobox.com>
References: <200602061542.k16FgXXX015889@d03av03.boulder.ibm.com> <43E9D236.2080207@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:14750 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1030274AbWBIJWT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2006 04:22:19 -0500
In-Reply-To: <43E9D236.2080207@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: brking@us.ibm.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Tejun Heo wrote:
> Hello, Brian.
> 
> brking@us.ibm.com wrote:
> 
>>For some HBAs, particularly SAS HBAs, there is no reason to
>>allocate a PRD buffer, since it is not used. Add a flag
>>to prevent its allocation.
>>
> 
> 
> I think it's better done with ata_sas_port_start/stop rather than with
> ATA_FLAG_NO_PRD.  All sata low level drivers which don't use PRD table
> implement their own port_start/stop (ahci.c, sata_sil24.c for example).

Good point.

	Jeff



