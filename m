From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [osd-dev] [PATCH 03/18 ver4] libosd: OSDv1 Headers
Date: Thu, 13 Nov 2008 17:41:06 +0200
Message-ID: <491C4A92.6060608@panasas.com>
References: <491073BB.4000900@panasas.com>	<1225817046-5946-1-git-send-email-bharrosh@panasas.com>	<4916F934.4090205@panasas.com>	<20081110092940.57b4c169.randy.dunlap@oracle.com>	<491AD697.9030305@panasas.com>	<20081112105945.f4ec0089.randy.dunlap@oracle.com>	<491C1CBF.6080504@panasas.com> <20081113101654.f2f25b1b.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:39271 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbYKMWlK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Nov 2008 17:41:10 -0500
Received: by an-out-0708.google.com with SMTP id d40so534696and.1
        for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2008 14:41:08 -0800 (PST)
In-Reply-To: <20081113101654.f2f25b1b.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: open-osd development <osd-dev@open-osd.org>, Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>, Sami.Iren@seagate.com, Mike@cyclone.open-osd.org, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>

Acked-and-liked-by me too :-)

Benny

On Nov. 13, 2008, 20:16 +0200, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Thu, 13 Nov 2008 14:25:35 +0200 Boaz Harrosh wrote:
> 
>> Headers only patch.
>>
>> osd_protocol.h
>> 	Contains a C-fied definition of the T10 OSD standard
>> osd_types.h
>> 	Contains CPU order common used types
>> osd_initiator.h
>> 	API definition of the osd_initiator library
>> osd_sec.h
>> 	Contains High level API for the security manager.
>>
>> [Note that checkpatch spews errors on things that are valid in this context
>> and will not be fixed]
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> Reviewed-by: Benny Halevy <bhalevy@panasas.com>
> 
> OK by me.  Thanks for the changes.
> 
>> ---
>>  include/scsi/osd_initiator.h |  332 ++++++++++++++++++++++++++++
>>  include/scsi/osd_protocol.h  |  497 ++++++++++++++++++++++++++++++++++++++++++
>>  include/scsi/osd_sec.h       |   45 ++++
>>  include/scsi/osd_types.h     |   40 ++++
>>  4 files changed, 914 insertions(+), 0 deletions(-)
>>  create mode 100644 include/scsi/osd_initiator.h
>>  create mode 100644 include/scsi/osd_protocol.h
>>  create mode 100644 include/scsi/osd_sec.h
>>  create mode 100644 include/scsi/osd_types.h
> 
> ---
> ~Randy
> _______________________________________________
> osd-dev mailing list
> osd-dev@open-osd.org
> http://mailman.open-osd.org/mailman/listinfo/osd-dev

