From: Philippe =?ISO-8859-1?Q?Gramoull=E9?=
	<philippe.gramoulle@mmania.com>
Subject: Re: [PATCH 2.5] fix megaraid driver compile error
Date: Fri, 7 Feb 2003 00:40:37 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030207004037.334abaaf.philippe.gramoulle@mmania.com>
References: <1044559247.4858.49.camel@markh1.pdx.osdl.net>
	<Pine.LNX.4.44.0302061202430.3545-100000@home.transmeta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0302061202430.3545-100000@home.transmeta.com>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: markh@osdl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

Sorry, i posted the fix on Feb 4th, but i forgot=20
 1) to include [PATCH] in the subject and 2) to send it to the
right person instead of just posting to LKML, as it's my first post :o)

The fix was attached as well and shouldn't have whitespace<->tab issue

Thanks,

Philippe

--
Philippe Gramoull=E9
philippe.gramoulle@mmania.com
Lycos Europe - NOC France


On Thu, 6 Feb 2003 12:04:15 -0800 (PST)
Linus Torvalds <torvalds@transmeta.com> wrote:


  | =20
  |  On 6 Feb 2003, Mark Haverkamp wrote:
  |  >
  |  > This moves access of the host element to device since host has b=
een
  |  > removed from struct scsi_cmnd.
  | =20
  |  This is whitespace-damaged.
  | =20
  |  Please fix broken mailers. I generally don't bother to fix up whit=
espace
  |  damage from people who can't bother to have a good mailer. It's ju=
st not=20
  |  worth it - if I try to fix it up (even if it is often trivial), it=
 just=20
  |  means that people will continue to send crap patches to me.
  | =20
  |  		Linus
  | =20
  |  -
  |  To unsubscribe from this list: send the line "unsubscribe linux-ke=
rnel" in
  |  the body of a message to majordomo@vger.kernel.org
  |  More majordomo info at  http://vger.kernel.org/majordomo-info.html
  |  Please read the FAQ at  http://www.tux.org/lkml/
  | =20
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
