From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [GIT PATCH] scsi updates for post 2.6.18
Date: Sun, 24 Sep 2006 10:37:17 -0400
Message-ID: <4516981D.7080808@torque.net>
References: <1159065451.3436.10.camel@mulgrave.il.steeleye.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:2793 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751086AbWIXOh1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Sep 2006 10:37:27 -0400
In-Reply-To: <1159065451.3436.10.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, brking@us.ibm.com

James Bottomley wrote:
> This is the usual grab bag of updates including three new drivers:
> aic94xx, stex and arcmsr.
> 
> The patch is available here:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> 
> The short changelog is:

James,
I noticed that this sg driver patch:
http://marc.theaimsgroup.com/?l=linux-scsi&m=115879087404312&w=2

(or the one that Brian King proposed earlier) to fix an oops
on the PPC64 machine (with 64 KB page size) made it into
the list.

Doug Gilbert
