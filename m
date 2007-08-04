From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] sd: disentangle barriers in SCSI
Date: Sat, 04 Aug 2007 17:51:09 +0900
Message-ID: <46B43DFD.3090109@gmail.com>
References: <1186177271.5493.30.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:42766 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409AbXHDIwK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Aug 2007 04:52:10 -0400
Received: by wa-out-1112.google.com with SMTP id v27so1108535wah
        for <linux-scsi@vger.kernel.org>; Sat, 04 Aug 2007 01:52:09 -0700 (PDT)
In-Reply-To: <1186177271.5493.30.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> Our current implementation has a generic set of barrier functions that
> go through the SCSI driver model.  Realistically, this is unnecessary,
> because the only device that can use barriers (sd) can set the flush
> functions up at probe or revalidate time.  This patch pulls the barrier
> functions out of the mid layer and scsi driver model and relocates them
> directly in sd.

Looks good to me.

Thanks.

-- 
tejun
