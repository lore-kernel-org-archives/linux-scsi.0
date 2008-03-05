From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 3/5] Convert qla2xxx, mpt, arm, sym, a100u2w, qla1280
 to target reset handler
Date: Wed, 05 Mar 2008 11:11:18 -0600
Message-ID: <47CED436.2050403@cs.wisc.edu>
References: <1204331123-3833-1-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-2-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-3-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-4-git-send-email-michaelc@cs.wisc.edu> <20080305050833.GB1398@plap3.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53695 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758092AbYCERPo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Mar 2008 12:15:44 -0500
In-Reply-To: <20080305050833.GB1398@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, james.smart@emulex.com, christof.schmitt@de.ibm.com, mp3@de.ibm.com, rmk@arm.linux.org.uk, matthew@wil.cx

Andrew Vasquez wrote:
> On Fri, 29 Feb 2008, michaelc@cs.wisc.edu wrote:
> 
>> From: Mike Christie <michaelc@cs.wisc.edu>
>>
>> This patch converts the drivers that just needed a rename from
>> "deivce" to "target" to use the target reset handler. This includes
>> qla2xxx, mpt, arm/*, sym53c8xx_2, a100u2w and qla1280.
>>
>> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
>> ---
>>  drivers/message/fusion/mptfc.c      |    8 +++---
>>  drivers/message/fusion/mptsas.c     |    8 +++---
>>  drivers/message/fusion/mptscsih.c   |    8 +++---
>>  drivers/message/fusion/mptscsih.h   |    2 +-
>>  drivers/message/fusion/mptspi.c     |    2 +-
>>  drivers/scsi/a100u2w.c              |   12 +++++-----
>>  drivers/scsi/arm/arxescsi.c         |    2 +-
>>  drivers/scsi/arm/cumana_2.c         |    2 +-
>>  drivers/scsi/arm/eesox.c            |    2 +-
>>  drivers/scsi/arm/fas216.c           |    6 ++--
>>  drivers/scsi/arm/fas216.h           |    4 +-
>>  drivers/scsi/arm/powertec.c         |    2 +-
>>  drivers/scsi/qla1280.c              |   30 ++++++++++++------------
>>  drivers/scsi/qla2xxx/qla_os.c       |   42 +++++++++++++++++-----------------
> 
> Mike,
> 
> Thanks for doing this.  In looking at the changes needed to support
> both device and lun resets, there's some significant cleanup and code
> consolidation which can easily occur.  Your qla2xxx changes currently
> conflict with my a several commits in my 2.6.26 patch-queue.  Would
> you mind if I carry the qla2xxx updates in my tree and push when the
> infrastructure updates are present in scsi-misc-2.6?  As it stands,

That sounds good.

> here's a snapshot of the composite LUN/Target-reset updates for
> qla2xxx which I have testing locally.  The commit should make it to my
> public tree in the next few days:
> 
> 	git://git.qlogic.com/qla2xxx-upstream.git
> 

Thanks.
