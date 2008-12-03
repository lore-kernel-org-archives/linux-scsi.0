From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] ibmvfc: Delay NPIV login retry and add retries
Date: Wed, 03 Dec 2008 11:38:21 -0600
Message-ID: <1228325901.5551.31.camel@localhost.localdomain>
References: <200812031703.mB3H3cMT027696@d03av04.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60995 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751254AbYLCRiT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2008 12:38:19 -0500
In-Reply-To: <200812031703.mB3H3cMT027696@d03av04.boulder.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2008-12-03 at 11:02 -0600, Brian King wrote:
> Adds a delay prior to retrying a failed NPIV login. This fixes
> a scenario if the backing fibre channel adapter is getting reset
> due to an EEH event, NPIV login will fail. Currently, ibmvfc
> retries three times very quickly, resets the CRQ and tries one
> more time. If the adapter is getting reset due to EEH, this isn't
> enough time. This adds a delay prior to retrying a failed NPIV
> login and also increments the number of retries.

Are these for 2.6.28 or 2.6.29?  The descriptions make them sound like
2.6.28 bug fixes.

James


