From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [patch 02/11] scsi/st: replace schedule_timeout() with
 msleep_interruptible()
Date: Mon, 7 Mar 2005 19:17:59 +0200 (EET)
Message-ID: <Pine.LNX.4.61.0503071902290.8824@kai.makisara.local>
References: <20050306222654.47AD71EC90@trashy.coderock.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from fep06-0.kolumbus.fi ([193.229.0.57]:127 "EHLO
	fep06-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261924AbVCGRQp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Mar 2005 12:16:45 -0500
In-Reply-To: <20050306222654.47AD71EC90@trashy.coderock.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: domen@coderock.org
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, nacc@us.ibm.com

On Sun, 6 Mar 2005 domen@coderock.org wrote:

> 
> 
> Use msleep_interruptible() instead of
> schedule_timeout() to guarantee the task delays as expected.
> 
This patch is already in the scsi-misc-2.6 tree merged into one of the st 
patches.

Thanks for the reminder and the patch.

-- 
Kai
