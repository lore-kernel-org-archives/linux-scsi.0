From: "Sachin Mhatre \(smhatre\)" <smhatre@cisco.com>
Subject: RE: [iscsi 2/2] iscsi-probe.c
Date: Wed, 24 Sep 2003 19:12:12 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <016901c382a1$aadc5da0$8f074d0a@apac.cisco.com>
References: <20030924133716.B14318@infradead.org>
Reply-To: <smhatre@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:62522 "EHLO
	sj-iport-2.cisco.com") by vger.kernel.org with ESMTP
	id S261357AbTIXNmU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2003 09:42:20 -0400
In-Reply-To: <20030924133716.B14318@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: 'Jeff Garzik' <jgarzik@pobox.com>, linux-scsi@vger.kernel.org

Hi,
	The linux-iscsi source code submitted for review is for
inclusion into the 2.4 linux kernel tree. You can get this source code
from the linux-iscsi sourceforge branch with the tag
"linux-iscsi-3-5-branch". Just for convenience here is the cvs command
for anonymous checkout of this code:-
cvs -d:pserver:anonymous@cvs.sourceforge.net:/cvsroot/linux-iscsi co -r
linux-iscsi-3-5-branch linux-iscsi .

We have tested this code on the Redhat Linux 9.0 platform, kernel
version 2.4.22.

Please let your valuable feedback pour in.

Thanks,
Sachin

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Christoph Hellwig
Sent: Wednesday, September 24, 2003 6:07 PM
To: Lincoln Dale
Cc: Christoph Hellwig; Jeff Garzik; linux-scsi@vger.kernel.org
Subject: Re: [iscsi 2/2] iscsi-probe.c


On Wed, Sep 24, 2003 at 01:43:50PM +1000, Lincoln Dale wrote:
> FYI, we (linux-iscsi@cisco.com) have created a branch of the iSCSI
> initiator (https://sourceforge.net/projects/linux-iscsi/) that we plan
to 
> submit for inclusion into 2.6 / 2.7.

We is that code in the sf CVS?  I've found a lot of branches but nothing
that looks 2.6ish to me..

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html

