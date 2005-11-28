From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 10/11]  lpfc 8.1.1 : Added code to adjust lun queue
	depth to avoid target overloading
Date: Mon, 28 Nov 2005 18:36:03 +0100
Message-ID: <1133199363.2824.55.camel@laptopd505.fenrus.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C4E@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:4331 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750719AbVK1RgG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 12:36:06 -0500
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C4E@xbl3.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Mon, 2005-11-28 at 11:42 -0500, James.Smart@Emulex.Com wrote:
> Added code to adjust lun queue depth to avoid target overloading.
> 

eh isn't this a midlayer task? eg on queue full... auto shrink the
queue ? why would a driver need to bother with this?

