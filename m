From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [ANNOUNCE]: Auto notification of initiators by SCST targets about
 devices additional/removal or their size changed implemented
Date: Thu, 26 Mar 2009 22:18:16 +0300
Message-ID: <49CBD4F8.5080605@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:57198 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759844AbZCZTRS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2009 15:17:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scst-devel <scst-devel@lists.sourceforge.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi All

In the recent commits in SCST SVN repository I added to SCST ability to 
automatically notify initiators about the following two types of events:

1. Devices addition or removal (REPORTED LUNS DATA CHANGED)

2. If any device changed its size (CAPACITY DATA CHANGED)

Both types of notifications are supported: Asynchronous Events 
Notifications (AEN) and Unit Attentions. If a target driver supports 
AENs, they will be used, otherwise, Unit Attentions will be used.

At the moment in Linux only open-iscsi partially understands those 
events. It can see added devices. But it doesn't process devices removal 
or size changed events.

I'm going to make development freeze of SCST 1.0.1 tomorrow. Then after 
few weeks of testing 1.0.1 is going to be released.

SCST is an alternative implementation of SCSI target subsystem for 
Linux. You can find more information about it on its home page 
http://scst.sourceforge.net

Vlad
