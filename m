From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH 0/8] Open-FCoE fixes for 2.6.30 RC
Date: Fri, 29 May 2009 20:59:44 +0000
Message-ID: <1243630784.2919.57.camel@localhost.localdomain>
References: <20090506175206.26695.19457.stgit@fritz>
	 <273D38FBE7C6FE46A1689FCD014A0B8B55417A17@azsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51598 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751254AbZE2U7n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 May 2009 16:59:43 -0400
In-Reply-To: <273D38FBE7C6FE46A1689FCD014A0B8B55417A17@azsmsx505.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Love, Robert W" <robert.w.love@intel.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2009-05-28 at 15:22 -0700, Love, Robert W wrote:
> Robert Love wrote:
> > The following series implements general fixes to libfc, libfcoe and
> > fcoe. 
> > 
> > Note: One patch adds the FIP ehtertype to if_ether.h. As discussed on
> > netdev, this change was pre-acked and it was requested that the
> > change go through 
> > the SCSI tree.
> > 
> James, aside of the two patches that weren't appropriate for -rc will
> the other 6 in this set be pushed upstream for -rc?

I sort of lost track of which the other 6 were.  If I look at the
patches, the bug fixes seem to be: 1-4 and 7.  Then for non bug fixes: 5
is a lock optimisation, 6 is a watchdog optimisation and 8 is moving
header contents ... and can all wait for the merge window.  Is that
about right?

James


