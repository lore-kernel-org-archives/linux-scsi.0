From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [Bug 85151] pm80xx + 7805H + HP SAS port expander =
 mpi_smp_completion 2604:smp IO status 0x2 and sas: expander ... discovery failed(0xffffffa6)
Date: Fri, 26 Sep 2014 10:33:57 +0200
Message-ID: <CAD+HZHWzHCtf1t8XCfjmkJj=ixkC=rfDTke+y_6RGmGSS2fgVg@mail.gmail.com>
References: <bug-85151-11613@https.bugzilla.kernel.org/>
	<bug-85151-11613-BhGKByrAcE@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:51593 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaIZId6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Sep 2014 04:33:58 -0400
Received: by mail-ie0-f170.google.com with SMTP id x19so12441129ier.1
        for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2014 01:33:57 -0700 (PDT)
In-Reply-To: <bug-85151-11613-BhGKByrAcE@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "pmchba@pmcs.com" <pmchba@pmcs.com>

Cc pmchba maillist.

2014-09-25 18:20 GMT+02:00  <bugzilla-daemon@bugzilla.kernel.org>:
> https://bugzilla.kernel.org/show_bug.cgi?id=85151
>
> --- Comment #6 from Jack Wang <xjtuwjp@gmail.com> ---
> Ah, I forgot no bsg node if expander discover failed:(
> HBA SAS address is 0, does not matter.
>
> From my point, this bug clear SMP protocol related, you could report to PMC, I
> think they will offer help.
>
> --
> You are receiving this mail because:
> You are watching the assignee of the bug.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
