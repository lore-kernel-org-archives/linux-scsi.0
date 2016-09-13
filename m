From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 3/3] sd: move DIF protection types to t10-pi.h
Date: Tue, 13 Sep 2016 09:40:50 +0200
Message-ID: <d361c603-1689-add4-17f3-ed4d8f149909@acm.org>
References: <1473615341-27203-1-git-send-email-hch@lst.de>
 <1473615341-27203-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:34983 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751091AbcIMHkx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Sep 2016 03:40:53 -0400
Received: by mail-wm0-f45.google.com with SMTP id i130so16842645wmf.0
        for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2016 00:40:52 -0700 (PDT)
In-Reply-To: <1473615341-27203-4-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

On 09/11/2016 07:35 PM, Christoph Hellwig wrote:
> These should go together with the rest of the T10 protection
> information defintions.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
