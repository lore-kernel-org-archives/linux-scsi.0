From: Douglas Gilbert <dgilbert@interlog.com>
Subject: lsscsi 0.24 beta 1
Date: Thu, 17 Jun 2010 11:21:11 -0400
Message-ID: <4C1A3D67.6060007@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:50165 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932886Ab0FQPVV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2010 11:21:21 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp.infotech.no (Postfix) with ESMTP id C243031A7B
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 17:21:19 +0200 (CEST)
Received: from smtp.infotech.no ([127.0.0.1])
	by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vDxClz3S73qp for <linux-scsi@vger.kernel.org>;
	Thu, 17 Jun 2010 17:21:17 +0200 (CEST)
Received: from [192.168.48.95] (ip-66.54.99.216.dsl-cust.ca.inter.net [216.99.54.66])
	by smtp.infotech.no (Postfix) with ESMTPA id 8614F31A79
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 17:21:17 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

In the Downloads section of
    http://sg.danny.cz/scsi/lsscsi.html
is a beta release of lsscsi that corrects two
issues reported from around lk 2.6.32 onward:

- add "(null)" to the currently accepted "<NULL>" as
   the string representation of NULL
- FC transport syntax changes (colon to slash)

Doug Gilbert
