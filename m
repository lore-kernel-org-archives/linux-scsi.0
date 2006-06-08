From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 0/6] libata: Support SATA attached via SAS
Date: Wed, 07 Jun 2006 23:49:06 -0400
Message-ID: <44879E32.1020500@torque.net>
References: <4486FDBD.9030200@us.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:60906 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932480AbWFHDtJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jun 2006 23:49:09 -0400
In-Reply-To: <4486FDBD.9030200@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: jgarzik@pobox.com, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

Brian King wrote:
> Jeff,
> 
> Here is a refresh of my patchset to allow SAS HBAs to use libata to
> control attached SATA devices. It should apply cleanly to #upstream.

Brian,
I hope that libata's ATA PASS THROUGH (16) SCSI command
is wired up as I just checked a new device type '-d sat'
into smartmontools cvs.

Doug Gilbert

