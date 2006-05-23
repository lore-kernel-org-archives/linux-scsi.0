From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: Re: mptspi doesn't work the nStor
Date: Mon, 22 May 2006 22:14:32 -0600
Message-ID: <008901c67e1f$654674c0$321015ac@ericmoore>
References: <a63d67fe0605221637i231d4b48n942461ccdf4ee470@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:22760 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751215AbWEWEOT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 May 2006 00:14:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>, linux-scsi@vger.kernel.org, mpt_linux_developer@lsil.com

On Monday, May 22, 2006 5:37 PM, Dan Carpenter wrote:
>I can't get mptspi to work with my nStor in FC5.  I think it broke
> when mptscsih get split up.  The split has been back ported to
> sles9sp3 and rhel4u3 and it breaks those as well.
> 
> Are there any patches that make it work again?
> 
> Fedora Core 5 bugzilla
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=188487
> RHEL 4u3 buzilla
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=190760
> 

Ok, I see various things here, such as the end device being busy, and data underruns,
and device not there.  Nothing conclusive.  Can you send me your pariticular dmesg
with debuging enabled in the driver.  Also in private email I will send you our latest drivers.

Eric Moore
LSI Logic

