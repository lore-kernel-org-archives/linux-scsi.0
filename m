From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/3] ps3: Disk Storage Driver
Date: Tue, 24 Jul 2007 18:21:30 -0700
Message-ID: <20070724182130.6ebcca00.akpm@linux-foundation.org>
References: <20070716161539.075822000@pademelon.sonytel.be>
	<20070716162206.392129000@pademelon.sonytel.be>
	<20070718163637.3f0e0164.akpm@linux-foundation.org>
	<46A5E610.7000508@shadowen.org>
	<18086.41665.610756.139183@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org>
In-Reply-To: <18086.41665.610756.139183@cargo.ozlabs.ibm.com>
List-Unsubscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
To: Paul Mackerras <paulus@samba.org>
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 25 Jul 2007 11:09:21 +1000 Paul Mackerras <paulus@samba.org> wrote:

> Also, I prefer the style where the ? and : operators have a space
> after them but not before them, rather than a space either side.

Could I point out that your likes and dislikes are immaterial?  The whole
point here is to get kernel code looking consistent.  That means that
basically everyone ends up doing things which they'd prefer not to do. 
That certainly applies to me.  

The idea is that the benefit of making things consistent exceeds the costs
of some individuals adopting styles which they are less used to.


So telling people what you do and don't like is simply irrelevant, except
for when it is used as an input in determining what the standard kernel
style is to be.  (And that is largely determined by observing what we have
now).

And sure, major subsytems can and do go off and do their own thing - ia64
for example has done a lot of that, pretty consistently.  The world hasn't
ended as a result.
