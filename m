From: Steve Byan <smb@egenera.com>
Subject: Re: [PATCH] make fc transport removal of target configurable
Date: Tue, 13 Jun 2006 15:49:30 -0400
Message-ID: <AAF95DE6-F93D-4009-AD62-F688A0A06DB7@egenera.com>
References: <448DF5DA.3070800@sgi.com> <20060613070714.GA16358@infradead.org> <448E9C34.6070707@emulex.com> <448EDCEB.50702@sgi.com> <7A809A3B-B514-4ADE-A717-595250103E56@egenera.com> <448F138B.2020109@sgi.com>
Mime-Version: 1.0 (Apple Message framework v750)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:38111 "EHLO
	roadrunner-base.egenera.com") by vger.kernel.org with ESMTP
	id S1750760AbWFMTtl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jun 2006 15:49:41 -0400
In-Reply-To: <448F138B.2020109@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: James.Smart@Emulex.Com, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jim Nead <jnead@sgi.com>, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>


On Jun 13, 2006, at 3:35 PM, Michael Reed wrote:

>
>
> Steve Byan wrote:
>> On Jun 13, 2006, at 11:42 AM, Michael Reed wrote:
>>
>>> Treating fibre channel like removable storage is wrong.  Fibre
>>> targets aren't
>>> generally supposed to go away.  If they do, there's a significant
>>> chance
>>> that they'll be repaired and returned to service.  It makes sense
>>> to keep
>>> the infrastructure in place just like scsi, sas, iscsi, ata.
>>
>> In both Fibre Channel SANs and iSCSI SANs, administrators in large
>> datacenters will re-zone devices with some regularity as they
>> redeploy applications among existing systems.
>
> Yes, they will.  And don't they generally do this gracefully, i.e,
> shut down access to file systems or devices before rezoning?  And when
> the target is rezoned to the host again don't they expect to be able
> to resume using it.  This patch allows that to happen with no
> user intervention.

Ah, I see now. Yes, I think the behavior you are after is the correct  
one. Sorry, I didn't understand the details before chiming in.

Regards,
-Steve
-- 
Steve Byan <smb@egenera.com>
Software Architect
Egenera, Inc.
165 Forest Street
Marlboro, MA 01752
(508) 858-3125


