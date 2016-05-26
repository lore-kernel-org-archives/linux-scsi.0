From: Varun Prakash <varun@chelsio.com>
Subject: Re: [PATCH v3 13/13] cxgbit: add files for cxgbit.ko
Date: Fri, 27 May 2016 00:28:24 +0530
Message-ID: <20160526185819.GA1672@chelsio.com>
References: <cover.1461088672.git.varun@chelsio.com>
 <62c9d9c1e609c39f714ef15c10ba62b1cbbddecd.1461088673.git.varun@chelsio.com>
 <CAJ3xEMiyQaWwsgVd_J9eVXqPwPk6=VYN_iMoEJQGz=1wHFrHqQ@mail.gmail.com>
 <CAJ3xEMgtsPiatZ-Cy2ENsGVyKVDQSSHi4jr0Ushg21JiuqdLcw@mail.gmail.com>
 <1464072025.22249.87.camel@haakon3.risingtidesystems.com>
 <CAJ3xEMjE3pfz7+QKMUheH9P+xyvj81qbCtbod0mBi7pUspMRXg@mail.gmail.com>
 <011401d1b6ac$917ea000$b47be000$@opengridcomputing.com>
 <CAJ3xEMhm4eemgvgbpCEKc86LbKSi3WKUX7d+57KwwtZbJB52Wg@mail.gmail.com>
 <1464238504.22249.168.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1464238504.22249.168.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, gerlitz.or@gmail.com, swise@opengridcomputing.com
Cc: target-devel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, kxie@chelsio.com, indranil@chelsio.com
List-Id: linux-scsi@vger.kernel.org

Hi Or, Nicholas and Steve

Thank you for the feedback and apologies for the delay in my response.

On Wed, May 25, 2016 at 09:55:04PM -0700, Nicholas A. Bellinger wrote:
> On Wed, 2016-05-25 at 23:41 +0300, Or Gerlitz wrote:
> > On Wed, May 25, 2016 at 8:40 PM, Steve Wise <swise@opengridcomputing.com> wrote:
> > >> From: Or Gerlitz [mailto:gerlitz.or@gmail.com]
> > >>
> 
> <SNIP>
> 
> > > > So refactor would be
> > > common services that iw_cxgb4, cxgbi4, and cxgbit all use.    An example
> > > would be: iw_cxgb4/cm.c:send_connect(), and cxgb4i.c/send_act_open_req().
> > 
> > good and one code base which treats both sides.
> > 
> > > I didn't look at LRO at this point.
> > >
> > > Anyway, none of these are particularly difficult, but will require
> > > significant effort and time.  The current cxgbit series has had a lot of
> > > internal review and testing by the Chelsio iscsi team, and it would be great
> > > if this refactoring can be deferred with the promise that we will get it
> > > done for the 4.8 merge window.  Thoughts?
> > 
> > We've been there, e.g Intel recently sent iWARP driver and throughout
> > the review we realized that lots of the iwarp netlink code is shared
> > between existing drivers and the new driver, so the driver didn't get
> > in kernel X but rather X+1 after doing that fix, it's only off by
> > one...
> > 
> > I don't think we should be letting duplication of that extent to get
> > in, for Chelsio ppl that know the materials well better vs anyone else
> > it should have been clear that they create that dup without any real
> > justification and till  that moment they didn't come here to even
> > comment on that. Lets have them fix that for the next merge window,
> > that's my thinking, Nic?
> > 
> 
> Varun + Co have made common improvements between existing software
> iscsi-target RX + TX PDU handling and their new driver, and no further
> comments for these prerequisites have been made.
> 
> The additional improvements discussed here so far are cxgb* specific,
> and will not effect other drivers, and will not change configfs user ABI
> layout compatibility within /sys/kernel/config/target/iscsi/.
> 
> That being the case, I think it's a reasonable starting point for
> mainline users to consume target ISO on cxgb hardware, and for Chelsio
> to make further common code improvements across their existing host
> drivers.

I agree that we can refactor initiator, target and iwarp drivers to
reduce code duplication as Steve has mentioned. We will work on this for
4.8 merge window.

Regards,
Varun
