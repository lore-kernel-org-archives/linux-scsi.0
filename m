From: Willem Riede <wrlk@riede.org>
Subject: Re: aic7xxx 6.2.24 bug report
Date: Sat, 28 Dec 2002 20:57:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021229015759.GI9319@linnie.riede.org>
References: <20021228204505.GC9319@linnie.riede.org> <766648112.1041108533@aslan.scsiguy.com> <20021228222620.GE9319@linnie.riede.org> <834928112.1041114482@aslan.scsiguy.com> <20021228232624.GG9319@linnie.riede.org> <910548112.1041122117@aslan.scsiguy.com>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <910548112.1041122117@aslan.scsiguy.com>; from gibbs@scsiguy.com on Sat, Dec 28, 2002 at 19:35:17 -0500
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org

On 2002.12.28 19:35 Justin T. Gibbs wrote:
> > 
> > I'm particularly surprised by the line
> > 
> > Parameter aic7xxx length must be 1-1 characters
> > 
> > which hints that the options are not correctly coded?
> 
> This is due to the shell magic used during initrds.  Did you
> try quoting this options?
> 
> options aic7xxx 'aic7xxx=verbose.debug:0x63'
> 
I have now, without change. I had earlier quoted just "aic7xxx=verbose.debug:0x63"
and tried only aic7xxx=verbose to avoid special characters, all with the same
effect.

One thought just occured to me, the modutils have been in flux, I'll see if
there is a newer version than I'm using now.

Regards, Willem Riede.
