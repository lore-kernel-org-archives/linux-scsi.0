From: "Heinzmann, Robert" <Heinzmann@cc-dresden.de>
Subject: RE: [PATCH] sym53c8xx module parameter passing not working (2.5.6)
Date: Fri, 1 Oct 2004 17:45:39 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <7AAD212492598A4A92463C3F5D34C54F194EDE@ccd3.CC.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxs.tiscali.de ([62.27.59.134]:20753 "EHLO mxs.tiscali.de")
	by vger.kernel.org with ESMTP id S261474AbUJAPpp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Oct 2004 11:45:45 -0400
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Hello Christoph, 

> Given that no one except you noticed the lack of options so 
> far what about moving it to normal parameters instead, aka 
> one option per setting like all non-scsi and resent scsi drivers do?

The options are usually required for multi initiator configurations with
sym53c8xx only, which is not so common. Thus I just wrote this litte
(dirty ?) fix. Moving to normal parameters is something that should be
done, but I'm currently not able to do this :) If everything is beeing
moved to normal parameters, the documentation needs to be fixed too.

I think the current fix is sufficient, considering the installation base
of multi initiator sym53c8xx clusters.

Robert Heinzmann
