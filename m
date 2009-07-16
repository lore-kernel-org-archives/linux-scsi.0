From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: deterministic scsi order with async scan
Date: Thu, 16 Jul 2009 22:58:38 +0300
Message-ID: <4A5F866E.3000907@panasas.com>
References: <alpine.DEB.1.10.0907151801040.9159@asgard>  <4A5F100E.9000107@panasas.com> <alpine.DEB.1.10.0907161017180.9159@asgard>  <4A5F723B.7070408@emulex.com>  <alpine.DEB.1.10.0907161143010.9159@asgard> <1247773155.6606.265.camel@mulgrave.site> <alpine.DEB.1.10.0907161245470.9159@asgard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:22379
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933116AbZGPT6k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jul 2009 15:58:40 -0400
In-Reply-To: <alpine.DEB.1.10.0907161245470.9159@asgard>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: david@lang.hm
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, James Smart <James.Smart@Emulex.Com>, linux-kernel <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 07/16/2009 10:48 PM, david@lang.hm wrote:
> 
> so if I don't use udev but do want the async detection my only option to 
> have it boot from card 1 instead of card 2 is to just keep rebooting the 
> machine until it guesses right?
> 

I guess sync detection would be faster then the reboots, on average ;-)

> David Lang
