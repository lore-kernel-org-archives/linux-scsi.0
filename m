From: Grant Coady <grant_lkml@dodo.com.au>
Subject: Re: [PATCH] GDT SCSI DISK ARRAY: fix split line comments for grep
Date: Sun, 03 Aug 2008 13:39:45 +1000
Message-ID: <4v9a94lbmt1ript986mkbtgr1g6jffamnc@4ax.com>
References: <rgo9945k1lva0nh1rfrtaahoingstahl7o@4ax.com> <1217732421.30264.5.camel@localhost.localdomain>
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay04.mail-hub.dodo.com.au ([123.2.6.239]:61282 "EHLO
	relay04.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751834AbYHCDkF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Aug 2008 23:40:05 -0400
In-Reply-To: <1217732421.30264.5.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Grant Coady <gcoady.lk@gmail.com>, achim_leubner@adaptec.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, 02 Aug 2008 22:00:21 -0500, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

>On Sun, 2008-08-03 at 08:44 +1000, Grant Coady wrote:
>> Hi there,
>> 
>> Following patch unsplits some comment lines that hold driver device 
>> names so they can be grepped.
>
>I don't actually see a problem to be fixed here.  The original author
>obviously split the lines to be under 80 chars.  The actual board names
>are still integral in the comments and thus greppable even for the split
>lines.  What is it that you think needs to be fixed?

I suppose if you always grep with context there's no problem?

It's the only file I found with this issue while doing other stuff.

Grant.
