From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: aic94xx driver woes continued
Date: Sat, 29 Mar 2008 15:36:40 -0700 (PDT)
Message-ID: <500267.92468.qm@web31801.mail.mud.yahoo.com>
References: <47E2B7A7.20206@ipax.at>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31801.mail.mud.yahoo.com ([68.142.207.64]:34269 "HELO
	web31801.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750999AbYC2WnV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Mar 2008 18:43:21 -0400
In-Reply-To: <47E2B7A7.20206@ipax.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>
Cc: linux-scsi@vger.kernel.org

--- On Thu, 3/20/08, Raoul Bhatia [IPAX] <r.bhatia@ipax.at> wrote:
> James Bottomley wrote:
> > This is all normal.  Seagate drives are known for
> throwing protocol
> > errors under stress at certain revs of firmware. 
> That's what
> > REQ_TASK_ABORT, reason=0x6 is.
> > 
> > Your logs indicate that the recovery occurred
> correctly (as in all tasks
> > were eventually retried), so it doesn't show an
> actual problem.
> 
> ok, i already filed a trouble ticket at seagate - lets see
> if they
> provide a firmware update for the disks. afaik mine is
> "firmware 0002"

I doubt they'll be able to identify the problem without a
protocol link trace.

  Luben

