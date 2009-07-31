From: Madhukar G <madhukar.linux@gmail.com>
Subject: Re: Understanding SAS
Date: Sat, 1 Aug 2009 00:00:59 +0530
Message-ID: <e79524560907311130j7b58c0ewb77f298f574f9b5a@mail.gmail.com>
References: <e79524560907310456x7b2cf0c0h7e0453ceb55982fd@mail.gmail.com>
	 <1249050405.3922.11.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:60046 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbZGaSbA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2009 14:31:00 -0400
Received: by gxk9 with SMTP id 9so3982649gxk.13
        for <linux-scsi@vger.kernel.org>; Fri, 31 Jul 2009 11:31:00 -0700 (PDT)
In-Reply-To: <1249050405.3922.11.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

> However, SAM task management functions all map to the callbacks in
> struct sas_domain_function_template which are called by libsas. =A0Th=
ese
> callbacks are also used for all other frame error handling.
>

I understand the callbacks used for error handling. For which types of
errors these callbacks invoked? When do these error occur? Which layer
is responsible for invoking these callback.. Is it SCSI layer/ File
System or Application Client?

Pardon me if these questions sounds silly. but i'm in process of
understading the sequence.

I tried copying data to and from SAS controller and aborted in
between. But i donot see any error handlers being invoked.

Thanks and Regards,
madhukar
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
