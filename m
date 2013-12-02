From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 01/11] hpsa: use workqueue instead of kernel thread for
 lockup detection
Date: Mon, 02 Dec 2013 10:00:02 -0800
Message-ID: <1386007202.2018.28.camel@dabdike.int.hansenpartnership.com>
References: <20131107164258.3504.5892.stgit@beardog.cce.hp.com>
	 <20131107164529.3504.60292.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47859 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753245Ab3LBSAE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Dec 2013 13:00:04 -0500
In-Reply-To: <20131107164529.3504.60292.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

On Thu, 2013-11-07 at 10:45 -0600, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> Much simpler and avoids races starting/stopping the thread.
> 
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Actually, perhaps you do need to resubmit the series: this is rejecting
against scsi-misc because of your prior hpsa patches:

patching file drivers/scsi/hpsa.c
Hunk #1 succeeded at 170 (offset -2 lines).
Hunk #2 succeeded at 4881 (offset 247 lines).
Hunk #3 succeeded at 4899 (offset 247 lines).
Hunk #4 succeeded at 4918 (offset 247 lines).
Hunk #5 succeeded at 4947 (offset 247 lines).
Hunk #6 FAILED at 4862.
Hunk #7 FAILED at 4928.
2 out of 7 hunks FAILED -- saving rejects to file
drivers/scsi/hpsa.c.rej
patching file drivers/scsi/hpsa.h
Hunk #1 FAILED at 130.
1 out of 1 hunk FAILED -- saving rejects to file drivers/scsi/hpsa.h.rej

James


