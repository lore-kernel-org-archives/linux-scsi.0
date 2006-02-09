From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [patch 03/15] libata: Remove dependence on host_set->dev for
 SAS
Date: Thu, 09 Feb 2006 02:18:43 -0500
Message-ID: <43EAECD3.30505@pobox.com>
References: <200602061542.k16FgSYn009049@d01av02.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:59289 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1422858AbWBIHSp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2006 02:18:45 -0500
In-Reply-To: <200602061542.k16FgSYn009049@d01av02.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

brking@us.ibm.com wrote:
> Remove some of the dependence on the host_set struct
> in preparation for supporting SAS HBAs. Adds a struct device
> pointer to the ata_port struct.
> 
> Signed-off-by: Brian King <brking@us.ibm.com>

Seems like a good idea independent of SAS.  My only "objection" is 
wondering about struct device reference counts, and wondering if we need 
to worry about that.  Did you look over the object lifetimes, to make 
sure nothing overlaps?

	Jeff



