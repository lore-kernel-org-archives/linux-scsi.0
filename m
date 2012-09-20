From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 7/8] sd: Permit merged discard requests
Date: Thu, 20 Sep 2012 08:35:43 +0800
Message-ID: <20120920003543.GA1523@kernel.org>
References: <1347985172-2495-1-git-send-email-martin.petersen@oracle.com>
 <1347985172-2495-8-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42910 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab2ITAfu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Sep 2012 20:35:50 -0400
Received: by pbbrr13 with SMTP id rr13so3750511pbb.19
        for <linux-scsi@vger.kernel.org>; Wed, 19 Sep 2012 17:35:49 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1347985172-2495-8-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, axboe@kernel.dk, snitzer@redhat.com

On Tue, Sep 18, 2012 at 12:19:31PM -0400, Martin K. Petersen wrote:
> From: "Martin K. Petersen" <martin.petersen@oracle.com>
> 
> Support requests with more than one bio payload for discards. The total
> number of bytes to be discarded is stored in req->__data_len and used in
> sd_done() to complete the I/O.

patch looks great. Tested the discard merge in my side, and it works. Thanks
for the effort.
