From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [PATCH / RFC] scsi_set_host_offline
Date: Tue, 4 Mar 2003 01:03:18 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200303040103.18491.oliver@neukum.name>
References: <20030303221532.GB1587@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030303221532.GB1587@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>, linux-scsi@vger.kernel.org
Cc: mdharm-scsi@one-eyed-alien.net

Am Montag, 3. M=E4rz 2003 23:15 schrieb Mike Anderson:
> I have added a scsi_set_host_offline which supplements
> scsi_set_device_offline. host_lock should not be held on call of eith=
er
> one of these functions.

Very good.

> Currently scsi_set_host_offline is just setting
> each sdev in my_devices offline, but could be expanded without changi=
ng
> the api to the LLDD.

Don't we need to disallow further devices being discovered on this
host's busses before we set the existing devices offline?

	Regards
		Oliver

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
