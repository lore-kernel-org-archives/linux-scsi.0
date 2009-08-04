From: Madhukar G <madhukar.linux@gmail.com>
Subject: Re: Re: Understanding SAS
Date: Tue, 4 Aug 2009 11:58:02 +0530
Message-ID: <e79524560908032328s4b71ff6fn30c66ebcdf60f4a6@mail.gmail.com>
References: <e79524560907310456x7b2cf0c0h7e0453ceb55982fd@mail.gmail.com>
	 <1249050405.3922.11.camel@mulgrave.site>
	 <200908010930500463303@usish.com>
	 <e79524560907312238u53517348sf9b6b118b9066eb2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:35492 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428AbZHDG2E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2009 02:28:04 -0400
Received: by gxk9 with SMTP id 9so6556953gxk.13
        for <linux-scsi@vger.kernel.org>; Mon, 03 Aug 2009 23:28:03 -0700 (PDT)
In-Reply-To: <e79524560907312238u53517348sf9b6b118b9066eb2@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wang Jinpu <jack_wang@usish.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

> Thank you for the reply. Is there any way i can test this sequence. I
> would like to explicitly set SAS_TASK_STATE_ABORTED and further
> invoking error handlers.
>

Does this mean that i do not require any application to invoke error
handlers (task frames / task IU).

Thanks.
madhukar
