From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: sysfs group not found for kobject on mvsas drive removal
Date: Thu, 7 May 2015 11:25:37 -0700
Message-ID: <CAPcyv4gm7Ss5Bim--=9i_G2J-OmbxmKuMU_zcAJ9pJ8_0Khqjg@mail.gmail.com>
References: <c952e6a1dc4b4badb3b4a55272bfbc48@EX01.lg.local>
	<16adc53b67b247f49bc46ff20a9d55d4@EX01.lg.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38340 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbbEGSZi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2015 14:25:38 -0400
Received: by wiun10 with SMTP id n10so1657841wiu.1
        for <linux-scsi@vger.kernel.org>; Thu, 07 May 2015 11:25:37 -0700 (PDT)
In-Reply-To: <16adc53b67b247f49bc46ff20a9d55d4@EX01.lg.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Praveen Murali <pmurali@logicube.com>
Cc: "James Bottomley (James.Bottomley@HansenPartnership.com)" <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, May 7, 2015 at 11:08 AM, Praveen Murali <pmurali@logicube.com> wrote:
> Hey Guys,
>   Am I on the right track? Or am I missing something?

I'm still paging in my libsas knowledge from slow backing media :).

I wonder if the Intel-isci driver triggers a different ordering on
remove that avoids this...  let me take a look.
