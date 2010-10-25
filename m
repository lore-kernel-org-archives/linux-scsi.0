From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 4/4 ver2] libosd: write/read_sg_kern API
Date: Mon, 25 Oct 2010 22:50:34 +0400
Message-ID: <4CC5D17A.4070406@vlnb.net>
References: <4CBD8CAB.2030207@panasas.com> <1287490962-24013-1-git-send-email-bharrosh@panasas.com> <4CBDA79E.8080006@panasas.com> <4CC1CA91.1080003@vlnb.net> <4CC40292.3090500@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:61501 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab0JYSvW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Oct 2010 14:51:22 -0400
In-Reply-To: <4CC40292.3090500@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@suse.de>, John Chandy <john.chandy@uconn.edu>, open-osd <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>

Boaz Harrosh, on 10/24/2010 01:55 PM wrote:
> On 10/22/2010 07:32 PM, Vladislav Bolkhovitin wrote:
>> Boaz Harrosh, on 10/19/2010 06:13 PM wrote:
>>> This is a trivial addition to the SG API that can receive kernel
>>> pointers. It is only used by the out-of-tree test module. So
>>> it's immediate need is questionable. For maintenance ease it might
>>> just get in, as it's very small.
>>
>> This patch doesn't handle queue's restrictions (DMA, etc.).
>>
> 
> Please for give me. I know that the name is misleading. The
> Scatter-List here is the osd scatter-list. Which describes
> extents on the object, not of the memory. The proper name would
> be extents API. The reason we named it SG is because this is the
> way the OSD standard names it. We keep very close with the STD
> naming convention, so it ended up this way.

OK, but the queue's restrictions aren't handled by it anyway.

Vlad
