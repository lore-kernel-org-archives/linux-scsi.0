From: Ron Pitts <aussieron@gmail.com>
Subject: Re: [RFC/PATCH] add PCI id for HighPoint RocketRAID 2720 to mvsas
Date: Fri, 29 Oct 2010 16:23:46 +1100
Message-ID: <AANLkTinn0xDSshYYuCAfdAi9J3fekWyunqSkBU9nfEkP@mail.gmail.com>
References: <20101020223110.GT2315@kvack.org>
	<20101029022447.GL23388@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52838 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab0J2FXs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2010 01:23:48 -0400
Received: by iwn10 with SMTP id 10so3218775iwn.19
        for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2010 22:23:47 -0700 (PDT)
In-Reply-To: <20101029022447.GL23388@kvack.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: linux-scsi@vger.kernel.org

Highpoint arent very good at the moment with linux support which is a
disappointment...good luck.

On Fri, Oct 29, 2010 at 1:24 PM, Benjamin LaHaise <bcrl@kvack.org> wrot=
e:
> Hello all,
>
> On Wed, Oct 20, 2010 at 06:31:10PM -0400, Benjamin LaHaise wrote:
>> I recently built a system using the HighPoint 2720 SAS controller, w=
hich
>> is based on the Marvell 88SE9485. =A0In my limited testing (read: it=
 boots),
>> the following patch is needed to get mvsas to recognize the board. =A0=
With
>> this patch, the system boots without issue and SATA passthrough seem=
s to
>> work. =A0Note that I have not tested the board with any SAS drives, =
as I
>> only have SATA drives at present. =A0Any thoughts/comments on if any=
thing
>> further is needed for this board?
>
> No luck with this. =A0Under testing it eventually starts reporting ba=
d
> sectors on writes. =A0Does anyone have any pointers for docs on the m=
vsas
> chips that I could use for debugging this? =A0For that matter, am I u=
sing
> the right description for the 88SE9485?
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0-ben
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
