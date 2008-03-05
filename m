From: "Rodrigo Severo" <rodrigo@fabricadeideias.com>
Subject: Re: Adaptec 29320LPE errors on boot
Date: Wed, 5 Mar 2008 13:26:09 -0300
Message-ID: <a7108f870803050826u15e8dd90q656cd415e4eea1eb@mail.gmail.com>
References: <a7108f870803050742x6a960bf4sed894208a5fb3931@mail.gmail.com>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F4831D6BEF@ADPE2K703.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.224]:15507 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbYCEQ0N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2008 11:26:13 -0500
Received: by wr-out-0506.google.com with SMTP id 50so2253276wra.13
        for <linux-scsi@vger.kernel.org>; Wed, 05 Mar 2008 08:26:11 -0800 (PST)
In-Reply-To: <532ABFBDAAC3A34EB12EBA6CEC2838F4831D6BEF@ADPE2K703.adaptec.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 3/5/08, Salyzyn, Mark <Mark_Salyzyn@adaptec.com> wrote:
> Sounds like you have a bad SCSI cable or drive.
>
>  Do any of these drives work in any other OS environment?

This same drive with this same cable with this same terminator works
well with a 39160 (which usses another driver: the aic7xxx) on the
same OS environment so I don't think this is a cable or drive issue.

Besides I tested with four different cables (different models and
manufactures, all pretend to be U320 compatible). The problem is
unchanged when I use different cables and terminators.

I also tested with several different disks (different models and
manufactures). The problem is still unchanged.


Regards,

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
