From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH v3 9/18] megaraid_sas : Support for Avago's Single server
 High Availability product
Date: Mon, 11 May 2015 15:10:56 +0530
Message-ID: <0b14766f13fa5bd085122e7abcb690b3@mail.gmail.com>
References: <201504231104.t3NB4P3F030217@palmhbs0.lsi.com> <20150511091948.GH28820@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:35112 "EHLO
	mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbbEKJk6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2015 05:40:58 -0400
Received: by qkhg7 with SMTP id g7so82850471qkh.2
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2015 02:40:57 -0700 (PDT)
In-Reply-To: <20150511091948.GH28820@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>

>-----Original Message-----
>From: Christoph Hellwig [mailto:hch@infradead.org]
>Sent: Monday, May 11, 2015 2:50 PM
>To: Sumit.Saxena@avagotech.com
>Cc: linux-scsi@vger.kernel.org; thenzl@redhat.com;
>martin.petersen@oracle.com; jbottomley@parallels.com;
>kashyap.desai@avagotech.com
>Subject: Re: [PATCH v3 9/18] megaraid_sas : Support for Avago's Single
server
>High Availability product
>
>Did you test this on non-x86?  It seems like the dmi functions are
properly
>stubbed out, but I'd really prefer an explicit statement that it is known
to
>work.

SSHA feature is limited to x86 platform only. This code is tested for non
x86 platforms(tested on PPC). We don't need buffer returned by
"dmi_get_system_info()" on non x86 platforms as we don't support SSHA for
non x86 platforms.
