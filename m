From: Madhavi Manchala <madhavi.lscsi@gmail.com>
Subject: Re: Bidirectional data transfers from SCSI layer
Date: Tue, 18 Aug 2009 16:05:02 +0530
Message-ID: <97a757510908180335u5c5f85b3r7d235440ba83c2cd@mail.gmail.com>
References: <97a757510908172322y7a42df80n5bf7f21fbca16e13@mail.gmail.com>
	 <4A8A608D.9000909@panasas.com>
	 <97a757510908180203h7c10c63fx19f436e72de25c5@mail.gmail.com>
	 <4A8A7BB4.90102@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-px0-f196.google.com ([209.85.216.196]:54470 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbZHRKfA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 06:35:00 -0400
Received: by pxi34 with SMTP id 34so1729890pxi.4
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2009 03:35:02 -0700 (PDT)
In-Reply-To: <4A8A7BB4.90102@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Aug 18, 2009 at 3:30 PM, Boaz Harrosh<bharrosh@panasas.com> wrote:

Dear Boaz,

Thanks a lot.

>> Do I need to modify the SCSI driver files to handle  the
>> bi-directional comamnds or Is this already supported?
>>
>
> Yes only very few drivers support bidi commands.
> i.e. iscsi is the only one that supports them in general.

Currently, I am registering my driver to the SCSI layer. Now I
understand, I need to register my driver to iscsi to get
bi-directional commands. If this is the case, how can I register my
driver to iscsi driver to get bi-directional commands, and will I get
the same functionality from iscsi as I am currently getting from scsi.

> (Tell me if you need example code for bsg use in user-mode).

Could you please send me the link to the user mode bsg initiator code
which issues the bi-directional commands?

>> I found only one struct scsi_data_buffer pointer in scsi_cmnd
>> structure. So, how do SCSI layer sends IN and OUT buffer pointers and
>> their lengths to my class driver?
>>
>
> Again:
>        if (scsi_bidi_cmnd(cmnd)) {
>                in_sdb = scsi_in(cmnd);
>                out_sdb = scsi_out(cmnd);
>        }
> It works, look at the code.

Before using the above snippet in my class driver, do I need to fill
in_req and out_req in SCSI layer or Is it already filled? If I use the
iscsi driver, then there is no need to do any modifications to the
in_req and out_req.

Thanks and Regards,
Madhavi M.
