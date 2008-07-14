From: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Subject: Re: adaptec 3405 + 4 sas disks: synchronize_callback: synchronize failed, status = 226
Date: Mon, 14 Jul 2008 07:19:19 -0400
Message-ID: <C9E18FB9-75B1-4768-B290-2E3C9370D68D@adaptec.com>
References: <200807140809.19937.arekm@maven.pl>
Mime-Version: 1.0 (Apple Message framework v926)
Content-Type: text/plain; charset=UTF-8;
	format=flowed	delsp=yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:50392 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbYGNLT2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jul 2008 07:19:28 -0400
In-Reply-To: <200807140809.19937.arekm@maven.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: Linux-Scsi <linux-scsi@vger.kernel.org>, AACRAID <AACRAID@adaptec.com>, Achim Leubner <Achim_Leubner@adaptec.com>

226 means CT_ERROR, a generic response to the CT_FLUSH_CACHE command =20
to the controller when the action could not be performed.

The action is to flush all the controller's cache to the targets in =20
response to a SCSI SYNCHRONIZE_CACHE command. I expect that you are =20
running with a degraded array, or incompatible drives?

Make sure your drive and controller firmware is as up-to-date as =20
possible.

Sincerely -- Mark Salyzyn

On Jul 14, 2008, at 2:09 AM, Arkadiusz Miskiewicz wrote:

>
> Hello,
>
> I'm running 2.6.24.3 kernel and I'm getting few error messages =20
> comming from
> aacraid driver. Hardware is adaptec 3405 running firmware 15728 + 4 =20
> SAS 300GB
> harddisks configured in single raid10 array.
>
> [167674.161866] synchronize_callback: synchronize failed, status =3D =
226
> [168977.738031] synchronize_callback: synchronize failed, status =3D =
226
> [172180.752140] synchronize_callback: synchronize failed, status =3D =
226
> [177494.855145] synchronize_callback: synchronize failed, status =3D =
226
> [189594.477223] synchronize_callback: synchronize failed, status =3D =
226
> [191411.881236] synchronize_callback: synchronize failed, status =3D =
226
> [217130.596663] synchronize_callback: synchronize failed, status =3D =
226
> [219236.032362] synchronize_callback: synchronize failed, status =3D =
226
>
> What does 226 mean and what does it indicate (serious problem?) ?
>
> ps. would be good if prefix was added to these messages to know =20
> where these
> come from
> --
> Arkadiusz Mi=C5=9Bkiewicz        PLD/Linux Team
> arekm / maven.pl            http://ftp.pld-linux.org/

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
