From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [patch 0/2] zfcp fixes
Date: Mon, 10 Mar 2008 17:26:43 +0100
Message-ID: <20080310162642.GA18110@schmichrtp.de.ibm.com>
References: <20080310151852.808020000@de.ibm.com> <1205163204.2941.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:37652 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbYCJQ0r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Mar 2008 12:26:47 -0400
Content-Disposition: inline
In-Reply-To: <1205163204.2941.10.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

On Mon, Mar 10, 2008 at 10:33:24AM -0500, James Bottomley wrote:
> scsi-misc is accumulating paches for the next merge window.  If these
> are fixes as they seem to be, shouldn't they be going into
> scsi-rc-fixes, which is where bug fixes are accumulated for fast onward
> transmission?

These fixes are not critical. The one for the ERP thread was found
during code cleanup, and i am not sure if it is possible to trigger
the bug. The other one improves the error recovery behaviour, so that
in this special case there are less actions necessary.

In short: They fit scsi-misc better than the important fixes in
scsi-rc. When there are critical zfcp fixes, i will send them for
scsi-rc.

Christof
