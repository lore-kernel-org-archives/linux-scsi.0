From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: How to add/drop SCSI drives from within the driver?
Date: Tue, 04 Jan 2005 11:42:32 -0600
Message-ID: <1104860553.5327.46.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E570230CAD3@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:40909 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261726AbVADRpt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Jan 2005 12:45:49 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570230CAD3@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: Matt Domsch <Matt_Domsch@Dell.com>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, brking@us.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, bunk@fs.tum.de, Andrew Morton <akpm@osdl.org>, "Ju, Seokmann" <sju@lsil.com>, "Doelfel, Hardy" <hdoelfel@lsil.com>, "Mukker, Atul" <Atulm@lsil.com>

On Tue, 2005-01-04 at 12:25 -0500, Bagalkote, Sreenivas wrote:
> A minor point is that an application should ideally force scan only those
> drives

Yes, it's a bit overkill, but it would work ... it's not like
reconfiguration is something you do every day.

> that it has added. But more importantly, this will not help an application
> to delete
> the drives. Correct?

Well, no, I think that would work under this scheme, too:  to delete a
drive, it must already exist, so if you've published the logical number
in sysfs, you can easily find it by logical ID and delete it by host
channel, pun and lun.

James


