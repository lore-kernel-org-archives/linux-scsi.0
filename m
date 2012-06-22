From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v1] Fix sector number translation in sense buffer for SATA drives
Date: Thu, 21 Jun 2012 22:41:04 -0700
Message-ID: <CABE8wwvwuwi9aAc63fh-Gx9GdH45_5WTbMN8qUSEzZfyKg6EQg@mail.gmail.com>
References: <1340322136.3712.61.camel@praveen-debian.lg.local>
	<CAA9_cmf-aufpXarLc5_NNzKs-LM39hYYxP-2RP7rWTf1o0p6Mg@mail.gmail.com>
	<1340324637.3712.67.camel@praveen-debian.lg.local>
	<CABE8wws6w0uWhskDJZPuKr3S1_qwo8M1vy-q8CuvJs=C1BRs2A@mail.gmail.com>
	<33E83F701EA663469FEBA23868D25955026B43DA@lgsbs.lg.local>
	<1340338888.13003.9.camel@dwillia2-mobl>
	<33E83F701EA663469FEBA23868D25955026B43DB@lgsbs.lg.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:39737 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761181Ab2FVFlH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jun 2012 01:41:07 -0400
Received: by bkcjc3 with SMTP id jc3so1110081bkc.25
        for <linux-scsi@vger.kernel.org>; Thu, 21 Jun 2012 22:41:04 -0700 (PDT)
In-Reply-To: <33E83F701EA663469FEBA23868D25955026B43DB@lgsbs.lg.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Praveen Murali <pmurali@logicube.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Jun 21, 2012 at 10:27 PM, Praveen Murali <pmurali@logicube.com> wrote:
> agreed, this looks way more cleaner. can you please commit these changes?
>

Sure I can push this, can you test it out to make sure it fixes your
failing case?  Then I'll push it with your reported-by and tested-by.

Much appreciated.

--
Dan
