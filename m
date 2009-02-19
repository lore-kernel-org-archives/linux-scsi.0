From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: libfc add missing braces to in WARN_ON
Date: Thu, 19 Feb 2009 19:53:16 +0000
Message-ID: <1235073196.12500.37.camel@localhost.localdomain>
References: <1235072152.4377.4.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55539 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753628AbZBSTxT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Feb 2009 14:53:19 -0500
In-Reply-To: <1235072152.4377.4.camel@brick>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2009-02-19 at 11:35 -0800, Harvey Harrison wrote:
> Noticed by sparse:
> drivers/scsi/libfc/fc_exch.c:286:3: warning: dubious: !x & y

Thanks for finding this, but the patch is already queued here:

http://marc.info/?l=linux-scsi&m=123378225922727

James


