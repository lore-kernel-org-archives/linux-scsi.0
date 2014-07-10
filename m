From: Janusz Dziemidowicz <rraptorr@nails.eu.org>
Subject: Re: [Bug 79901] New: Extremely slow boot on Promise VTrak E610f due
 to sd_mod RSOC usage
Date: Thu, 10 Jul 2014 16:10:09 +0200
Message-ID: <CAO3mW-O3XeobS7zP21fJDDUejGCYQN9PD8opv9wL6tjFq7p9Cg@mail.gmail.com>
References: <bug-79901-11613@https.bugzilla.kernel.org/>
	<20140710135415.GA1621@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:53000 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaGJOKK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2014 10:10:10 -0400
Received: by mail-qc0-f178.google.com with SMTP id i17so3605918qcy.9
        for <linux-scsi@vger.kernel.org>; Thu, 10 Jul 2014 07:10:09 -0700 (PDT)
In-Reply-To: <20140710135415.GA1621@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

2014-07-10 15:54 GMT+02:00 Christoph Hellwig <hch@infradead.org>:
> Sounds like we need to skip REPORT SUPPORTED OPERATION CODES on this
> array.
>
> For this it needs a new BLIST_NORSOC flag added to
> include/scsi/scsi_devinfo.h which sets sdev->no_report_opcodes in
> scsi_add_lun, and an entry for your array in the big black list array in
> drivers/scsi/scsi_devinfo.c.  Does this sound easy enough that you could
> prepare a patch for it?

Sure, I'll give it a try. It will probably take a couple of days as
currently I have only one server that is available for experiments for
a few hours a day.

-- 
Janusz Dziemidowicz
