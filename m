From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/4] mvsas: bugfix for NULL pointer execption
Date: Fri, 08 May 2009 18:05:55 -0400
Message-ID: <4A04ACC3.4080004@garzik.org>
References: <20090508061504.GA1880@jason.marvell.com> <1241797393.3327.52.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:43903 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162AbZEHWF5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 May 2009 18:05:57 -0400
In-Reply-To: <1241797393.3327.52.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ying Chu <jasonchu@marvell.com>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Fri, 2009-05-08 at 14:15 +0800, Ying Chu wrote:
>> >From 347191384292c6e9a9a572c657049bc11615fb82 Mon Sep 17 00:00:00 2001
>> From: Andy <ayan@marvell.com>
>> Date: Mon, 4 May 2009 23:29:26 +0800
>> Subject: [PATCH 1/4] mvsas: bug fix, null pointer may be used
>>
>> Null pointer exception when mvi_dev is null.
> 
> A little more explanation might be helpful.  It looks to me that you get
> this issue when you have in-flight I/O to a device we've been notified
> has gone (because you NULL out lldd_dev in the removal notification
> routine).
> 
> In which case, don't we have other races where this can happen, like in
> mvs_I_T_nexus_reset()?

Agreed...


