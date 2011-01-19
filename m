From: Maksim Rayskiy <maksim.rayskiy@gmail.com>
Subject: Re: [RFC/PATCH] Deferred disk spinup during system resume
Date: Wed, 19 Jan 2011 12:29:59 -0800
Message-ID: <AANLkTikcrznVeySm42NDYtWtKJBypSXCRv1QsOBug5zQ@mail.gmail.com>
References: <1294795457-9006-1-git-send-email-maksim.rayskiy@gmail.com>
	<20110112112142.GA9610@mtj.dyndns.org>
	<4D2DF45B.5010101@pobox.com>
	<AANLkTikEusD_CvkOERsr_wr7T70g1kuU=JnBJm5ur5Wg@mail.gmail.com>
	<4D368D3B.7030701@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4D368D3B.7030701@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, Linux IDE mailing list <linux-ide@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

> A kernel modification might not even be needed.
>
> Have you tried simply issuing READ VERIFY via bsg, and not caring if =
it
> completes? =A0bsg should be able to handle an app submitting a comman=
d, but
> never checking the 'done' list, right? =A0A simple shell app could ex=
ecute
>
> =A0 =A0 =A0 =A0write(bsg_fd, ... SCSI READ VERIFY command ...)
> =A0 =A0 =A0 =A0exit(0)
>
> to avoid waiting for READ VERIFY command completion, I would hope.
>
> =A0 =A0 =A0 =A0Jeff
>

My question was how to speed up system resume when he the spinup
request is coming from sd_resume(). For shell method to work I would
have to ignore this request entirely and do READ VERIFY when system is
fully restored.
Can it be done without kernel modification? Tejun mentioned using
manage_start_stop flag but had some reservations against it.

Maksim.
