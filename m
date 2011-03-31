From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/2] isci: remove base_request abstraction
Date: Thu, 31 Mar 2011 15:14:14 -0700
Message-ID: <AANLkTinTFY69L67u2qZpyUWmDOqGFy7ePMdwb2dVWFKi@mail.gmail.com>
References: <20110328000754.GA28347@infradead.org>
	<20110328132046.GA497@infradead.org>
	<20110328132114.GB11684@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49235 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab1CaWQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2011 18:16:16 -0400
Received: by fxm17 with SMTP id 17so2208341fxm.19
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2011 15:16:15 -0700 (PDT)
In-Reply-To: <20110328132114.GB11684@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On Mon, Mar 28, 2011 at 6:21 AM, Christoph Hellwig <hch@infradead.org> =
wrote:
> Merge struct sci_base_request into scic_sds_request, and also factor =
the two
> types of state machine handlers into one function. =A0While we're at =
it also
> remove lots of duplicate incorrect kerneldoc comments for the state m=
achine
> handlers.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>

Applied, thanks.

We'll want to do a tree-wide s/sci_base_/sci_/, but maybe not until we
settle on the final unified object names... put it off for now.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
