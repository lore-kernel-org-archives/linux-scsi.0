From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Block layer: separate out queue-oriented ioctls Re:
	[PATCH] Block layer: separate out queue-oriented ioctls
Date: Mon, 02 Apr 2007 09:34:57 -0500
Message-ID: <1175524497.3680.0.camel@mulgrave.il.steeleye.com>
References: <200704020828.l328SICc009264@burner.fokus.fraunhofer.de>
	 <Pine.LNX.4.44L0.0704020951180.1743-100000@netrider.rowland.org>
	 <20070402142318.GA14256@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:58677 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965509AbXDBOhV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2007 10:37:21 -0400
In-Reply-To: <20070402142318.GA14256@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Joerg Schilling <schilling@fokus.fraunhofer.de>, dougg@torque.net, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>

On Mon, 2007-04-02 at 16:23 +0200, Jens Axboe wrote:
> FWIW, it had my ack, I think we were just waiting for Doug to ack the sg
> bits.

And there's really nothing I can do (well, except write the thing) since
the changes are not in any SCSI pieces I maintain directly ... they're
block and sg.

James


