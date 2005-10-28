From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 1/2] libata: MODE SELECT, strengthen mode sense
Date: Fri, 28 Oct 2005 15:59:06 -0400
Message-ID: <4362830A.20704@pobox.com>
References: <435B2C94.2000700@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:37101 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1030325AbVJ1T7K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 15:59:10 -0400
In-Reply-To: <435B2C94.2000700@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, htejun@gmail.com

Douglas Gilbert wrote:
> Patch against libata-dev git tree, upstream branch
> 
> Changelog:
>   - move default mode pages to the front of libata-scsi.c
>     so various functions can access them
>   - partial annotation of these pages, point out divergence
>     from sat-r06
>   - replace various mode page magic numbers with defines
>   - strengthen MODE SENSE command decoding: handle DBD
>     bit in cdb, yield block descriptor (per sat-r06) and
>     handle mode sub pages
> 
> 
> Signed-off-by: Douglas Gilbert <dougg@torque.net>

applied


