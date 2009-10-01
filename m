From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 02/34] move atp870u_remove to .devexit.text
Date: Thu, 01 Oct 2009 14:20:02 +0000
Message-ID: <1254406802.3885.1.camel@mulgrave.site>
References: <20091001082607.GA2181@pengutronix.de>
	 <1254385718-14254-2-git-send-email-u.kleine-koenig@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:53186 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932423AbZJAOUF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Oct 2009 10:20:05 -0400
In-Reply-To: <1254385718-14254-2-git-send-email-u.kleine-koenig@pengutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>, Yang Hongyang <yanghy@cn.fujitsu.com>, Alan Cox <alan@redhat.com>, linux-scsi@vger.kernel.org

On Thu, 2009-10-01 at 10:28 +0200, Uwe Kleine-K=C3=B6nig wrote:
> The function atp870u_remove is used only wrapped by __devexit_p so de=
fine
> it using __devexit.

What's the justification for this?

Given that practically every kernel on the planet is hotplug enabled
these days and that the savings on the very few that aren't from
discarding the devexit section is at most a page or two (and even arm
says they don't care about that), there doesn't seem to be any point
making these changes.  In fact, I think we can just kill devinit and
devexit as section markers.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
