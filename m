From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 4/4 ver2] libosd: write/read_sg_kern API
Date: Sun, 24 Oct 2010 11:55:30 +0200
Message-ID: <4CC40292.3090500@panasas.com>
References: <4CBD8CAB.2030207@panasas.com> <1287490962-24013-1-git-send-email-bharrosh@panasas.com> <4CBDA79E.8080006@panasas.com> <4CC1CA91.1080003@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og111.obsmtp.com ([64.18.0.22]:49756 "HELO
	exprod5og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932152Ab0JXJze (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Oct 2010 05:55:34 -0400
In-Reply-To: <4CC1CA91.1080003@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: James Bottomley <James.Bottomley@suse.de>, John Chandy <john.chandy@uconn.edu>, open-osd <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 10/22/2010 07:32 PM, Vladislav Bolkhovitin wrote:
> Boaz Harrosh, on 10/19/2010 06:13 PM wrote:
>> This is a trivial addition to the SG API that can receive kernel
>> pointers. It is only used by the out-of-tree test module. So
>> it's immediate need is questionable. For maintenance ease it might
>> just get in, as it's very small.
> 
> This patch doesn't handle queue's restrictions (DMA, etc.).
> 

Please for give me. I know that the name is misleading. The
Scatter-List here is the osd scatter-list. Which describes
extents on the object, not of the memory. The proper name would
be extents API. The reason we named it SG is because this is the
way the OSD standard names it. We keep very close with the STD
naming convention, so it ended up this way.

> Here is a complete patch for reading/writing SG lists from the kernel:
> http://lkml.org/lkml/2010/9/14/201
> 
> Vlad

Boaz
