From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH][SCS] sd: Read Capacity if (16) fails
Date: Wed, 06 Aug 2008 09:36:53 -0700
Message-ID: <1218040613.7493.13.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0808061500450.1109@blonde.site>
	 <yq1d4kmi5hl.fsf@sermon.lab.mkp.net>
	 <Pine.LNX.4.64.0808061629220.10184@blonde.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40818 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754837AbYHFQhD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Aug 2008 12:37:03 -0400
In-Reply-To: <Pine.LNX.4.64.0808061629220.10184@blonde.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hugh Dickins <hugh@veritas.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 2008-08-06 at 16:34 +0100, Hugh Dickins wrote:
>   PQual=0  Device_type=0  RMB=1  version=0x00  [no conformance
> claimed]

We could try using this as the trigger.  I assume all DIF supporting
devices must also claim conformance to SPC3/SBC2 or higher?

James


