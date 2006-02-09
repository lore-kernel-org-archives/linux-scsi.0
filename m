From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [patch 04/15] libata: Allow for ata_port without a libata owned
 scsi_host
Date: Thu, 09 Feb 2006 02:19:50 -0500
Message-ID: <43EAED16.2060607@pobox.com>
References: <200602061542.k16FgTlj015607@d03av03.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:60569 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1422862AbWBIHUB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2006 02:20:01 -0500
In-Reply-To: <200602061542.k16FgTlj015607@d03av03.boulder.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

brking@us.ibm.com wrote:
> Prepare for future SAS changes where libata will have ata_ports
> with no libata owned scsi_host.
> 
> Signed-off-by: Brian King <brking@us.ibm.com>

ACK patches 4-6


