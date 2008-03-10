From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 0/2] zfcp fixes
Date: Mon, 10 Mar 2008 10:33:24 -0500
Message-ID: <1205163204.2941.10.camel@localhost.localdomain>
References: <20080310151852.808020000@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39389 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751158AbYCJPd2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Mar 2008 11:33:28 -0400
In-Reply-To: <20080310151852.808020000@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org


On Mon, 2008-03-10 at 16:18 +0100, Christof Schmitt wrote:
> James,
> 
> here are two more fixes for zfcp. They apply on scsi-misc.

scsi-misc is accumulating paches for the next merge window.  If these
are fixes as they seem to be, shouldn't they be going into
scsi-rc-fixes, which is where bug fixes are accumulated for fast onward
transmission?

James


