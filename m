From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 0/6] libata: Support SATA attached via SAS
Date: Thu, 08 Jun 2006 08:32:33 -0500
Message-ID: <448826F1.6050606@us.ibm.com>
References: <4486FDBD.9030200@us.ibm.com> <44879E32.1020500@torque.net>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34481 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S964823AbWFHNcw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jun 2006 09:32:52 -0400
In-Reply-To: <44879E32.1020500@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: jgarzik@pobox.com, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

Douglas Gilbert wrote:
> Brian King wrote:
>> Jeff,
>>
>> Here is a refresh of my patchset to allow SAS HBAs to use libata to
>> control attached SATA devices. It should apply cleanly to #upstream.
> 
> Brian,
> I hope that libata's ATA PASS THROUGH (16) SCSI command
> is wired up as I just checked a new device type '-d sat'
> into smartmontools cvs.

Yes. Any command supported by libata today should also be supported
with this patchset.

Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
