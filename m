From: Tina Ruchandani <ruchandani.tina@gmail.com>
Subject: Re: [RESEND PATCH] mpt2sas: Remove usage of 'struct timeval'
Date: Fri, 30 Oct 2015 02:19:29 -0700
Message-ID: <CAB__kkm6Pv3J6-nGfi7nwAm7LuNX8Ytco1XHyus6gbVJ0eVixQ@mail.gmail.com>
References: <20151030090515.GA3542@tina-laptop>
	<cc10647b-d628-415b-bf77-4b5344799cbc@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f173.google.com ([209.85.160.173]:33053 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759425AbbJ3JTa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2015 05:19:30 -0400
Received: by ykft191 with SMTP id t191so69429920ykf.0
        for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 02:19:30 -0700 (PDT)
In-Reply-To: <cc10647b-d628-415b-bf77-4b5344799cbc@email.android.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, y2038 <y2038@lists.linaro.org>

> Can you wait a cycle on this? Martin Petersen is on a mission to wrangle the mpt2/3sas merger in this window, which will conflict with this.
>

James,
No issues. Making a note here though that the patches for
mpt2sas_base.c and mpt3sas_base.c are identical, I submitted the
latter before I saw your email.
Tina
