From: Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH] scsi: nsp32: Remove unnecessary self assignment in
 nsp32_set_sync_entry
Date: Sun, 27 Jan 2019 18:23:48 -0700
Message-ID: <20190128012348.GA26318@archlinux-ryzen>
References: <20181210235156.6237-1-natechancellor@gmail.com>
 <20190126191143.GB25003@archlinux-ryzen>
 <CALZLnaEkikS6Yv-PR-kBpnrCRrn9A8yHg+ZYGXkq+d_JQvR23g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALZLnaEkikS6Yv-PR-kBpnrCRrn9A8yHg+ZYGXkq+d_JQvR23g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Masanori Goto <gotom@debian.or.jp>
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Jan 27, 2019 at 05:42:01PM +0900, Masanori Goto wrote:
> Thanks for the fix!
> 
> 2019年1月27日(日) 4:11 Nathan Chancellor <natechancellor@gmail.com>:
> >
> > On Mon, Dec 10, 2018 at 04:51:56PM -0700, Nathan Chancellor wrote:
> > > Clang warns:
> > >
> > > drivers/scsi/nsp32.c:2444:14: warning: explicitly assigning value of
> > > variable of type 'unsigned char' to itself [-Wself-assign]
> > >         offset      = offset;
> > >         ~~~~~~      ^
> > >
> > > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> 
> Acked-by: GOTO Masanori <gotom@debian.or.jp>

Thank you for the reply and the review :)

Nathan

> 
> > > ---
> > >  drivers/scsi/nsp32.c | 1 -
> > >  1 file changed, 1 deletion(-)
> > >
> > > diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
> > > index 5aac3e801903..7ce6e7acf2f3 100644
> > > --- a/drivers/scsi/nsp32.c
> > > +++ b/drivers/scsi/nsp32.c
> > > @@ -2441,7 +2441,6 @@ static void nsp32_set_sync_entry(nsp32_hw_data *data,
> > >
> > >       period      = data->synct[entry].period_num;
> > >       ackwidth    = data->synct[entry].ackwidth;
> > > -     offset      = offset;
> > >       sample_rate = data->synct[entry].sample_rate;
> > >
> > >       target->syncreg    = TO_SYNCREG(period, offset);
> > > --
> > > 2.20.0
> > >
> >
> > Ping?
