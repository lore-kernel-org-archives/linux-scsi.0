From: Rodrigo Severo <rodrigo.lists@fabricadeideias.com>
Subject: Re: SCSI Initio 9100UW (INIC-950p chipset) support nunder kernel
 2.6.x
Date: Wed, 22 Sep 2004 14:40:14 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4151B914.7060806@fabricadeideias.com>
References: <4151A24A.7000302@fabricadeideias.com> <20040922170651.A3340@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from scorsese.fabricadeideias.com.br ([200.157.56.34]:42131 "EHLO
	scorsese.fabricadeideias.com") by vger.kernel.org with ESMTP
	id S265900AbUIVRkQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2004 13:40:16 -0400
In-Reply-To: <20040922170651.A3340@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Hi,


Just after I sent my previous message I realized where I could find the 
driver. It's already compiled and modprobed.

I have only one scsi device attached to it: an ECRIX VXA-1 tape drive.

cat /proc/version gives me:

Linux version 2.6.8-gentoo-r3 (root@coppola2) (gcc version 3.3.4 
20040623 (Gentoo Linux 3.3.4-r1, ssp-3.3.2-2, pie-8.7.6)) #4 Wed Sep 22 
13:24:17 BRT 2004

cat /proc/scsi/scsi gives me:

Attached devices:
Host: scsi1 Channel: 00 Id: 02 Lun: 00
  Vendor: ECRIX    Model: VXA-1            Rev: 2C8C
  Type:   Sequential-Access                ANSI SCSI revision: 02

so the tape drive is being recognized.

I can't access it though.

I tried "mt -f /dev/nst0" rewind and my first result was:

/dev/nst0: No such file or directory

So I "mknod /dev/nst0 c 9 128" rmmoded and modprobed initio module and 
tried again "mt -f /dev/nst0" just to get:

/dev/nst0: No such device or address

Well, I have a rather ordinary Gentoo installation which means it uses 
devfs (and devfsd). Could it be the one to blame?

What should I do now?

Do you need any extra info?

Please remember to CC straight to me as I'm not subscribed to this list.


TIAA,

Rodrigo Severo
 



Christoph Hellwig wrote:

>The driver still exists and actually compiles.  It's marked BROKEN, although
>I don't know why.  If you want to help testing we can update it to current
>standards.
>
>  
>

