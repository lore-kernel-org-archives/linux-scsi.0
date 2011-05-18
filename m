From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: TCM/LIO ib_srpt testing
Date: Wed, 18 May 2011 19:05:41 +0200
Message-ID: <BANLkTi=dT=SWvZP-UKQEtp+KJDePFwA_tw@mail.gmail.com>
References: <BANLkTim5inFCXMwnFz=4CHrAmhXMYyMscw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43120 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933228Ab1ERRGC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2011 13:06:02 -0400
Received: by vxi39 with SMTP id 39so1260284vxi.19
        for <linux-scsi@vger.kernel.org>; Wed, 18 May 2011 10:06:01 -0700 (PDT)
In-Reply-To: <BANLkTim5inFCXMwnFz=4CHrAmhXMYyMscw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasilis Liaskovitis <vliaskov@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Tue, May 17, 2011 at 12:37 PM, Vasilis Liaskovitis
<vliaskov@gmail.com> wrote:
> I am trying to test the TCM/LIO ib_srpt target driver from master
> branch of lio-core-2.6
>
> However, the tcm_ib_srpt-38 branch results in a =A0kernel panic durin=
g
> I/O traffic (e.g. doing simple dd tests on exported disk)
> I was hoping that the latest patches in master would fix this.

I have never seen such behavior during any of the tests I ran. I'll
see whether I can reproduce that behavior with lio-4.1.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
