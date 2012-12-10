From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 9/9] fnic: FIP configuration mismatch between switch and
 adapter crashes driver
Date: Mon, 10 Dec 2012 09:38:27 +0000
Message-ID: <1355132307.2464.14.camel@dabdike.int.hansenpartnership.com>
References: <1355131299-3313-1-git-send-email-hiralpat@cisco.com>
	 <1355131299-3313-9-git-send-email-hiralpat@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33964 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752176Ab2LJJic (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Dec 2012 04:38:32 -0500
In-Reply-To: <1355131299-3313-9-git-send-email-hiralpat@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hiral Patel <hiralpat@cisco.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2012-12-10 at 01:21 -0800, Hiral Patel wrote:
> If switch configured in FIP and kirkwood lake configured in non-fip mode,
> panics while queueing FIP frame in non-existing fip_frame_queue. Added config
> check before queueing FIP frame in misconfiguration case to avoid kernel panic.

Where exactly does this go?  You've already got a 9/10 patch which is
different.

James


