From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 02/34] move atp870u_remove to .devexit.text
Date: Fri, 2 Oct 2009 21:13:17 +0200
Message-ID: <20091002191317.GA17428@pengutronix.de>
References: <20091001082607.GA2181@pengutronix.de> <1254385718-14254-2-git-send-email-u.kleine-koenig@pengutronix.de> <1254406802.3885.1.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755124AbZJBTNY@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1254406802.3885.1.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>, Yang Hongyang <yanghy@cn.fujitsu.com>, Alan Cox <alan@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On Thu, Oct 01, 2009 at 02:20:02PM +0000, James Bottomley wrote:
> Given that practically every kernel on the planet is hotplug enabled
> these days and that the savings on the very few that aren't from
> discarding the devexit section is at most a page or two (and even arm
> says they don't care about that), there doesn't seem to be any point
> making these changes.  In fact, I think we can just kill devinit and
> devexit as section markers.
IMHO you should better kill CONFIG_HOTPLUG completely then.

Best regards
Uwe

--=20
Pengutronix e.K.                              | Uwe Kleine-K=F6nig     =
       |
Industrial Linux Solutions                    | http://www.pengutronix.=
de/  |
