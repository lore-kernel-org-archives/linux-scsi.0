From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 04/15] qla2xxx: Use msleep() as delay during ISP
	polling.
Date: Sat, 14 Jan 2006 10:48:03 +0100
Message-ID: <1137232084.3014.5.camel@laptopd505.fenrus.org>
References: <11372007004181-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:22693 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751701AbWANJsJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Jan 2006 04:48:09 -0500
In-Reply-To: <11372007004181-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org


> -			udelay(10); /* v4.27 */
> +			msleep(10);

this goes from a 10 microsecond delay to a 10 milisecond delay. Was that
intentional?

