From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: Re: [PATCH 01/14] Big kfree NULL check cleanup - drivers/scsi
Date: Thu, 13 Oct 2005 21:21:41 +0200
Message-ID: <9a8748490510131221q5f70b474o2ea518367c05a609@mail.gmail.com>
References: <200510132122.09667.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qproxy.gmail.com ([72.14.204.206]:24903 "EHLO qproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1751629AbVJMTVm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Oct 2005 15:21:42 -0400
Received: by qproxy.gmail.com with SMTP id e12so157002qbe
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2005 12:21:41 -0700 (PDT)
In-Reply-To: <200510132122.09667.jesper.juhl@gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@steeleye.com>, linuxraid@amcc.com, Eric Youngdale <eric@andante.org>, Tommy Thorn <Tommy.Thorn@irisa.fr>, John Aycock <aycock@cpsc.ucalgary.ca>, Russell King <rmk@arm.linux.org.uk>, Oliver Neukum <oliver@neukum.name>, Go Taniguchi <go@turbolinux.co.jp>, linux-eata@i-connect.net, Dario Ballabio <ballabio_dario@emc.com>, Gadi Oxman <gadio@netvision.net.il>, ipslinux@adaptec.com, James Smart <james.smart@emulex.com>, Atul Mukker <Atul.Mukker@lsil.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Lawrence Foard <entropy@world.std.com>, Kai Makisara <Kai.Makisara@kolumbus.fi>, Jesper Juhl <jesper.juhl@gmail.com>

On 10/13/05, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> This is the drivers/scsi/ part of the big kfree cleanup patch.
>

Whoops, subject on this one is wrong, should have been

[PATCH 07/14] Big kfree NULL check cleanup - drivers/scsi


--
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
