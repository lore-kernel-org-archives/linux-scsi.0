From: Dag Nygren <dag@newtech.fi>
Subject: Re: blocksize limitations in scsi tape driver (st) when used with
 DLT1 tape drives?
Date: Thu, 05 Sep 2002 23:02:08 +0300
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20020905200208.22430.qmail@dag.newtech.fi>
References: <fl@fl.priv.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: Message from Friedrich Lobenstock <fl@fl.priv.at>
   of "Thu, 05 Sep 2002 21:35:50 +0200." <3D77B216.8070205@fl.priv.at>
To: Linux-SCSI Mailingliste <linux-scsi@vger.kernel.org>
Cc: Linux-Kernel Mailingliste <linux-kernel@vger.kernel.org>, dag@newtech.fi
List-Id: linux-scsi@vger.kernel.org


Hi,

I have successfully been using Legato Networker with a
blocksize of 32k with my DLT here.

But the way Legato wants to do it is to decide about the
blocksize itself.
This means that the driver should NOT decide on the BS, but
pass on anything written through it, meaning a blocksize setting
of 0 (or variable blocksize).

Perhaps Arkeia works the same way ?

Best Luck


--=20
Dag Nygren                               email: dag@newtech.fi
Oy Espoon NewTech Ab                     phone: +358 9 8024910
Tr=E4sktorpet 3                              fax: +358 9 8024916
02360 ESBO                              Mobile: +358 400 426312
=46INLAND
