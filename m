From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH][2.6.8-rc1-mm1] drivers/scsi/sg.c gcc341 inlining fix
Date: Wed, 14 Jul 2004 14:36:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40F57D14.9030005@pobox.com>
References: <200407141751.i6EHprhf009045@harpo.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:38854 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267502AbUGNSgR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jul 2004 14:36:17 -0400
In-Reply-To: <200407141751.i6EHprhf009045@harpo.it.uu.se>
List-Id: linux-scsi@vger.kernel.org
To: Mikael Pettersson <mikpe@csd.uu.se>
Cc: B.Zolnierkiewicz@elka.pw.edu.pl, akpm@osdl.org, dgilbert@interlog.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Mikael Pettersson wrote:
> It's needed, and no it's not a compiler bug.

In fact, it is.  gcc isn't properly inlining functions where uses occur 
before implementation of the inlined function.

Or you could just call it "gcc is dumb" rather than a compiler bug.

	Jeff


