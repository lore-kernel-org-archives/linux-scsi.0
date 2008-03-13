From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] export command allocation and freeing functions independently of the host
Date: Thu, 13 Mar 2008 22:44:02 +0100
Message-ID: <20080313214402.GI2522@one.firstfloor.org>
References: <1205427224.2893.23.camel@localhost.localdomain> <47D95EAC.2020301@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:37361 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264AbYCMVl4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Mar 2008 17:41:56 -0400
Content-Disposition: inline
In-Reply-To: <47D95EAC.2020301@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andi Kleen <andi@firstfloor.org>

On Thu, Mar 13, 2008 at 07:04:44PM +0200, Boaz Harrosh wrote:
> On Thu, Mar 13 2008 at 18:53 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > This is needed by things like USB storage that want to set up static
> > commands for later use at start of day.

So what's up with applying my patchkit? You rewriting part of code
that it touches.

I don't think there is anything controversal in there anymore.

-Andi
