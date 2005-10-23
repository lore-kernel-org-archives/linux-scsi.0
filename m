From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH RFC] yet more struct scsi_lun
Date: Sun, 23 Oct 2005 12:44:24 -0400
Message-ID: <435BBDE8.5080603@pobox.com>
References: <20051023043301.GA22615@havoc.gtf.org>	 <20051023070011.GA26569@havoc.gtf.org>  <435B6A62.8070306@torque.net> <1130068390.2775.6.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:63938 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1750769AbVJWQo3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Oct 2005 12:44:29 -0400
In-Reply-To: <1130068390.2775.6.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

Arjan van de Ven wrote:
> this is a bit of a problem since we don't know all the limits. We do
> know that Microsoft Windows at least used to have a 64Kb limit, and that
> that limit is "safe" in the sense that all hw was tested/designed for
> that. So setting the default safe, and overriding it per driver sounds
> best. It only really matters for a handful of drivers anyway, and those
> either already set something or ought to.

It's more a VM thing.  Default is 512K (1024 sectors).

	Jeff


