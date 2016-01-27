From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] LIO/SCST Merger
Date: Wed, 27 Jan 2016 10:19:12 -0800
Message-ID: <56A90A20.3020101@sandisk.com>
References: <56A9043B.7030207@sandisk.com>
 <1453918104.2322.26.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0074.outbound.protection.outlook.com ([157.56.111.74]:41494
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934727AbcA0STQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jan 2016 13:19:16 -0500
In-Reply-To: <1453918104.2322.26.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 01/27/2016 10:08 AM, James Bottomley wrote:
> On Wed, 2016-01-27 at 09:54 -0800, Bart Van Assche wrote:
>> Last year, during the 2015 LSF/MM summit, it has been decided that
>> the LIO/SCST merger project should proceed by sending the
>> functionality upstream that is present in SCST but not yet in LIO.
>> This will help to reduce the workload of target driver maintainers
>> that maintain a version of their target driver for both LIO and SCST
>> (QLogic FC and FCoE target drivers, Emulex FC and FCoE target
>> drivers, RDMA iSER target driver, RDMA SRP target driver, ...). My
>> proposal is to organize a session during which the following is
>> discussed:
>> * Which patches are already upstream in the context of the LIO/SCST
>> merger project.
>> * About which patches there is agreement but that are not yet
>> upstream.
>> * To discuss how to proceed from here and what to address first.
>
> Can you begin this in email ... I don't think any of us are clear if
> there's still an issue here ... or that we'd say more than send the
> patches upstream, like we did last year.  Just reporting on patch
> status isn't that useful ... if there were design disputes or issues to
> discuss that caused the patches not to be accepted, that would be more
> useful.

Hello James,

Several patch series have been posted by different authors. Some of 
these patch series have already been reworked several times for 
different kernel versions. I think a meeting in person would make it 
easier to discuss which patch series to take upstream first and thereby 
avoid to have to keep reworking these patch series against an evolving 
target API. These patch series are:

* Christoph Hellwig, [RFC] simplify session shutdown, January 14 
(http://thread.gmane.org/gmane.linux.scsi.target.devel/11135).
* Nicholas Bellinger, [PATCH 0/2] target: Fix LUN_RESET active I/O + TMR 
handling, January 12, 2016 
(http://thread.gmane.org/gmane.linux.scsi.target.devel/11097).
* Bart Van Assche,  [PATCH 00/21] SCSI target patches for kernel v4.5, 
January 5 (http://thread.gmane.org/gmane.linux.scsi.target.devel/10905).

Thanks,

Bart.
