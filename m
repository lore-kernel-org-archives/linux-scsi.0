From: "Mark Nelson" <mdnelson8@gmail.com>
Subject: Re: [RFC][PATCH] ahci: Add support for Promise PDC42819
Date: Fri, 5 Sep 2008 12:31:22 +1000
Message-ID: <65a6ef750809041931rdedaf07m10ff2014f76f1ee4@mail.gmail.com>
References: <65a6ef750809020403i52228319u9e3197e4062941bc@mail.gmail.com>
	 <48BD2136.1020101@garzik.org>
	 <65a6ef750809020455q7b7ee6a8jc404b4970f660c50@mail.gmail.com>
	 <18621.11426.870514.781750@harpo.it.uu.se>
	 <65a6ef750809020521wfaca733r8253795860b95f4@mail.gmail.com>
	 <48BFBA5E.5050300@garzik.org>
	 <65a6ef750809040459h3ffe3183nf0b5a35d15ab86e4@mail.gmail.com>
	 <48BFE5FA.9090006@garzik.org>
	 <20080904152803.6c4977ce@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:57317 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbYIECbX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Sep 2008 22:31:23 -0400
Received: by yx-out-2324.google.com with SMTP id 8so151553yxm.1
        for <linux-scsi@vger.kernel.org>; Thu, 04 Sep 2008 19:31:22 -0700 (PDT)
In-Reply-To: <20080904152803.6c4977ce@lxorguk.ukuu.org.uk>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, Mikael Pettersson <mikpe@it.uu.se>, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Sep 5, 2008 at 12:28 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> > No need for hope - we have ahci now :)
>>
>> Well, I still think this PCI ID addition leaves open the possibility
>> that plugging in a SAS disk could hang the system or similar misbehavior.
>
> And not adding it means it doesn't work at all and you'll never find out
> as you won't get the bug report from the SAS user 8)
>

Another fair point. I'll let you guys work out which is the better way
to do things as you are the gurus :)

Thanks!

Mark
