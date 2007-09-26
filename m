From: Oliver Neukum <oliver@neukum.org>
Subject: reversing quiescing from user space
Date: Wed, 26 Sep 2007 11:11:23 +0200
Message-ID: <200709261111.23548.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out001.kontent.com ([81.88.40.215]:60243 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbXIZJK3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Sep 2007 05:10:29 -0400
Received: from [192.168.234.16] (p549A32CC.dip0.t-ipconnect.de [84.154.50.204])
	by smtp-out.kontent.com (Postfix) with ESMTP id 532F537C0DB
	for <linux-scsi@vger.kernel.org>; Wed, 26 Sep 2007 11:10:28 +0200 (CEST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I am getting an oops with a scsi disk put into quiesced state.
Is there an easy way to reverse this from user space so I can
cleanly reboot?

	Regards
		Oliver
