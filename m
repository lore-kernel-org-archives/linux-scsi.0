From: Thomas Babut <thomas@babut.net>
Subject: Re: Kernel 2.6.x hangs with Symbios Logic 53c1010 Ultra3 SCSI	Adapter
Date: Tue, 23 Nov 2004 02:39:17 +0100
Message-ID: <41A294C5.8040702@babut.net>
References: <04Nov8.094419est.332239@cyborg.cybernetics.com> <1099928314.10944.81.camel@compaq-rhel4.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tueddeln.de ([213.202.245.13]:46037 "EHLO srv.specialhosting.de")
	by vger.kernel.org with ESMTP id S262523AbUKWBjT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Nov 2004 20:39:19 -0500
In-Reply-To: <1099928314.10944.81.camel@compaq-rhel4.xsintricity.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Would it be possible to integrate the sym53c8xx (1, not sym53c8xx_2) 
driver from Kernel 2.4.28 in 2.6? For me it would be the working 
solution to use my SCSI-Controller with Kernel 2.6.

Perhaps someone could make a patch for Kernel 2.6 which adds the old driver.

Thanks.

Regards,
Thomas Babut
