From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] Don't blatt first element of prv in sg_chain()
Date: Mon, 07 Jan 2008 14:02:17 +0900
Message-ID: <4781B259.6040907@gmail.com>
References: <200801071538.43371.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.188]:34306 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbYAGFCY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jan 2008 00:02:24 -0500
Received: by rv-out-0910.google.com with SMTP id k20so6955923rvb.1
        for <linux-scsi@vger.kernel.org>; Sun, 06 Jan 2008 21:02:24 -0800 (PST)
In-Reply-To: <200801071538.43371.rusty@rustcorp.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>

Rusty Russell wrote:
> I realize that sg chaining is a ploy to make the rest of the kernel
> devs feel the pain of the SCSI subsystem.  But this was a little
> unsubtle.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Embarrassingly Acked-by: Tejun Heo <htejun@gmail.com>

Thanks.

-- 
tejun
