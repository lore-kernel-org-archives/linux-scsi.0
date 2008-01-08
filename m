From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC] Implementation of SCSI dynamic power management
Date: Tue, 8 Jan 2008 15:12:55 +0100
Message-ID: <200801081512.55746.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0801071244180.2748-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out001.kontent.com ([81.88.40.215]:49502 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbYAHOMe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 09:12:34 -0500
In-Reply-To: <Pine.LNX.4.44L0.0801071244180.2748-100000@iolanthe.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@lists.linux-foundation.org>

Am Montag, 7. Januar 2008 20:42:23 schrieb Alan Stern:
> =A0/**
> + *=A0=A0=A0=A0=A0autoresume - perform dynamic (runtime) host resume
> + *=A0=A0=A0=A0=A0@shp: host to resume
> + *
> + *=A0=A0=A0=A0=A0Resume (return to an operational power level) the s=
pecified host.
> + *=A0=A0=A0=A0=A0Return 0 if the resume was successful, otherwise a =
negative
> + *=A0=A0=A0=A0=A0error code.
> + *
> + *=A0=A0=A0=A0=A0Locks: struct Scsi_Host::pm_mutex held throughout t=
he call.
> + *
> + *=A0=A0=A0=A0=A0Calling context: process
> + *
> + *=A0=A0=A0=A0=A0Notes: If the host is not currently suspended, this=
 method does
> + *=A0=A0=A0=A0=A0need to do anything.
> + *
> + *=A0=A0=A0=A0=A0Optionally defined in: LLD
> + **/
> + =A0 =A0int autoresume(struct Scsi_Host *shp)
> +

This seems to be a bit misleading. It seems to me that you must cancel
any outstanding request to autosuspend from other layers.

	Regards
		Oliver
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
