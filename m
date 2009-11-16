From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 9/9] osd_protocol.h: Add missing #include
Date: Mon, 16 Nov 2009 21:01:08 +0200
Message-ID: <4B01A174.8000005@panasas.com>
References: <4B019BEC.3080909@panasas.com> <1258397365-356-1-git-send-email-bharrosh@panasas.com> <20091116185741.GH8113@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:27664 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752299AbZKPTBE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2009 14:01:04 -0500
In-Reply-To: <20091116185741.GH8113@deprecation.cyrius.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Michlmayr <tbm@cyrius.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

On 11/16/2009 08:57 PM, Martin Michlmayr wrote:
> * Boaz Harrosh <bharrosh@panasas.com> [2009-11-16 20:49]:
>> From: Martin Michlmayr <tbm@cyrius.com>
>>
>> include/scsi/osd_protocol.h uses ALIGN() without an #include
>> <linux/kernel.h>, leading to:
>> | include/scsi/osd_protocol.h:362: error: implicit declaration of function 'ALIGN'
> 
> Note that this patch also has to go into 2.6.32, where OSD currently
> builds to build (at least on ARM).

OK in that case we need to CC: stable@kernel.org, inside the patch

James could you add it to the patch? Should I re-post?

Thanks
Boaz
