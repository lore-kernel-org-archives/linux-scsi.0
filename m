From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PROBLEM] aic7xxx: DV failed to configure device
Date: Mon, 06 Jun 2005 10:19:45 +0200
Message-ID: <1118045986.5652.21.camel@laptopd505.fenrus.org>
References: <20050606141638.A28532@ward.six>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:28622 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261219AbVFFITy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jun 2005 04:19:54 -0400
In-Reply-To: <20050606141638.A28532@ward.six>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Denis Zaitsev <zzz@anda.ru>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 2005-06-06 at 14:16 +0600, Denis Zaitsev wrote:
> I'm testing an Adaptec SCSI controller + an IBM drive.  All the things
> used to be fine before I had made the low-level format of the drive
> (thru the Ctrl-A Adaptec's menu).  And now after
> 
>         modprobe aic7xxx


you failed to mention which exact kernel you were using...
(that matters since the aic7xxx driver changes a lot over time, and
especially it changed recently in this area a lot)

