From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: mptspi dv problems
Date: Fri, 17 Nov 2006 09:39:04 -0600
Message-ID: <1163777944.8594.21.camel@mulgrave.il.steeleye.com>
References: <1159378627.21628.37.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:9160 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1424796AbWKQPjT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Nov 2006 10:39:19 -0500
In-Reply-To: <1159378627.21628.37.camel@markh3.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: "Moore, Eric" <Eric.Moore@lsil.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2006-09-27 at 10:37 -0700, Mark Haverkamp wrote:
> The recent dv changes to scsi_transport_spi.c have fixed the problems
> that I had with my U160 drives being set to async/narrow but there are
> still problems with my U320 drive causing indefinite dv on my system.

Can I get dial in access to this system to play with it.  I can't
reproduce this here, so I'd like to play with a system which actually
shows the problem.

James


