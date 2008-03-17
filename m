From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [patch] convert the scsi layer to use struct device
Date: Mon, 17 Mar 2008 08:18:32 -0400
Message-ID: <47DE6198.5070602@emulex.com>
References: <1205514958.2904.27.camel@localhost.localdomain> <1205529619.2904.87.camel@localhost.localdomain> <1205531922.3522.57.camel@lov.site> <1205590788.6767.12.camel@localhost.localdomain> <1205594256.3109.53.camel@lov.site> <1205597776.6767.40.camel@localhost.localdomain> <1205604260.3109.133.camel@lov.site> <47DD8139.1040802@emulex.com> <1205701470.11374.66.camel@lov.site> <47DDF05D.8060608@emulex.com> <20080317053519.GB5229@kroah.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:53448 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbYCQMSn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Mar 2008 08:18:43 -0400
In-Reply-To: <20080317053519.GB5229@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Tony Jones <tonyj@suse.de>

Greg KH wrote:
> I take it you haven't even looked at how !SYSFS_DEPRECATED works today,
> have you?  Try it and you will see that the namespace issue has been
> taken care of a long time ago :)

You are right...   but I would assume it can be answered without pushing
someone back into the internals of the code to figure it out.

-- james s
