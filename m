From: Oliver Neukum <oliver@neukum.org>
Subject: question on SDEV_BLOCK vs. SDEV_QUIESCE
Date: Tue, 25 Sep 2007 09:34:30 +0200
Message-ID: <200709250934.30213.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out001.kontent.com ([81.88.40.215]:47596 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbXIYHdj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 03:33:39 -0400
Received: from [192.168.234.16] (p549A3531.dip0.t-ipconnect.de [84.154.53.49])
	by smtp-out.kontent.com (Postfix) with ESMTP id 0999D37C0E3
	for <linux-scsi@vger.kernel.org>; Tue, 25 Sep 2007 09:33:38 +0200 (CEST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

what is the difference between these states? What function should
I call to block a device in order to securely flush the caches?

	Regards
		Oliver
