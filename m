From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] zfcp: kfree patch
Date: Sat, 08 Jan 2005 12:44:40 +0100
Message-ID: <1105184681.4196.14.camel@laptopd505.fenrus.org>
References: <20050108103641.GA8018@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:13584 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S261425AbVAHLot (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Jan 2005 06:44:49 -0500
In-Reply-To: <20050108103641.GA8018@osiris.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Greg Kroah-Hartman <greg@kroah.com>

On Sat, 2005-01-08 at 11:36 +0100, Heiko Carstens wrote:
> Hi James,
> 
> this is my next attempt to try to get the patch below merged. Last
> time Greg KH objected and it didn't get merged.
> 
> This patch addresses the following problem: the zfcp device driver
> creates own sysfs objects and therefore has its own release function
> within the zfcp device driver itself. 

would this be solved by using the fc transport class instead, so that
the scsi layer takes care of all this ?


