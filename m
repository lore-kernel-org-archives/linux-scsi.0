From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: block: don't check request size in blk_cloned_rq_check_limits()
Date: Thu, 16 Jun 2016 18:59:57 -0300
Message-ID: <5763215D.4040600@linux.vnet.ibm.com>
References: <1464593093-93527-1-git-send-email-hare@suse.de>
 <20160610131901.GA28570@redhat.com> <yq160tgfoqr.fsf@sermon.lab.mkp.net>
 <575BE182.5010304@suse.de> <yq11t44f0hi.fsf@sermon.lab.mkp.net>
 <575C0DAE.7070502@suse.de> <yq17fdrcjs3.fsf@sermon.lab.mkp.net>
 <5760F6BC.60109@suse.de> <576127FC.9020608@kernel.dk>
 <57612F12.5070505@suse.de> <5761838E.1000106@linux.vnet.ibm.com>
 <57629D23.1090704@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19391 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753864AbcFPWAJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jun 2016 18:00:09 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5GLx2Xp077871
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2016 18:00:08 -0400
Received: from e24smtp02.br.ibm.com (e24smtp02.br.ibm.com [32.104.18.86])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23kr61wrwx-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2016 18:00:08 -0400
Received: from localhost
	by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
	Thu, 16 Jun 2016 19:00:06 -0300
In-Reply-To: <57629D23.1090704@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, mark.bergman@uphs.upenn.edu

On 06/16/2016 09:35 AM, Mauricio Faria de Oliveira wrote:
> On 06/15/2016 01:34 PM, Brian King wrote:
>> [...] did you ever try to reproduce this with an
>> upstream
>> kernel?

> Now that the topic is under discussion, I've asked for some time slots
> on that system, so we can test an upstream kernel and try to reproduce
> the problem and analyze it more closely.

The problem is not reproducible w/ 4.7.0-rc3 even after a few hours;
it is instantly reproducible w/ 3.12.57-60.35 (SLES 12 SP1 updates).

Hannes et al,

If you'd like some data collection from this system, feel free to ping
me about it.


-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center

