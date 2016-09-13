From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 1/3] scsi_debug: use struct t10_pi_tuple instead of struct
 sd_dif_tuple
Date: Tue, 13 Sep 2016 09:37:51 +0200
Message-ID: <4137d57d-3641-13bd-6c3d-7694c46473ce@acm.org>
References: <1473615341-27203-1-git-send-email-hch@lst.de>
 <1473615341-27203-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38001 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754636AbcIMHhy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Sep 2016 03:37:54 -0400
Received: by mail-wm0-f52.google.com with SMTP id 1so184738988wmz.1
        for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2016 00:37:54 -0700 (PDT)
In-Reply-To: <1473615341-27203-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

On 09/11/2016 07:35 PM, Christoph Hellwig wrote:
> And remove the declaration of the latter in sd.h as scsi_debug was the
> only user.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
