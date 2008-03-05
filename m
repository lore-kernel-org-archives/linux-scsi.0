From: "Rodrigo Severo" <rodrigo@fabricadeideias.com>
Subject: Re: Adaptec 29320LPE errors on boot
Date: Wed, 5 Mar 2008 13:52:50 -0300
Message-ID: <a7108f870803050852h1824418v9c67a90f754f69e@mail.gmail.com>
References: <a7108f870803050742x6a960bf4sed894208a5fb3931@mail.gmail.com>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F4831D6BEF@ADPE2K703.adaptec.com>
	 <a7108f870803050826u15e8dd90q656cd415e4eea1eb@mail.gmail.com>
	 <1204734777.3047.40.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.184]:11593 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbYCEQwy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2008 11:52:54 -0500
Received: by rv-out-0910.google.com with SMTP id k20so957174rvb.1
        for <linux-scsi@vger.kernel.org>; Wed, 05 Mar 2008 08:52:51 -0800 (PST)
In-Reply-To: <1204734777.3047.40.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 3/5/08, James Bottomley <James.Bottomley@hansenpartnership.com> wrot=
e:
> On Wed, 2008-03-05 at 13:26 -0300, Rodrigo Severo wrote:
>  > On 3/5/08, Salyzyn, Mark <Mark_Salyzyn@adaptec.com> wrote:
>  > > Sounds like you have a bad SCSI cable or drive.
>  > >
>  > >  Do any of these drives work in any other OS environment?
>  >
>  > This same drive with this same cable with this same terminator wor=
ks
>  > well with a 39160 (which usses another driver: the aic7xxx) on the
>  > same OS environment so I don't think this is a cable or drive issu=
e.
>
> That's only ultra 160 capable.  What happens if you take the speeds f=
or
>  the drives down in the bios of the 29320?

I changed the following values on  29320LPE from the previous default o=
nes:

Sync Transfer Rate: 160
Packetized: No
QAS: No

The error messages are unchanged.

>  > Besides I tested with four different cables (different models and
>  > manufactures, all pretend to be U320 compatible). The problem is
>  > unchanged when I use different cables and terminators.
>  >
>  > I also tested with several different disks (different models and
>  > manufactures). The problem is still unchanged.
>
> It's sounding a bit more like a damaged board ... but try reducing th=
e
>  speed in the bios.

As I said before, you have much more experience on SCSI issues but I
still can't see how a damaged SCSI board would work on one motherboard
model. Do you really think this is possible?


Rodrigo Severo

--=20
-----------------------------------------------------------------------=
----------------
Rodrigo Severo

=46=E1brica de Id=E9ias
SBS Quadra 2 - Bloco S - Ed. Empire Center - Sala 1.301
Bras=EDlia - DF - CEP 70070-904
Tel. (61) 3321-1357       Fax (61) 3223-1712
-----------------------------------------------------------------------=
----------------
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
