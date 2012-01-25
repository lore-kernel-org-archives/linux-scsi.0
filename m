From: Douglas Gilbert <dgilbert@interlog.com>
Subject: DID_NEXUS_FAILURE ... why not DID_RESERVATION_CONFLICT ??
Date: Wed, 25 Jan 2012 13:56:23 -0500
Message-ID: <4F205057.5030705@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:47179 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab2AYS43 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jan 2012 13:56:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: thelanks@gmail.com

See title.

DID_NEXUS_FAILURE is a pretty pointless name, DID_0x11 would be
more helpful :-)

Doug Gilbert
