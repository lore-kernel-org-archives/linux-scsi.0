From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/2 v4] scsi: ufs: introduce sysfs entries exposing UFS
 health info
Date: Thu, 21 Dec 2017 08:59:35 +0100
Message-ID: <20171221075935.GB9645@kroah.com>
References: <20171220191631.50329-1-jaegeuk@kernel.org>
 <20171220191631.50329-2-jaegeuk@kernel.org>
 <20171220221325.GA56741@jaegeuk-macbookpro.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39034 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751366AbdLUH7e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Dec 2017 02:59:34 -0500
Content-Disposition: inline
In-Reply-To: <20171220221325.GA56741@jaegeuk-macbookpro.roam.corp.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@google.com>

On Wed, Dec 20, 2017 at 02:13:25PM -0800, Jaegeuk Kim wrote:
> This patch adds a new sysfs group, namely health, via:
> 
>    /sys/devices/soc/X.ufshc/health/
> 
> This directory contains the below entries, each of which shows an 8-bytes
> hex number representing different meanings defined by JEDEC specfication.
> 
> Users can simply read these entries to check how their underlying flash
> storage is getting reached out to its end of life. For example, if
> lifetimeA shows 0xb, it would be the right time to consider device swap.
> 
>  - length
>    : must be 25h
> 
>  - type
>    : must be 09h
> 
>  - eol
>    00h: Not defined
>    01h: Normal
>    02h: Warning
>    03h: Critical
> 
>  - lifetimeA/B
>    00h: Not defined
>    01h:  0% ~ 10% device life time used
>    02h: 10% ~ 20% device life time used
>    03h: 20% ~ 30% device life time used
>    04h: 30% ~ 40% device life time used
>    05h: 40% ~ 50% device life time used
>    06h: 50% ~ 60% device life time used
>    07h: 60% ~ 70% device life time used
>    08h: 70% ~ 80% device life time used
>    09h: 80% ~ 90% device life time used
>    0Ah: 90% ~ 100% device life time used
>    0Bh: Exceeded its maximum estimated device life time
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
> ---

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
