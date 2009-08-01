From: Madhukar G <madhukar.linux@gmail.com>
Subject: Re: Re: Understanding SAS
Date: Sat, 1 Aug 2009 11:08:00 +0530
Message-ID: <e79524560907312238u53517348sf9b6b118b9066eb2@mail.gmail.com>
References: <e79524560907310456x7b2cf0c0h7e0453ceb55982fd@mail.gmail.com>
	 <1249050405.3922.11.camel@mulgrave.site>
	 <200908010930500463303@usish.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:61336 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbZHAFiB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Aug 2009 01:38:01 -0400
Received: by gxk9 with SMTP id 9so4399640gxk.13
        for <linux-scsi@vger.kernel.org>; Fri, 31 Jul 2009 22:38:00 -0700 (PDT)
In-Reply-To: <200908010930500463303@usish.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wang Jinpu <jack_wang@usish.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

> If you look into the libsas source you will find that lldd_abort_task will
> be
> called when task flag is set to SAS_TASK_STATE_ABORTED ,that means the
> task is timeout by sas layer, then sas layer will abort it. other other case
> are
> during error recovery, when scsi ml scsi_error_handler is scheduled to run.
>

Thank you for the reply. Is there any way i can test this sequence. I
would like to explicitly set SAS_TASK_STATE_ABORTED and further
invoking error handlers.

Thanks and Regards,
madhukar
