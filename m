From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [SCSI PATCH] sd: max-retries becomes configurable
Date: Thu, 27 Sep 2012 08:45:24 +0400
Message-ID: <1348721124.2509.1.camel@dabdike>
References: <20120924210049.GA18527@havoc.gtf.org>
	 <1348546019.2457.3.camel@dabdike> <yq1y5jw9pfd.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1y5jw9pfd.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-09-26 at 22:20 -0400, Martin K. Petersen wrote:
> >>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> 
> James> On Mon, 2012-09-24 at 17:00 -0400, Jeff Garzik wrote:
> >> 
> >> drivers/scsi/sd.c | 4 ++++ drivers/scsi/sd.h | 2 +- 2 files changed,
> >> 5 insertions(+), 1 deletion(-)
> 
> James> I'm not opposed in principle to doing this (except that it should
> James> be a sysfs parameter like all our other controls),
> 
> Now that we're in that department. I never got any feedback on the
> following patch.
> 
> Hannes told me in person that he felt the eh_timeout belonged in
> scsi_device and not in the request queue. Whereas I favored making it a
> block layer tunable despite currently only being used by SCSI. Any
> opinions?

request_queue makes more sense to me because there was once a plan to
move all our timeout processing to block.  I think it got stalled
somewhere, but this would act as a reminder.

James
