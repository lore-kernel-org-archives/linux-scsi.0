From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mq and end_clone_request()
Date: Tue, 2 Aug 2016 20:40:14 -0400
Message-ID: <20160803004013.GA19956@redhat.com>
References: <536022978.7668211.1470060125271.JavaMail.zimbra@redhat.com>
	<931235537.7668834.1470060339483.JavaMail.zimbra@redhat.com>
	<1264951811.7684268.1470065187014.JavaMail.zimbra@redhat.com>
	<17da3ab0-233a-2cec-f921-bfd42c953ccc@sandisk.com>
	<20160801175948.GA6685@redhat.com>
	<f9e71e1d-54ca-40fe-a5ea-ae2863c94ff9@sandisk.com>
	<20160801204628.GA94704@redhat.com>
	<8e265fcc-8021-830e-ffcb-23a8a28ec247@sandisk.com>
	<20160802174533.GA18714@redhat.com>
	<1a460c29-1530-d3e1-25ba-736d86aff12e@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1a460c29-1530-d3e1-25ba-736d86aff12e@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Laurence Oberman <loberman@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 02 2016 at  8:19pm -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 08/02/2016 10:45 AM, Mike Snitzer wrote:
> > Please do these same tests against a v4.7 kernel with the 4 patches from
> > this branch applied (no need for your other debug patches):
> > https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-4.7-mpath-fixes
> > 
> > I've had good results with my blk-mq SRP based testing.
> 
> Hello Mike,
> 
> Thanks again for having made these patches available. The results of my
> tests are as follows:

Disappointing.  But I asked you to run the v4.7 kernel patches I
pointed to _without_ any of your debug patches.

I cannot reproduce on our SRP testbed with the fixes I provided.  We're
now in a place where there would appear to be something very unique to
your environment causing these failures.
