From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 0/3] zfcp fixes for 2.6.33-rc4
Date: Wed, 13 Jan 2010 17:52:35 +0100
Message-ID: <20100113165235.299592000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.17.164]:44464 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab0AMQzP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2010 11:55:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com

James,

here are 3 zfcp fixes for the 2.6.33-rc series. The patches apply on
top of 2.6.33-rc4.

We are also working on fixes for the FC BSG timeout handling in zfcp.
I will send them tomorrow in an additional patch series to have the
proposed change in the FC transport class and the related zfcp patches
in one place.

--
Christof Schmitt

