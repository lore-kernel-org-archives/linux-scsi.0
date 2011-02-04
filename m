From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: Re: [PATCH 04/06] mptfusion: mptctl_release is required in
 mptctl.c
Date: Fri, 4 Feb 2011 12:20:59 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED71121F381@inbmail01.lsi.com>
References: <20110203100250.GE23502@lsi.com> <20110203171930.GA11533@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <stable-bounces@linux.kernel.org>
In-Reply-To: <20110203171930.GA11533@kroah.com>
Content-Language: en-US
List-Unsubscribe: <http://linux.kernel.org/mailman/options/stable>,
	<mailto:stable-request@linux.kernel.org?subject=unsubscribe>
List-Archive: <http://linux.kernel.org/mailman/private/stable/>
List-Post: <mailto:stable@linux.kernel.org>
List-Help: <mailto:stable-request@linux.kernel.org?subject=help>
List-Subscribe: <http://linux.kernel.org/mailman/listinfo/stable>,
	<mailto:stable-request@linux.kernel.org?subject=subscribe>
Sender: stable-bounces@linux.kernel.org
Errors-To: stable-bounces@linux.kernel.org
To: Greg KH <greg@kroah.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "Prakash,
	Sathya" <Sathya.Prakash@lsi.com>, "Moore, Eric" <Eric.Moore@lsi.com>, "stable@kernel.org" <stable@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Thursday, February 03, 2011 10:50 PM
> To: Desai, Kashyap
> Cc: linux-scsi@vger.kernel.org; James.Bottomley@HansenPartnership.com;
> Prakash, Sathya; Moore, Eric; stable@kernel.org
> Subject: Re: [stable] [PATCH 04/06] mptfusion: mptctl_release is
> required in mptctl.c
> 
> On Thu, Feb 03, 2011 at 03:33:00PM +0530, Kashyap, Desai wrote:
> >
> > Added missing release callback for file_operations mptctl_fops.
> > Without release callback there will be never freed. It remains on
> > mptctl's eent list even after the file is closed and released.
> >
> > Relavent RHEL bugzilla is 660871
> >
> > Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> > ---
> 
> <snip>
> 
> This is NOT the way to get patches into a stable kernel release.
> Please
> read the file, Documentation/stable_kernel_rules.txt for how to do it
> properly.


Greg, Thanks for the redirecting to correct process. I understood that I have to add "CC: stable@kernel.org " in header of the patch itself instead of 
CCing stable@kernel.org from email client.
Do I need to resend those patches?

~ Kashyap

> 
> thanks,
> 
> greg k-h
