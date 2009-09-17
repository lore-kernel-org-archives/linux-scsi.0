From: Richard Sharpe <realrichardsharpe@gmail.com>
Subject: UNMAP and Thin Provisioning support in SBC3R20 ...
Date: Thu, 17 Sep 2009 07:10:43 -0700
Message-ID: <46b8a8850909170710p3f2407c7r742689b1a645577e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:54698 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbZIQOKj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2009 10:10:39 -0400
Received: by qw-out-2122.google.com with SMTP id 5so19220qwd.37
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2009 07:10:43 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

For those interested in SCSI and thin provisioning,
http://www.t10.org/cgi-bin/ac.pl?t=f&f=sbc3r20.pdf (sbc2r20) seems to
contain the resolution to UNMAP vs WRITE SAME (both are included) as
well as the TP Thresholds proposal. It is dated 10-Sep-2009.

-- 
Regards,
Richard Sharpe
