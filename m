From: "Magnus Naeslund(w)" <mag@fbab.net>
Subject: RE: ServeRAID SCSI device write-back
Date: Thu, 7 Oct 2004 13:42:34 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <37431.129.178.88.68.1097149354.squirrel@129.178.88.68>
References: <A121ABA5B472B74EB59076B8E3C8F019868B8B@rtpe2k01.adaptec.com>
Reply-To: mag@fbab.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from spectre.fbab.net ([212.214.165.139]:45190 "HELO mail2.fbab.net")
	by vger.kernel.org with SMTP id S269801AbUJGLmg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2004 07:42:36 -0400
In-Reply-To: <A121ABA5B472B74EB59076B8E3C8F019868B8B@rtpe2k01.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Hammer, Jack" <Jack_Hammer@adaptec.com>
Cc: mag@fbab.net, linux-scsi@vger.kernel.org


Hammer, Jack said:
>
> The Write Cache you are referring to in the ServeRAID Manager is a
> feature on the adapter itself and is not the same thing you are
> displaying with scsiinfo.
>
> Yes, it is definitely good to have the adapter Write Cache turned on
> when the adapter has battery backup.
>
> IpsLinux
>

Thanks!
I'm not going to turn on write-cache via the linux scsi side, then.

Regards,
Magnus

