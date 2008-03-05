From: "Rodrigo Severo" <rodrigo@fabricadeideias.com>
Subject: Re: Adaptec 29320LPE errors on boot
Date: Wed, 5 Mar 2008 16:14:09 -0300
Message-ID: <a7108f870803051114jb9889f1rae64840efeeb4bf4@mail.gmail.com>
References: <a7108f870803050742x6a960bf4sed894208a5fb3931@mail.gmail.com>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F4831D6BEF@ADPE2K703.adaptec.com>
	 <a7108f870803050826u15e8dd90q656cd415e4eea1eb@mail.gmail.com>
	 <1204734777.3047.40.camel@localhost.localdomain>
	 <a7108f870803050852h1824418v9c67a90f754f69e@mail.gmail.com>
	 <20080305171142.GN24386@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.177]:2803 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbYCETOL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2008 14:14:11 -0500
Received: by el-out-1112.google.com with SMTP id v27so2307260ele.17
        for <linux-scsi@vger.kernel.org>; Wed, 05 Mar 2008 11:14:10 -0800 (PST)
In-Reply-To: <20080305171142.GN24386@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 3/5/08, Matthew Wilcox <matthew@wil.cx> wrote:
> On Wed, Mar 05, 2008 at 01:52:50PM -0300, Rodrigo Severo wrote:
>  > I changed the following values on  29320LPE from the previous defa=
ult ones:
>  >
>  > Sync Transfer Rate: 160
>
>
> Ah, you've been fooled by SCSI terminology.

I don't think so.

>  U160 is 80 million
>  transfers per second,

Yes I know.

>  but each transfer is 16-bit wide,

Also know that.

>  so they call it
>  U160.

Yes I know that too.

I changed the Sync Transfer Rate from the 29320LPE default 320
MB/Second to it's second option: 160 MB/Second.

>  Can you try turning that down to 80 (and just for fun, if that
>  fails, can you try 40?)

Just for fun, I did. I tried 40 MB/Second. It took some more time
(around 30 extra seconds) but then I got the same error messages.


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
