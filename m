From: Klaus Steinberger <Klaus.Steinberger@physik.uni-muenchen.de>
Subject: Re: Kernel OOPS with aacraid driver
Date: Sun, 24 Apr 2005 11:41:07 +0200
Message-ID: <200504241141.08081.Klaus.Steinberger@physik.uni-muenchen.de>
References: <df35dfeb050422000856c882d6@mail.gmail.com> <200504221357.14159.Klaus.Steinberger@physik.uni-muenchen.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.physik.uni-muenchen.de ([192.54.42.129]:60288 "EHLO
	mail.physik.uni-muenchen.de") by vger.kernel.org with ESMTP
	id S261793AbVDXJpL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Apr 2005 05:45:11 -0400
Received: from localhost (unknown [127.0.0.1])
	by mail.physik.uni-muenchen.de (Postfix) with ESMTP id 1C6A220013
	for <linux-scsi@vger.kernel.org>; Sun, 24 Apr 2005 11:45:11 +0200 (CEST)
Received: from mail.physik.uni-muenchen.de ([127.0.0.1])
 by localhost (mail.physik.uni-muenchen.de [127.0.0.1]) (amavisd-new, port 10024)
 with LMTP id 11510-02-12 for <linux-scsi@vger.kernel.org>;
 Sun, 24 Apr 2005 11:45:09 +0200 (CEST)
Received: from [192.168.1.10] (a136.lmu.vpn.lrz-muenchen.de [141.84.28.136])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by mail.physik.uni-muenchen.de (Postfix) with ESMTP id 653D42000A
	for <linux-scsi@vger.kernel.org>; Sun, 24 Apr 2005 11:45:09 +0200 (CEST)
In-Reply-To: <200504221357.14159.Klaus.Steinberger@physik.uni-muenchen.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Am Freitag 22 April 2005 13:57 schrieb Klaus Steinberger:
> Hello Rayan,
>
> > Seems to me like someone is issuing IOCTL's against devices that do
> > not exist. Does this patch against linux-2.6.12-rc3 make sense and
> > applicable to you?
>
> Sounds good. I have an kernel build on the way, and will test it on Monday.

Yep I got by occasion a test window today, the fix works fine.

Sincerly,
Klaus

-- 
Klaus Steinberger         Maier-Leibnitz Labor
Phone: (+49 89)289 14287  Am Coulombwall 6, D-85748 Garching, Germany
FAX:   (+49 89)289 14280  EMail: Klaus.Steinberger@Physik.Uni-Muenchen.DE
URL: http://www.physik.uni-muenchen.de/~k2/

In a world without Walls and Fences, who needs Windows and Gates
