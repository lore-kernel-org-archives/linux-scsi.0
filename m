From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] libsas: support NCQ for SATA disks
Date: Tue, 17 Oct 2006 07:15:39 -0400
Message-ID: <4534BB5B.6080002@garzik.org>
References: <453027A9.3060606@us.ibm.com> <45340A62.7050406@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:13201 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1423042AbWJQLPm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Oct 2006 07:15:42 -0400
In-Reply-To: <45340A62.7050406@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>

Brian King wrote:
> This doesn't look like the right fix for the oops you were seeing. The
> SAS usage of libata has ap->scsi_host as NULL, which indicates that
> libata does not own the associated scsi_host. I'm concerned you may
> have broken some other code path by making this change. I think the correct
> fix may require removing the dependence of ap->scsi_host from
> ata_dev_config_ncq. 

Yep.  I had already mentioned this on IRC.

	Jeff


