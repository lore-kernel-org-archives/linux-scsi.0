From: Jes Sorensen <jes@wildopensource.com>
Subject: Re: [PATCH] qla1280.c patch against 2.6.9 to allow settings of Initiator ID
Date: 30 Nov 2004 05:19:39 -0500
Message-ID: <yq0is7n63lw.fsf@jaguar.mkp.net>
References: <20041105011830.GG8974@dragonhold.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vanessarodrigues.com ([192.139.46.150]:16259 "EHLO
	jaguar.mkp.net") by vger.kernel.org with ESMTP id S262025AbUK3KTk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2004 05:19:40 -0500
In-Reply-To: <20041105011830.GG8974@dragonhold.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux@dragonhold.org
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

>>>>> "Graham" == linux  <linux@dragonhold.org> writes:

Graham> I'm also not sure if this is the sort of thing that anyone
Graham> other than me would be interested in, and I can't find a
Graham> maintainer specifically for the qla1280 driver.  So please
Graham> accept my apologies if this shouldn't have been sent to you.

Graham> It's the first I've done, so I'm more than willing to listen
Graham> to suggestions on how to improve the style and/or code.

Graham,

What would be the reasoning for this patch? If this was something that
should supported by drivers, it ought to be set using an API at a
higher level rather than by the individual drivers IMHO.

Cheers,
Jes
