From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH][SCS] sd: Read Capacity if (16) fails
Date: Wed, 06 Aug 2008 10:36:57 -0700
Message-ID: <1218044217.7493.32.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0808061500450.1109@blonde.site>
	 <yq1d4kmi5hl.fsf@sermon.lab.mkp.net>
	 <Pine.LNX.4.64.0808061629220.10184@blonde.site>
	 <1218040613.7493.13.camel@localhost.localdomain>
	 <1218041582.7493.19.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0808061815360.27392@blonde.site>
	 <yq17iauvylo.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55987 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756008AbYHFRhL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Aug 2008 13:37:11 -0400
In-Reply-To: <yq17iauvylo.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 2008-08-06 at 13:32 -0400, Martin K. Petersen wrote:
> >>>>> "Hugh" == Hugh Dickins <hugh@veritas.com> writes:
> 
> Hugh> Almost: I had to #include <scsi/scsi.h> to get SCSI_2 for the
> Hugh> build somewhere (and a SCSI_2 seems to be worth 1 more than
> Hugh> anyone else's 2), then it worked just fine for me thanks.
> 
> The DIF drives in question claim rev. 3 and are configured correctly
> with James' patch in place.
> 
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

OK, so this is the solution until we get USB devices claiming SCSI-3 and
mucking with the protection bit ...

James


