From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 0/4] isci, libsas fixes for 3.4-rc2
Date: Mon, 24 Feb 2014 12:03:38 -0800
Message-ID: <CAA9_cmdhA9=s6PaXb5vzbebSizYoQ6ZrNP3gwz5OeuNgyEL1ew@mail.gmail.com>
References: <20140206202151.5227.12582.stgit@viggo.jf.intel.com>
	<1393186369.9743.4.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:44603 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbaBXUDj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Feb 2014 15:03:39 -0500
Received: by mail-qc0-f171.google.com with SMTP id x13so1916254qcv.16
        for <linux-scsi@vger.kernel.org>; Mon, 24 Feb 2014 12:03:38 -0800 (PST)
In-Reply-To: <1393186369.9743.4.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, artur.paszkiewicz@intel.com, "dave.jiang" <dave.jiang@intel.com>, Lukasz Dorau <lukasz.dorau@intel.com>

On Sun, Feb 23, 2014 at 12:12 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> On Thu, 2014-02-06 at 12:22 -0800, Dan Williams wrote:
>> Hi James,
>>
>> Here are some collected fixes.  All but patch 2 are tagged for -stable.
>>
>> Patch 1 and 4 have been on the list since before the 3.14 merge window,
>> patch 2 and 3 are new.
>>
>> Please apply, thank you.
>>
>> [PATCH 1/4] isci: fix reset timeout handling
>> [PATCH 2/4] scsi, libsas: introduce scmd_dbg() to quiet false positive "timeout" messages
>> [PATCH 3/4] isci: fix needless ata reset escalations
>> [PATCH 4/4] isci: correct erroneous for_each_isci_host macro
>
> 2,3 aren't really bug fixes; they're more enhancements (they make the
> behaviour better but nothing breaks without them), so I'll queue 1,4 for
> fixes and 2-3 for misc.

Ok.

Also Joe's patch while you're in the area:
http://marc.info/?l=linux-scsi&m=138609455422179&w=2

I acked it, but it shows some additional work needed for registration
error paths in scsi_transport_sas.
