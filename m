From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 12/24] mpt fusion: [2.6.30-rc6] fix for previous patch
	taskmgmt in progess should be cleared before return
Date: Fri, 22 May 2009 17:01:56 +0000
Message-ID: <1243011716.2873.24.camel@localhost.localdomain>
References: <20090522110235.GF16331@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56912 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250AbZEVRB4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 May 2009 13:01:56 -0400
In-Reply-To: <20090522110235.GF16331@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Fri, 2009-05-22 at 16:32 +0530, Kashyap, Desai wrote:
> Small fix for previous Patch applied on 26/02/2009: subject line :
> "mpt fusion: config, Taskmgmt cmd, Internal cmd, Ioctl cmd changes".

OK, so this seems to be completely bogus as well since there's no such
patch in any of the trees.

If I look at what the patch is doing, it seems it should be merged with
your 11/24 "rewrite of ioctl_cmds internal generated function" which
introduces the bug?

James


