From: Jason Van Patten <jvp@lateapex.net>
Subject: Re: Adaptec DPT_I2O Driver in 2.6
Date: Tue, 23 Dec 2003 16:29:57 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200312232129.hBNLTv41001100@localhost.localdomain>
References: <C2CB6D8BA015124783C0EB9B33D24FFD047D18@otcexc01.otc.adaptec.com>
Reply-To: jvp@lateapex.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from corvette.lateapex.net ([64.236.104.2]:5504 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S262446AbTLWVaD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Dec 2003 16:30:03 -0500
Received: from localhost.localdomain (corvette [127.0.0.1])
	by localhost.localdomain (8.12.8/8.12.8) with ESMTP id hBNLTvA9001103
	for <linux-scsi@vger.kernel.org>; Tue, 23 Dec 2003 16:29:57 -0500
Received: (from jvp@localhost)
	by localhost.localdomain (8.12.8/8.12.8/Submit) id hBNLTv41001100
	for linux-scsi@vger.kernel.org; Tue, 23 Dec 2003 16:29:57 -0500
In-Reply-To: <C2CB6D8BA015124783C0EB9B33D24FFD047D18@otcexc01.otc.adaptec.com> from "Salyzyn, Mark" at Dec 22, 2003 01:59:50 PM
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Mark, et al -

At Mon Dec 22 13:59:50 2003, Salyzyn, Mark wrote:
> I'd support responses to the list, even though we are on the thin line where
> the list could be unconcerned with a driver that has not shown up as a patch
> for submission.

I've been able to successfully boot the 2.6 kernel with your hacked dpt
driver.  I'd like to do some more testing with it, but it'll require
converting my LVM to LVM2 ... I think.  I'm not completely up on what's
required to convert a volume to LVM2, and then back again if I decide not to
run the 2.6 kernel.

Is there a HOW-TO or README somewhere?

Thanks.

jas
-- 
Jason Van Patten
AOL IM: Jason VP 

