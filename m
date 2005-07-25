From: Johann Hanne <jhml@gmx.net>
Subject: Re: Is it possible to support a sector size 8192
Date: Tue, 26 Jul 2005 00:38:22 +0200
Message-ID: <200507260038.22820.jhml@gmx.net>
References: <E1Dw26Z-0005m7-JQ@sledge.mossbank.org.uk> <200507231528.20356.jhml@gmx.net> <E1Dx8Jk-0006vH-Ra@sledge.mossbank.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:43471 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261560AbVGYUUm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2005 16:20:42 -0400
In-Reply-To: <E1Dx8Jk-0006vH-Ra@sledge.mossbank.org.uk>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> >I'm a little confused here.  Tape devices have variable sector sizes.
> >I believe they're required to handle up to 64K in a unix environment.
> >The drives I work on go up to 256k.
> Tapes are different. The UDO drive that Johann was asking about is an
> optical _disk_ drive...
Hmm... would it be _possible_ to support it as tape device (/dev/st* 
and /dev/nst*)?

Cheers, Johann
