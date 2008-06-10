From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0 of 3] [RFC] I/O Hints
Date: Mon, 09 Jun 2008 22:17:49 -0400
Message-ID: <yq1y75ehw36.fsf@sermon.lab.mkp.net>
References: <patchbomb.1212643369@sermon.lab.mkp.net>
	<20080605062754.GQ2961@webber.adilger.int>
	<yq1od6fml2q.fsf@sermon.lab.mkp.net>
	<20080606140205.GF19246@shareable.org>
	<yq14p86mrvw.fsf@sermon.lab.mkp.net>
	<20080609104758.GB25541@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:62874 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbYFJCS0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2008 22:18:26 -0400
In-Reply-To: <20080609104758.GB25541@shareable.org> (Jamie Lokier's message of "Mon\, 9 Jun 2008 11\:47\:58 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jamie Lokier <jamie@shareable.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Andreas Dilger <adilger@sun.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org

>>>>> "Jamie" == Jamie Lokier <jamie@shareable.org> writes:

Jamie> Ok.  So I should always traverse the sysfs tree, and only use
Jamie> the leaf values, combining them at MD nodes as I see fit, and
Jamie> ignoring the values you provide at MD nodes?

Yes.  The intent was that "sloppy" programs would use the values
exported in MD/DM, and that programs that really care (i.e. mkfs.xfs
via libdisk) would traverse the tree.

Sloppy in this case means "programs that aren't capable of dealing
with heterogeneous storage anyway".


Jamie> Is there enough information in sysfs for me to combine the
Jamie> values?  I.e. offsets of all child disks, etc.?

With MD I'd think so.  Neil generally exports everything on the
planet.  Haven't looked at DM yet.


But let me take a stab at coming up with a richer kernel interface
first...

-- 
Martin K. Petersen	Oracle Linux Engineering

