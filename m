From: Douglas Gilbert <dgilbert@interlog.com>
Subject: sg3_utils-1.37 and ddpt-0.93 betas; xcopy work
Date: Tue, 08 Oct 2013 11:06:47 -0400
Message-ID: <52541F87.3020407@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:53849 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203Ab3JHPH2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Oct 2013 11:07:28 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp.infotech.no (Postfix) with ESMTP id DA69C204241
	for <linux-scsi@vger.kernel.org>; Tue,  8 Oct 2013 17:07:25 +0200 (CEST)
Received: from smtp.infotech.no ([127.0.0.1])
	by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0NIYdkUY5m5Z for <linux-scsi@vger.kernel.org>;
	Tue,  8 Oct 2013 17:07:25 +0200 (CEST)
Received: from [10.7.0.30] (unknown [10.7.0.30])
	by smtp.infotech.no (Postfix) with ESMTPA id 6BEEE2041F5
	for <linux-scsi@vger.kernel.org>; Tue,  8 Oct 2013 17:07:24 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

Since several people are working on xcopy; I have collected
various fixes, improved documentation and debug to sg_xcopy
(in sg3_utils) and ddpt into new betas dated today. They
can be found in the News section at the top of:
   http://sg.danny.cz/sg

There are a lot of other fixes to sg3_utils (see its ChangeLog)
so I intend to release version 1.37 soon.

Doug Gilbert
