From: Sulamita Garcia <sulagarcia@yahoo.com.br>
Subject: Re: Kernel panic - Ththththaats all folks
Date: Sat, 6 Sep 2003 17:00:17 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200309061700.17180.sulagarcia@yahoo.com.br>
References: <20030905140100.53464.qmail@web21106.mail.yahoo.com> <1062772665.32436.4.camel@dhcp23.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp015.mail.yahoo.com ([216.136.173.59]:65037 "HELO
	smtp015.mail.yahoo.com") by vger.kernel.org with SMTP
	id S261725AbTIFUAX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Sep 2003 16:00:23 -0400
In-Reply-To: <1062772665.32436.4.camel@dhcp23.swansea.linux.org.uk>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Em Friday 05 September 2003 11:37, Alan Cox escreveu:
> On Gwe, 2003-09-05 at 15:01, Sulamita Garcia wrote:
> > instalation default, and rebuild module from source
> > because kernel module didn't work. Now I have a Raid 0
> > by hardware
>
> Problems with HPT's partially binary module should be directed to
> highpoint not to this list. Looking at the trace its almost certainly
> a bug in their alternative software raid driver.
>
> Alan

I found the error. Is the arternative Linux distribution that I used.=20
I delete RedHat and install Slackware 9.0, and everything it's working.=
=2E.
[]'s

--=20

  =B0v=B0  Sulamita Garcia               =20
 /(_)\ Alta   Disponibilidade           =20
  ^ ^  http://ha.underlinux.com.br
 Slackware - Because It Works       Linuxchix-BR - http://br.linuxchix.=
org/
 Linux Registered User 240300         "Meninas boazinhas v=E3o para o c=
=E9u.
 BSD050867                                   As m=E1s v=E3o =E0 luta."

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
