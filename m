From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] mptsas: add parent port backlink
Date: Wed, 12 Jul 2006 13:18:24 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D701F667C@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:56547 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750824AbWGLTSu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jul 2006 15:18:50 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wednesday, July 12, 2006 7:51 AM, James Bottomley wrote:
> 
> This takes advantage of the sas class backlink function to show which
> port on an expander is used to communicate with the parent.
> 

I don't see where the backlink is create, so I'm not sure
why this is needed.  Is the backlink in /sys/class/sas_port, 
/sys/class/sas_device, or /sys/class_expander ?

Also, I noticed that in yesterdays patch to solve another
issue with regarding mptsas integrated raid, you had slipped
this backlink stuff in that patch.   That part was rejected
when I applied that patch.  Just letting you know.

Eric
