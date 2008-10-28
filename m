From: Tejun Heo <tj@kernel.org>
Subject: Re: possible bug related to wodim / scsi
Date: Tue, 28 Oct 2008 10:52:09 +0900
Message-ID: <49067049.5070005@kernel.org>
References: <a91986340810211053n6b5b0199r99d60cb828b34e22@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:47920 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbYJ1BwO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Oct 2008 21:52:14 -0400
In-Reply-To: <a91986340810211053n6b5b0199r99d60cb828b34e22@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Steiner <mike65536@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Mike Steiner wrote:
> I'm running Ubuntu Hardy and get errors when burning a DVD+R but can
> burn CD-R's fine. I ran wodim with -VV to get the detailed log of scsi
> requests/responses (it's 83k).
> 
> My question is: Is this the right list to report this (to find out if
> it's a wodim or scsi driver bug)?

I would much prefer if you ping the wodim guys first but I'm fairly sure
they feel the same way in the other direction.

> If so, I can post the log and more details of my hardware
> configuration (or send it wherever it should go).

Yeap, give it a go.

-- 
tejun
