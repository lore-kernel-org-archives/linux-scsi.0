From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: simplify creation and destruction of driver
 attribute files
Date: Sun, 03 Nov 2013 14:10:41 -0500
Message-ID: <52769FB1.7010409@interlog.com>
References: <1381758484-26083-1-git-send-email-akinobu.mita@gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:35585 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210Ab3KCTKt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 Nov 2013 14:10:49 -0500
In-Reply-To: <1381758484-26083-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 13-10-14 09:48 AM, Akinobu Mita wrote:
> Instead of repeatedly calling driver_create_file() to create driver
> attribute files, This achieves the same thing by constructing an array
> of driver_attribute and setting it to bus_type->drv_groups.
>
> This change simplifies both creation and destruction of the attribute
> files, and also removes sparse warning caused by driver_attributes which
> are unnecessarily declared as global.
>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org

<snip>

