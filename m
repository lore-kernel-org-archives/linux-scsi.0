From: Stephen Cameron <smcameron@yahoo.com>
Subject: Re: Is this a known problem with the SCSI mid layer?
Date: Fri, 15 Jan 2010 06:18:17 -0800 (PST)
Message-ID: <938826.85923.qm@web33005.mail.mud.yahoo.com>
References: <4B50675C.8070402@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web33005.mail.mud.yahoo.com ([209.191.69.120]:28128 "HELO
	web33005.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757701Ab0AOOSS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jan 2010 09:18:18 -0500
In-Reply-To: <4B50675C.8070402@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org

--- On Fri, 1/15/10, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

=2E..

>=20
> Did you check that also after, say, several minutes?=A0
> I suppose you
> already looked at the kernel log for possibly related
> messages and would
> have reported them as well...=A0 Nevertheless, I have
> seen some cases of
> device removal or driver removal where the SCSI layer spent
> many minutes
> (5? 15? I'm not sure anymore) in error handling although
> the lower layer
> had done its best (best but perhaps not well) to report the
> device as
> physically gone.
>=20
> Did you already test really long after device removal and
> last close,
> along the lines of this?
> # while ((i++ < 20)); do rmmod $driver && break;
> sleep 60; done


I had left it sitting since last night (~6:00pm localtime), and this mo=
rning (~8:00am localtime), it still won't rmmod... so ~14 hours.

-- steve

> --=20
> Stefan Richter
> -=3D=3D=3D=3D=3D-=3D=3D-=3D- ---=3D -=3D=3D=3D=3D
> http://arcgraph.de/sr/
>=20


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
