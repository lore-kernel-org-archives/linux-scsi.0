From: Andreas Jellinghaus <aj@leogic.com>
Subject: Re: [PATCH 2.6 ] MPT Fusion driver 3.01.03 update
Date: Thu, 25 Mar 2004 16:12:47 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <pan.2004.03.25.15.12.47.472931@leogic.com>
References: <0E3FA95632D6D047BA649F95DAB60E57040DB6D7@exa-atlanta.se.lsil.com> <pan.2004.03.25.14.54.52.188405@leogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.224.249]:39330 "EHLO main.gmane.org")
	by vger.kernel.org with ESMTP id S263186AbUCYPMt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Mar 2004 10:12:49 -0500
Received: from list by main.gmane.org with local (Exim 3.35 #1 (Debian))
	id 1B6WXH-0008PO-00
	for <linux-scsi@vger.kernel.org>; Thu, 25 Mar 2004 16:12:47 +0100
Received: from 62.245.182.10 ([62.245.182.10])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 25 Mar 2004 16:12:47 +0100
Received: from aj by 62.245.182.10 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 25 Mar 2004 16:12:47 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The isence module uses 40 kb of kernel memory.
I can't test if it is working (how would I create
an scsi error that the fusion/isence reports?),
but documenting this difference might be work.
my arch: x86_64, 

with isence compiled in:
 Memory: 2050140k/2096576k available
 (2593k kernel code, 0k reserved, 1238k data, 164k init)
without:
 Memory: 2050180k/2096576k available
 (2593k kernel code, 0k reserved, 1201k data, 164k init)

Andreas

