From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] mptfusion : dv performance fix
Date: Thu, 01 Dec 2005 12:19:20 -0600
Message-ID: <1133461161.5232.4.camel@mulgrave>
References: <91888D455306F94EBD4D168954A9457C051F3253@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:20915 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932389AbVLASTa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2005 13:19:30 -0500
In-Reply-To: <91888D455306F94EBD4D168954A9457C051F3253@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org, hch@infradead.org

On Thu, 2005-12-01 at 10:50 -0700, Moore, Eric Dean wrote:
> Syncronization for Domain Validation workqueue and the initiation of the
> alternate controller.  Its possible that dv could be terminated if the
> workqueue on the 1st channel doesn complete in time before the 2nd channel
> begins initialization.
> 
> Pls apply for 2.6.15 kernel.

Got it.

Does this take the place of these two patches in the previous set?

[PATCH 1/7]  mptfusion - performance fix for U320
[PATCH ]  mptfusion - Bad SCSI performance Fix

?

James


