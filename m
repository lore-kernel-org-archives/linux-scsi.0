From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: SCSI target and IO-throttling
Date: Thu, 02 Mar 2006 19:21:56 +0300
Message-ID: <44071BA4.3030808@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out-relay-02.infobox.ru ([195.208.234.171]:54754 "EHLO
	out-relay-02.infobox.ru") by vger.kernel.org with ESMTP
	id S1751581AbWCBQWP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Mar 2006 11:22:15 -0500
Received: from in-relay-02.infobox.ru (in-relay-02.infobox.ru [195.208.234.235])
	by out-relay-02.infobox.ru (Postfix) with ESMTP id A1E00400ECE6
	for <linux-scsi@vger.kernel.org>; Thu,  2 Mar 2006 19:22:09 +0300 (MSK)
Received: from [127.0.0.1] (cpe-72-225-37-244.rochester.res.rr.com [72.225.37.244])
	(using SSLv3 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by in-relay-02.infobox.ru (Postfix) with ESMTP id CBA85F00DECB
	for <linux-scsi@vger.kernel.org>; Thu,  2 Mar 2006 19:22:05 +0300 (MSK)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello

Could anyone advice how a SCSI target device can IO-throttle its 
initiators, i.e. prevent them from queuing too many commands, please?

I suppose, the best way for doing this is to inform the initiators about 
the maximum queue depth X of the target device, so any of the initiators 
will not send more than X commands. But I have not found anything 
similar to that on INQUIRY or MODE SENSE pages. Have I missed something? 
Just returning QUEUE FULL status doesn't look to be correct, because it 
can lead to out of order commands execution.

Apparently, hardware SCSI targets don't suffer from queuing overflow and 
don't return all the time QUEUE FULL status, so the must be a way to do 
the throttling more elegantly.

Regards,
Vlad
