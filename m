From: Oliver Neukum <oliver@neukum.org>
Subject: question on flushing buffers and spinning down disk
Date: Tue, 18 Sep 2007 10:32:29 +0200
Message-ID: <200709181032.29864.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:58578 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752139AbXIRIkM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Sep 2007 04:40:12 -0400
Received: from [192.168.234.16] (p549A299A.dip0.t-ipconnect.de [84.154.41.154])
	by smtp-out.kontent.com (Postfix) with ESMTP id 61DF65803040
	for <linux-scsi@vger.kernel.org>; Tue, 18 Sep 2007 10:31:51 +0200 (CEST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

which function should a lldd call to make the scsi layer flush
a device's buffers and spin it down? Which kind of locking is
required?

	Regards
		Oliver
