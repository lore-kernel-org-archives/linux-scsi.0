From: "Metathronius Galabant" <m.galabant@googlemail.com>
Subject: Re: aacraid driver incomplete regarding info + logging
Date: Fri, 13 Oct 2006 11:41:52 +0200
Message-ID: <1b270aae0610130241wc755692ped86dc05d83a3781@mail.gmail.com>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F02D8131A@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.229]:6192 "EHLO
	wx-out-0506.google.com") by vger.kernel.org with ESMTP
	id S1750996AbWJMJlx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Oct 2006 05:41:53 -0400
Received: by wx-out-0506.google.com with SMTP id s14so812970wxc
        for <linux-scsi@vger.kernel.org>; Fri, 13 Oct 2006 02:41:52 -0700 (PDT)
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F02D8131A@otce2k03.adaptec.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org

> There is not enough space to waste in the kernel to add such features,
> and there is a dynamic and complicated relationship between the full
> fledged native and proprietary management applications shipped by

Are about maybe a handful of informational printk()s really too much?
I'm used to this behaviour from all my machines (gdth, lsi, cciss).
The thing is - because of the driver I had to exchange the adaptec
raid card for something else.

Cheers,
M
