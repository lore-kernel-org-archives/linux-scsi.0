From: "Zou, Yi" <yi.zou-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3] scsi_lib: rate-limit the error message
 from failing commands
Date: Mon, 24 Sep 2012 18:57:32 +0000
Message-ID: <138EA028228D124A900F5E6746F3C2162F4F66C7@ORSMSX102.amr.corp.intel.com>
References: <20120830210607.28119.96438.stgit@localhost6.localdomain6>
 <503FF64C.6040409@kernel.dk>
 <CAMM=eLdhuqKij12zXxTWJ9wMEHp3HxZJxbCHGCRbzBE647WK8A@mail.gmail.com>
 <1348301491.2476.3.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1348301491.2476.3.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.open-fcoe.org/mailman/options/devel>,
 <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.open-fcoe.org/mailman/listinfo/devel>,
 <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "www.Open-FCoE.org" <devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tomas Henzl <thenzl-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

> On Fri, 2012-09-21 at 15:15 -0400, Mike Snitzer wrote:
> > On Thu, Aug 30, 2012 at 7:25 PM, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org> wrote:
> > > On 2012-08-30 14:06, Yi Zou wrote:
> > >> [
> > >> Jens/James,
> > >>
> > >> This is a rather old rate limt patch but never gets picked up in upstream, so I
> > >> am resending it here as v3, with some minor changes so it is directly
> applicable
> > >> to the current linux-2.6.git tree. I don't have that many LUNs that the
> original
> > >> issue was reported but the patch was already reviewed and acked in the
> past,
> > >> I did retest w/ stress I/O on 4 LUNs I have right now.
> > >>
> > >> Original thread can be found at:
> > >> http://comments.gmane.org/gmane.linux.scsi/73497
> > >> http://www.open-fcoe.org/patchwork/patch/2436/
> > >>
> > >> Can you please pull this patch in? it's been hanging there for a long time.
> > >> Original patch description is below.
> > >
> > > I've pulled in the block bit.
> >
> > James,
> >
> > Do you intend to pick up the scsi_lib.c change?
> 
> Possibly, if someone resends.  The original v3 patch isn't actually on
> the list that I can find.
> 
> James
> 
Thanks,  I will resend shortly w/ the scsi_lib part.

yi
