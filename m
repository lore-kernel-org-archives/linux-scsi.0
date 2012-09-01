From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 0/5] Fix bugs in ib_srp patches for H.A. purposes
Date: Sat, 01 Sep 2012 08:09:57 +0000
Message-ID: <5041C2D5.1040503@acm.org>
References: <1346443241-24844-1-git-send-email-dongsu.park@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1346443241-24844-1-git-send-email-dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Cc: dillowda-1Heg1YXhbW8@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 08/31/12 20:00, dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org wrote:
> This patchset aims at fixing bugs that have been discovered in our own
> SRP test environment so far. These patches are based on your patchset v4,
> "Make ib_srp better suited for H.A. purposes",(09 Aug 2012).
> 
> The 5th patch, "fix an error accessing invalid memory in
> rport_dev_loss_timedout" is including your suggestion (30 Aug 2012).
> 
> You can also pull the following git repo to get the patches.
> 
>   git://github.com/advance38/linux.git srp-ha
> 
> Our test setup consists of two systems.
> Kernel 3.2.15 with SCST v4193 on the target,
> and Kernel 3.2.8 with ib_srp-ha on the initiator.
> Although I rebased the patches again onto 3.6-rc3,
> I suppose there will be no significant differences.
> 
> All of the known critical issues seem to have been resolved
> according to our internal tests in the last weeks.

Thanks for the testing and the feedback. Let's hope that the ib_srp
maintainer will be able to review these patches soon. For the linux-scsi
and LKML readers: I've sent my feedback about this patch series to the
linux-rdma mailing list only.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
