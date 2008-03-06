From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [0/21] Remove isa_unchecked_dma and some more GFP_DMAs in the mid layer v2 II
Date: Thu, 6 Mar 2008 23:23:18 +0100
Message-ID: <20080306222318.GD31833@one.firstfloor.org>
References: <20080306951.147874949@firstfloor.org> <1204841607.3062.67.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:41560 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbYCFWVs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 17:21:48 -0500
Content-Disposition: inline
In-Reply-To: <1204841607.3062.67.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-scsi@vger.kernel.org, axboe@kernel.dk


Or on further thought you're probably right it is best to just continue
using a bit here. 

-Andi
