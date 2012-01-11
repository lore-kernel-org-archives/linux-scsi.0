From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 4/6] drivers/scsi/sg.c: convert to kstrtoul_from_user()
Date: Tue, 10 Jan 2012 19:08:44 -0500
Message-ID: <1326240524.3264.91.camel@dabdike.int.hansenpartnership.com>
References: <20120110234235.774BF200133@hpza10.eem.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58530 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751576Ab2AKAIr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jan 2012 19:08:47 -0500
In-Reply-To: <20120110234235.774BF200133@hpza10.eem.corp.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, sboyd@codeaurora.org, dgilbert@interlog.com, dougg@torque.net

On Tue, 2012-01-10 at 15:42 -0800, akpm@linux-foundation.org wrote:
> From: Stephen Boyd <sboyd@codeaurora.org>
> Subject: drivers/scsi/sg.c: convert to kstrtoul_from_user()
> 
> Instead of open coding this function use kstrtoul_from_user() directly.

I really don't like these invent post facto functions and then try to
insert them on the grounds the original users are now "open coded".
However, if doug acks (or sends it as part of an update), I'll apply.

James


