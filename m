From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] mvsas: fixed timeout issue when removing module
Date: Fri, 22 Feb 2013 11:19:59 +0000
Message-ID: <1361531999.2372.32.camel@dabdike.int.hansenpartnership.com>
References: <1359476753-19361-1-git-send-email-yxlraid@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41479 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754534Ab3BVLUC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Feb 2013 06:20:02 -0500
In-Reply-To: <1359476753-19361-1-git-send-email-yxlraid@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: yxlraid@gmail.com
Cc: linux-scsi@vger.kernel.org, Xiangliang Yu <yuxiangl@marvell.com>

On Wed, 2013-01-30 at 00:25 +0800, yxlraid@gmail.com wrote:
> From: Xiangliang Yu <yuxiangl@marvell.com>
> 
> - Root cause is libsas will clear asd_sas_port
>   phy_mask value in sas_port_deform after triggering
>   destruct workqueue, but the workqueue will send
>   sync cmd and still need phy_mask value.
>   Now, mvsas using asd_sas_phy setting instead of
>   asd_sas_port setting.
> ---

Signed-off-by missing ... please don't forget next time.

James


