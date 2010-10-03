From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [Bug 19642] New: 2.6.36-rc6 BUG at
	drivers/scsi/scsi_lib.c:1113
Date: Sun, 3 Oct 2010 17:00:03 -0400
Message-ID: <20101003210002.GA4050@redhat.com>
References: <bug-19642-11613@https.bugzilla.kernel.org/>
	<1286132006.2984.32.camel@mulgrave.site>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1286132006.2984.32.camel@mulgrave.site>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-raid@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Oct 03 2010 at  2:53pm -0400,
James Bottomley <James.Bottomley@suse.de> wrote:

> On Sun, 2010-10-03 at 18:37 +0000, bugzilla-daemon@bugzilla.kernel.org
> wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=19642
> > 
> >            Summary: 2.6.36-rc6 BUG at drivers/scsi/scsi_lib.c:1113
> >            Product: IO/Storage
> >            Version: 2.5
> >     Kernel Version: 2.6.36-rc6
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: SCSI
> >         AssignedTo: linux-scsi@vger.kernel.org
> 
> I think this is wrong.
> 
> >         ReportedBy: maciej.rutecki@gmail.com
> >                 CC: rjw@sisk.pl, maciej.rutecki@gmail.com,
> >                     linux@horizon.com
> >         Regression: Yes
> > 
> > 
> > Subject    : 2.6.36-rc6 BUG at drivers/scsi/scsi_lib.c:1113
> > Submitter  : "George Spelvin" <linux@horizon.com>
> > Date       : 2010-09-30 21:10
> > Message-ID : 20100930211006.27449.qmail@science.horizon.com
> > References : http://marc.info/?l=linux-kernel&m=128588102620299&w=2
> 
> That looks like a zero length barrier send down to SCSI with the RW flag
> set (hence we try to map a buffer that has nothing to map).  I cc'd
> dm-devel to see what their opinion is.

Given that the referenced LKML report is MD focused it seems linux-raid
should be cc'd instead (doing so now).

Mike
