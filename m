From: James.Smart@Emulex.Com
Subject: RE: [PATCH] Another fix for suspend i/o - validate dev statebefore transition
Date: Sat, 11 Dec 2004 07:12:53 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C12E89C@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:8848 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S261486AbULKMM5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Dec 2004 07:12:57 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org


> If the only problem with the current scheme is the somewhat scary
> verbosity then we can shut it up by making the message part of the
> logging infrastructure.

It is, and the suggested patch is fine.

Thanks.

-- James

