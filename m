From: Madhavi Manchala <madhavi.lscsi@gmail.com>
Subject: Re: Bidirectional data transfers from SCSI layer
Date: Tue, 18 Aug 2009 19:12:11 +0530
Message-ID: <97a757510908180642l48966e58g7c7705d2df60ccbc@mail.gmail.com>
References: <97a757510908172322y7a42df80n5bf7f21fbca16e13@mail.gmail.com>
	 <4A8A608D.9000909@panasas.com>
	 <97a757510908180203h7c10c63fx19f436e72de25c5@mail.gmail.com>
	 <4A8A7BB4.90102@panasas.com>
	 <97a757510908180335u5c5f85b3r7d235440ba83c2cd@mail.gmail.com>
	 <4A8A94A3.9010802@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-px0-f196.google.com ([209.85.216.196]:35803 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbZHRNmM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 09:42:12 -0400
Received: by pxi34 with SMTP id 34so1802098pxi.4
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2009 06:42:14 -0700 (PDT)
In-Reply-To: <4A8A94A3.9010802@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Aug 18, 2009 at 5:16 PM, Boaz Harrosh<bharrosh@panasas.com> wrote:

Dear Boaz,

Thanks again for the information.

> No!. You miss understood. iscsi is just a scsi LLD (Low Level Driver)
> just as usb/storage/scsiglue.c is an LLD. You only register with scsi.
>
> scsi-ml has full support for bidi. Only the LLDs do not. except two
> LLDs: iscsi and scsi_debug.

I guess, iscsi you are referring to is nothing but
drivers/scsi/iscsi_tcp.c. If so, do I need to modify
drivers/usb/storage/scsiglue.c file in a way to handle bidirectional
commands. The reference code for the modification is iscsi_tcp.c file.

Please let me know whether my assumption is correct or not.

Thanks and Regards,
Madhavi M.
