From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 1/3] osst upgrade to 0.99.3
Date: Wed, 5 Jan 2005 15:18:19 -0800
Message-ID: <20050105151819.1a4981ae.akpm@osdl.org>
References: <1104627552l.3427l.2l@serve.riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:12524 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262656AbVAEXSb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jan 2005 18:18:31 -0500
In-Reply-To: <1104627552l.3427l.2l@serve.riede.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <osst@riede.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Willem Riede <osst@riede.org> wrote:
>
> In a series of three mails, I'll present changes I'd like to see 
>  made to the osst driver in the linux-2.6.11 pre-series.

All three patches were hopelessly mangled by your email client:

70 out of 70 hunks FAILED -- saving rejects to file drivers/scsi/osst.c.rej
osst-style-changes does not apply

Please sort out your email client and send the patches to yourself to test
that they still apply.

When resending please ensure that the patch headers are in `-p1' form:

--- osst-patches/osst.h	2005-01-01 19:15:32.700230984 -0500
+++ /home/wriede/SfOsstCVS/Driver26/osst.h	2005-01-01 16:13:35.000000000 -0500

Things like the above will not apply to anyone's tree without jumping
through hoops.

Also, please don't send multiple patches under the same Subject:.

See http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt, thanks.
