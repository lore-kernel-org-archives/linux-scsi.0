From: Varun Prakash <varun@chelsio.com>
Subject: Re: [PATCH v3 13/13] cxgbit: add files for cxgbit.ko
Date: Fri, 8 Jul 2016 23:33:56 +0530
Message-ID: <20160708180354.GA1658@chelsio.com>
References: <CAJ3xEMgtsPiatZ-Cy2ENsGVyKVDQSSHi4jr0Ushg21JiuqdLcw@mail.gmail.com>
 <1464072025.22249.87.camel@haakon3.risingtidesystems.com>
 <CAJ3xEMjE3pfz7+QKMUheH9P+xyvj81qbCtbod0mBi7pUspMRXg@mail.gmail.com>
 <011401d1b6ac$917ea000$b47be000$@opengridcomputing.com>
 <CAJ3xEMhm4eemgvgbpCEKc86LbKSi3WKUX7d+57KwwtZbJB52Wg@mail.gmail.com>
 <1464238504.22249.168.camel@haakon3.risingtidesystems.com>
 <20160526185819.GA1672@chelsio.com>
 <CAJ3xEMgdx5uFdwgdhoAXBFK6dCN59xLH0bta2j3DxMGZ31Fbsg@mail.gmail.com>
 <20160706171703.GA1685@chelsio.com>
 <CAJ3xEMhnmcJHrBot4yiz6obS9a8rHOZVNP-EfQHCAFbJhFMcZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [12.32.117.8] ([12.32.117.8]:56511 "EHLO stargate.chelsio.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbcGHSEL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Jul 2016 14:04:11 -0400
Content-Disposition: inline
In-Reply-To: <CAJ3xEMhnmcJHrBot4yiz6obS9a8rHOZVNP-EfQHCAFbJhFMcZg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Or Gerlitz <gerlitz.or@gmail.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Steve Wise <swise@opengridcomputing.com>, target-devel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, kxie@chelsio.com, indranil@chelsio.com

On Thu, Jul 07, 2016 at 10:54:20AM +0300, Or Gerlitz wrote:
> On Wed, Jul 6, 2016 at 8:17 PM, Varun Prakash <varun@chelsio.com> wrote:
> > On Wed, Jul 06, 2016 at 12:24:43AM +0300, Or Gerlitz wrote:
> >> On Thu, May 26, 2016 at 9:58 PM, Varun Prakash <varun@chelsio.com> wrote:
> >>
> >> > Hi Or, Nicholas and Steve
> >> > Thank you for the feedback and apologies for the delay in my response.
> >>
> >> > I agree that we can refactor initiator, target and iwarp drivers to
> >> > reduce code duplication as Steve has mentioned. We will work on this for
> >> > 4.8 merge window.
> >>
> >> Nic, Varun, was anything done on this matter? we're on rc6
> >
> > Yes, I am working on this, I will post first series
> > within two days, it will add common library module libcxgb.ko.
> 
> thanks for the update, the plan was to get that info 4.8-rc1,
> and as we're after rc6 there's not much time left for submitting code
> for 4.8, so doing that sooner rather than later would be good here.
> 
> > In first series libcxgb.ko will have common
> > iSCSI DDP Page Pod Manager that will be shared
> > by three Chelsio iSCSI drivers
> > cxgb3i, cxgb4i, cxgbit.
> 
> cool
> 
> > In subsequent series I will add common connection
> > management and other hardware specific common code
> > in this module.
> 
> any chance to get that ready for 4.8 too?

I am working on common connection management, it is a
big change as it involves multiple modules, so it is
difficult to get it ready for 4.8.   
