From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/7] print eh activation
Date: Wed, 26 Nov 2008 12:47:02 -0600
Message-ID: <1227725222.3387.19.camel@localhost.localdomain>
References: <200811261840.45360.bs@q-leap.de>
	 <200811261844.02732.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44032 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154AbYKZSrI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2008 13:47:08 -0500
In-Reply-To: <200811261844.02732.bs@q-leap.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Cc: linux-scsi@vger.kernel.org

On Wed, 2008-11-26 at 18:44 +0100, Bernd Schubert wrote:
> Print activation of the scsi error handler to let the user know what was 
> the the error handler was activated. These information are essential to
> diagnose hardware issues.

But it can be turned on already with SCSI logging ... at least the
activation message.  I don't think we want this to be printed all the
time, because the error handler can be activated in non-error situations
for some HBAs (like sense collection for non-ACA emulating drivers).

James


