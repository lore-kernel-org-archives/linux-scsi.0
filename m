From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: [PATCH][BUGFIX] : megaraid patch for 2.10.1 (irq disable bug
	fix)
Date: 24 Feb 2004 09:06:43 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077635204.2152.16.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC3D9@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:27576 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262269AbUBXPGz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2004 10:06:55 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BC3D9@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: 'Paul Wagland' <paul@wagland.net>, Matthew Wilcox <willy@debian.org>, "Bagalkote, Sreenivas" <sreenib@lsil.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Tue, 2004-02-24 at 08:47, Mukker, Atul wrote:
> We are in process of releasing a unified driver, which will natively support
> the 2.4.x and 2.6.x kernels. 

I really don't think this will be such a good idea since you don't
currently have a unified driver.  2.4 is approaching end of life as far
as major driver updates go and the 2.6 APIs are quite a bit different. 
You'll find it's a lot of work for a driver that will carry you at most
six months before the distributions all switch to 2.6 and you find the
2.4 compatibility layer to be more of a hindrance than a help.

James


