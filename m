From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [PATCH / RFC] scsi_set_host_offline
Date: Tue, 4 Mar 2003 21:57:36 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200303042157.36141.oliver@neukum.name>
References: <20030303221532.GB1587@beaverton.ibm.com> <200303040103.18491.oliver@neukum.name> <20030304123605.D6452@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030304123605.D6452@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Mike Anderson <andmike@us.ibm.com>, linux-scsi@vger.kernel.org

Am Dienstag, 4. M=E4rz 2003 21:36 schrieb Matthew Dharm:
> On Tue, Mar 04, 2003 at 01:03:18AM +0100, Oliver Neukum wrote:
> > Don't we need to disallow further devices being discovered on this
> > host's busses before we set the existing devices offline?
>
> Hrm... yes, I think this could be a problem.
>
> For 99% of USB storage devices, it's not.  One device =3D=3D one host=
 with one
> target.  However, for the other 1% of devices (and all 'real' SCSI ho=
sts),
> this could be an issue.  I could be trying to yank the device (hot-un=
plug)
> at the same moment someone is doing an add-single-device.

This is not limited to this case. Device addition could as well be thro=
ugh
ordinary scanning of the bus which the SCSI layer does.

	Regards
		Oliver


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
