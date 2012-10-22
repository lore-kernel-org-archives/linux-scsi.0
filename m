From: Roland Dreier <roland@purestorage.com>
Subject: Re: [PATCH 0/2] Fix the qla2xxx loopback selftests
Date: Mon, 22 Oct 2012 08:46:22 -0700
Message-ID: <CAL1RGDXtxmRS=D4vOW5rPEkCcjDxtP8B7EpU1Si1uejMLca2aA@mail.gmail.com>
References: <502a736f.21d4320a.4e09.44cf@mx.google.com> <alpine.WNT.2.00.1208141711460.172@N5102REMCQXM4BS.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog107.obsmtp.com ([74.125.245.82]:33105 "HELO
	na3sys010aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750950Ab2JVPqo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Oct 2012 11:46:44 -0400
Received: by mail-qc0-f198.google.com with SMTP id e13so5298966qcs.1
        for <linux-scsi@vger.kernel.org>; Mon, 22 Oct 2012 08:46:42 -0700 (PDT)
In-Reply-To: <alpine.WNT.2.00.1208141711460.172@N5102REMCQXM4BS.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: "steve@purestorage.com" <steve@purestorage.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dept-Eng Linux Driver <Linux-Driver@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

On Tue, Aug 14, 2012 at 2:15 PM, Chad Dupuis <chad.dupuis@qlogic.com> wrote:
>
>
> On Tue, 14 Aug 2012, steve@purestorage.com wrote:
>
>> From: Steve Hodgson <steve@purestorage.com>
>>
>> A few months ago our 2.6.39 based kernel started crashing almost 100%
>> of the time when running the selftests, after seeminly unrelated kernel
>> changes. In the end it was traced down to this use after free.
>>
>> Whilst here fix an error path memory leak.
>>
>> Thanks,
>>
>> Steve
>>
>> Steve Hodgson (2):
>>  qla2xxx: Fix use after free in qla2x000_process_loopback.
>>  qla2xxx: Free rsp_data even on error in qla2x00_process_loopback()
>>
>> drivers/scsi/qla2xxx/qla_bsg.c |   17 +++++++++--------
>> 1 file changed, 9 insertions(+), 8 deletions(-)
>>
>>
>
> Hi Steve, thanks for the patches. We'll look into them and let you know if
> there is anything extra needed.

Looking at the 3.7-rc code, it looks like the use-after-free is still there.
Any plans on merging these patches?

 - R.
