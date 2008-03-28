From: "adam radford" <aradford@gmail.com>
Subject: Re: [patch 3/7] 3W RAID drivers: memset not needed in probe
Date: Fri, 28 Mar 2008 13:52:20 -0800
Message-ID: <b1bc6a000803281452i687453c4mac2b8b506a0c96db@mail.gmail.com>
References: <200803042324.m24NON8V003087@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:40688 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307AbYC1VwX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Mar 2008 17:52:23 -0400
Received: by fg-out-1718.google.com with SMTP id l27so454850fgb.17
        for <linux-scsi@vger.kernel.org>; Fri, 28 Mar 2008 14:52:20 -0700 (PDT)
In-Reply-To: <200803042324.m24NON8V003087@imap1.linux-foundation.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, crquan@gmail.com, linuxraid@amcc.com

On Tue, Mar 4, 2008 at 3:24 PM,  <akpm@linux-foundation.org> wrote:
> From: Denis Cheng <crquan@gmail.com>
>
>  The memory return from scsi_host_alloc is alloced by kzalloc, which is
>  already zero initilized, so memset not needed.
>
>  Signed-off-by: Denis Cheng <crquan@gmail.com>
>  Cc: Adam Radford <linuxraid@amcc.com>
>  Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>  ---

ACK.... James can you please apply this.

-Adam
