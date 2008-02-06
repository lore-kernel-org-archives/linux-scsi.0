From: Daniel Drake <dsd@gentoo.org>
Subject: Re: [PATCH] sr: update to follow tray status correctly
Date: Wed, 06 Feb 2008 20:54:20 +0000
Message-ID: <47AA1E7C.9080205@gentoo.org>
References: <20071027225830.585C8657DB@smtp.gentoo.org>	 <1193801523.3321.138.camel@localhost.localdomain>	 <1199551191.3399.29.camel@localhost.localdomain>	 <47A9E9C6.4000802@gentoo.org> <1202324518.3112.104.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tranquility.mcc.ac.uk ([130.88.200.145]:57009 "EHLO
	tranquility.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757247AbYBFUzH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Feb 2008 15:55:07 -0500
In-Reply-To: <1202324518.3112.104.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Maarten Bressers <mbres@gentoo.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@kernel.dk

James Bottomley wrote:
> However, I think you're right, the vanilla TUR does eat NOT_READY for
> removable media, which CDs are.  Does this fix it?

Works great, thanks!

Daniel
