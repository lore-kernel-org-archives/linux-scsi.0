From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] scsi/mptsas: add RAID devices in ascending ID order
Date: Tue, 26 Sep 2006 12:33:01 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7034FB88@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:18659 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751578AbWIZSdH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Sep 2006 14:33:07 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Cc: linux-scsi@vger.kernel.org, mpt_linux_developer <mpt_linux_developer@lsil.com>

Martin Wilck wrote: 

> 
> Yes, if the order of VolumeIDs assigned by the firmware is indeed 
> random. That's not what was observed in our test lab, though.
> 

Yes, our firmware does persistent target mapping, and if you fill
up your table, you can create a volume with a large target id.  The
target id assigned usually will map to the least significant id
of one of your hidden disk ids, and that hidden disk id will be moved
to another id much larger during creation of the volume.  Then if you
end up creating a volume at a later date, that uses smaller target ids,
then
my case I presented in yesterdays email would occur.

Eric 
