From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 35282] BUG() in 2.6.38.6
Date: Sat, 28 May 2011 11:56:37 -0500
Message-ID: <1306601797.5630.23.camel@mulgrave.site>
References: <bug-35282-11613@https.bugzilla.kernel.org/>
	 <201105270953.p4R9r71E010345@demeter2.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49860 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223Ab1E1Q4j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 May 2011 12:56:39 -0400
In-Reply-To: <201105270953.p4R9r71E010345@demeter2.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

> --- Comment #5 from Nils Kneuper <crazy-ivanovic@gmx.net>  2011-05-27 09:53:06 ---
> I had some crashes over here, especially with 2.6.39, but also with some
> 2.6.38.*, kernel versions, too. Applied this patch about 24h ago and so far
> there seem to be no further kernel panics. Since I know no way to actually get
> the logs from the crashes, I just photographed them using my mobile phone:
> http://imagebin.org/index.php?mode=image&id=155275
> http://imagebin.org/index.php?mode=image&id=155274

That looks like this:

http://marc.info/?l=linux-scsi&m=130635674521428

It depends on a couple of other block fixes, though.  Everything will
probably be upstream and back to stable in the next few days.

James


