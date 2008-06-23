From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/4] Fix SES timeout
Date: Mon, 23 Jun 2008 10:39:59 -0500
Message-ID: <1214235599.3310.3.camel@localhost.localdomain>
References: <20080623151431.GD4392@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52895 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755477AbYFWPkF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jun 2008 11:40:05 -0400
In-Reply-To: <20080623151431.GD4392@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Mon, 2008-06-23 at 09:14 -0600, Matthew Wilcox wrote:
> Timeouts are measured in jiffies, not in seconds.

That's a bit of a brown paper bag one; thanks.

It's not really part of the series (fortunately) because it needs to be
in -rc fixes and backported to stable.

James


