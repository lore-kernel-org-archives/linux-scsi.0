From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 6/10] lpfc 8.2.4 : Add additional sysfs and module
	parameters
Date: Fri, 11 Jan 2008 11:53:11 -0600
Message-ID: <1200073991.3286.43.camel@localhost.localdomain>
References: <1200034389.27954.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49457 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759502AbYAKRxN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jan 2008 12:53:13 -0500
In-Reply-To: <1200034389.27954.25.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Fri, 2008-01-11 at 01:53 -0500, James Smart wrote:
> Made link speed and link topology modifiable via sysfs
> Make scatter gather Segment Count into a module parameter.
> 
> Signed-off-by: James Smart <James.Smart@emulex.com>

OK ... I put this in, but shouldn't at least the link speed and possibly
topology modifications rightly be properties of the transport class?

James


