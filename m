From: Alireza Haghdoost <alireza@cs.umn.edu>
Subject: Re: [SCSI] qla2xxx: Question about out-of-order SCSI command processing
Date: Tue, 3 Dec 2013 11:19:09 -0600
Message-ID: <CAB-428k3qiTr8sWeotueP3DQxnM3LKq2LRYrkmU+6CMyOaT_0A@mail.gmail.com>
References: <CAB-428kfuWWGDhciGTAy6OCZr8ACBh52_iebBd8U4gwN0S7GPA@mail.gmail.com>
 <529DC9FF.6030109@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.36.201]:60134 "EHLO mail.cs.umn.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab3LCRTv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Dec 2013 12:19:51 -0500
Received: from mail-vc0-f175.google.com (mail-vc0-f175.google.com [209.85.220.175])
	by mail.cs.umn.edu (Postfix) with ESMTPSA id 2CF3A2A529D
	for <linux-scsi@vger.kernel.org>; Tue,  3 Dec 2013 11:19:49 -0600 (CST)
Received: by mail-vc0-f175.google.com with SMTP id ld13so9956164vcb.20
        for <linux-scsi@vger.kernel.org>; Tue, 03 Dec 2013 09:19:49 -0800 (PST)
In-Reply-To: <529DC9FF.6030109@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, Jerry Fredin <jerry.fredin@netapp.com>

On Tue, Dec 3, 2013 at 6:09 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> I think libaio can reorder commands before these reach the SCSI core.

Thanks for your comments. I think the libaio is above the block layer.
Therefore, since we observed the ordering is maintained in the block
layer, I don't think libaio reorder IO requests with in an IO context.
