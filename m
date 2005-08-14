From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: LLDD: scatterlists only?
Date: Sun, 14 Aug 2005 18:22:32 -0400
Message-ID: <42FFC428.6060000@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:8091 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932593AbVHOAVT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Aug 2005 20:21:19 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id j7F0LFc24343
	for <linux-scsi@vger.kernel.org>; Sun, 14 Aug 2005 17:21:15 -0700
Received: from aime2k03.adaptec.com (aime2k03.adaptec.com [10.25.8.43])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id j7F0LCg20872
	for <linux-scsi@vger.kernel.org>; Sun, 14 Aug 2005 17:21:12 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi,

Did someone have a patch or was there a talk
that SCSI Core is moving towards sending _only_ scatterlists
down to LLDDs?  (effectively BUG_ON(!cmd->use_sg))

	Luben
