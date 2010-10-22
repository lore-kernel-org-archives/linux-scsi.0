From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 4/4 ver2] libosd: write/read_sg_kern API
Date: Fri, 22 Oct 2010 21:32:01 +0400
Message-ID: <4CC1CA91.1080003@vlnb.net>
References: <4CBD8CAB.2030207@panasas.com> <1287490962-24013-1-git-send-email-bharrosh@panasas.com> <4CBDA79E.8080006@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:59321 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447Ab0JVRcJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Oct 2010 13:32:09 -0400
In-Reply-To: <4CBDA79E.8080006@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@suse.de>, John Chandy <john.chandy@uconn.edu>, open-osd <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>

Boaz Harrosh, on 10/19/2010 06:13 PM wrote:
> This is a trivial addition to the SG API that can receive kernel
> pointers. It is only used by the out-of-tree test module. So
> it's immediate need is questionable. For maintenance ease it might
> just get in, as it's very small.

This patch doesn't handle queue's restrictions (DMA, etc.).

Here is a complete patch for reading/writing SG lists from the kernel:
http://lkml.org/lkml/2010/9/14/201

Vlad
