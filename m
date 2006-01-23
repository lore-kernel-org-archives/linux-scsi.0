From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 07/13] SCSI: export scsi_eh_finish_cmd() and scsi_eh_flush_done_q()
Date: Mon, 23 Jan 2006 13:08:04 +0900
Message-ID: <43D456A4.4090503@gmail.com>
References: <11379891632150-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xproxy.gmail.com ([66.249.82.203]:1943 "EHLO xproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1751365AbWAWEIK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Jan 2006 23:08:10 -0500
Received: by xproxy.gmail.com with SMTP id i30so583438wxd
        for <linux-scsi@vger.kernel.org>; Sun, 22 Jan 2006 20:08:09 -0800 (PST)
In-Reply-To: <11379891632150-git-send-email-htejun@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: taejun@hotmail.com, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Tejun Heo wrote:
> Export two SCSI EH command handling functions.  To be used by libata EH.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> 
> ---
> 
> James, this patch is a part of libata-EH related updates.  After the
> update, libata EH uses functions exported from this patch to retry or
> complete failed commands.
> 

Sorry, James & SCSI guys.

Please ignore this message.  This was test run gone bad.

-- 
tejun
