From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] GDT SCSI DISK ARRAY: fix split line comments for grep
Date: Sat, 02 Aug 2008 22:00:21 -0500
Message-ID: <1217732421.30264.5.camel@localhost.localdomain>
References: <rgo9945k1lva0nh1rfrtaahoingstahl7o@4ax.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39480 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752851AbYHCDA0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Aug 2008 23:00:26 -0400
In-Reply-To: <rgo9945k1lva0nh1rfrtaahoingstahl7o@4ax.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Coady <gcoady.lk@gmail.com>
Cc: achim_leubner@adaptec.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, 2008-08-03 at 08:44 +1000, Grant Coady wrote:
> Hi there,
> 
> Following patch unsplits some comment lines that hold driver device 
> names so they can be grepped.

I don't actually see a problem to be fixed here.  The original author
obviously split the lines to be under 80 chars.  The actual board names
are still integral in the comments and thus greppable even for the split
lines.  What is it that you think needs to be fixed?

James


