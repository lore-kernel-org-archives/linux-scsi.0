From: Chris Friesen <chris.friesen@windriver.com>
Subject: QoS for iSCSI target?
Date: Thu, 10 Mar 2016 16:24:25 -0600
Message-ID: <56E1F419.5070005@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:64584 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932204AbcCJWYb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2016 17:24:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

Hi,

I'm looking for information on whether the iSCSI target in the kernel offers any 
way to do QoS between traffic driven by different initiators.

I'm trying to make sure that one initiator can't do a denial-of-service attack 
against others.

Does the kernel target have this sort of thing built-in, or do I need to look at 
network traffic-shaping to achieve this?

Thanks,
Chris
