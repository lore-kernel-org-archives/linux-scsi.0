From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH 1/5] ipr gcc attributes fixes
Date: 23 May 2004 11:55:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1085331360.1763.0.camel@mulgrave>
References: <40AFF4F7.2050008@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:58836 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263171AbUEWQ4C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 May 2004 12:56:02 -0400
In-Reply-To: <40AFF4F7.2050008@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2004-05-22 at 19:48, Brian King wrote:
> This patch fixes an issue where ipr was including a kernel
> data structure, list_head, in a packed structure, which causes
> compile issues on some architectures, and is just a bad thing to do.

Yes, compiles nicely on parisc64 now, thanks.

James


