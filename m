From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target_core_alua: silence GCC warning
Date: Wed, 19 Feb 2014 14:59:09 -0800
Message-ID: <1392850749.22195.1.camel@haakon3.risingtidesystems.com>
References: <1392714172-2712-1-git-send-email-geert@linux-m68k.org>
	 <1392803546.27558.16.camel@x220>
	 <CAMuHMdXZrw7oU=n60+PNNQftU6Su=mBf2V75TCO8Ws1pS5z+6Q@mail.gmail.com>
	 <1392804347.27558.20.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1392804347.27558.20.camel@x220>
Sender: target-devel-owner@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-02-19 at 11:05 +0100, Paul Bolle wrote:
> On Wed, 2014-02-19 at 10:59 +0100, Geert Uytterhoeven wrote:
> > On Wed, Feb 19, 2014 at 10:52 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > > -               ret = core_alua_state_nonoptimized(cmd, cdb,
> > > -                                       nonop_delay_msecs, &alua_ascq);
> > > +               core_alua_state_nonoptimized(cmd, cdb, nonop_delay_msecs);
> > 
> > I suggest making core_alua_state_nonoptimized()  return void, too.
> > Currently it always returns zero.
> 
> Good catch. Not sure how I missed that, since I deliberately ignore its
> return value here.
> 
> I'll wait with sending a v2 until after Nicholas or the other target
> developers have given their feedback.
> 
> 

Hi Paul,

The patch is fine with me..  Feel free to post a -v2.

Thanks,

--nab
