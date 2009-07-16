From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2]: New implementation of scsi_execute_async()
Date: Thu, 16 Jul 2009 16:54:32 +0900
Message-ID: <4A5EDCB8.1010003@kernel.org>
References: <4A563368.5040407@vlnb.net> <4A5CAFB5.1000901@vlnb.net> <4A5D9C46.2000002@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:34261 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbZGPHyw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jul 2009 03:54:52 -0400
In-Reply-To: <4A5D9C46.2000002@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, Joe Eykholt <jeykholt@cisco.com>

Hello, Boaz.

Boaz Harrosh wrote:
> It looks to me that perhaps you did not understand Tejun's code
> His code, as I remember, was on the bio level, but here you
> are duplicating what is done in bio level.

I think he looked at my mess :-) and decided it would be cleaner to
implement kernel sg mapping completely separately from user mapping.
Maybe it is, I'm not sure.  I sure hope not tho.

Thanks.

-- 
tejun
