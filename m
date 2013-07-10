From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH 2/2] scsi: qla2xxx: change some variables to hexadecimal
 string via %*phN format
Date: Wed, 10 Jul 2013 14:37:37 +0300
Message-ID: <CAHp75VfW+X_hKpajFc7-rcseR-_pBrDv5quqOcY2bQKXSBYPJA@mail.gmail.com>
References: <1372506042-1317-1-git-send-email-Oleksandr.Khoshaba@gmail.com>
	<F5D084D6342F9B479C34599BB0A03E4D3539BE38@AVMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:47346 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab3GJLhh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jul 2013 07:37:37 -0400
Received: by mail-ob0-f177.google.com with SMTP id ta17so8225328obb.36
        for <linux-scsi@vger.kernel.org>; Wed, 10 Jul 2013 04:37:37 -0700 (PDT)
In-Reply-To: <F5D084D6342F9B479C34599BB0A03E4D3539BE38@AVMB1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: Oleksandr Khoshaba <oleksandr.khoshaba@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, Vikas Choudhary <vikas.choudhary@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

[ - bunch of QLogic people from Cc list, I don't know why you put them
there, but I think my comments are not to bother people personally,
so, I left few and SCSI ML]

First of all, didn't you notice the
http://www.spinics.net/lists/linux-scsi/msg66798.html ?
I think there is subject is wrong a bit and this patch either should
be combined with that one, or goes after.
I'm sorry for this little mess, Oleksandr is newbie in the community,
I'm kinda a mentor to him.

Also, comment below.

On Wed, Jul 10, 2013 at 2:13 PM, Saurav Kashyap
<saurav.kashyap@qlogic.com> wrote:
> HI Oleksandr,
> Thanks for the patch. In the below patch couple of lines exceed 80 characters.

I think is quite okay to combine string literals to long lines since
checkpatch.pl recommends to do so.
What is your opinion?

--
With Best Regards,
Andy Shevchenko
