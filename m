From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: 2.6.39-rc5+ BUG at scsi_run_queue+0x24/0xe3
Date: Tue, 03 May 2011 15:36:25 -0500
Message-ID: <1304454985.14015.3.camel@mulgrave.site>
References: <4DC0330F.6050906@sandia.gov>
	 <1304442019.10982.7.camel@mulgrave.site> <4DC03B0A.50209@sandia.gov>
	 <1304444251.10982.9.camel@mulgrave.site> <4DC0415F.5020509@sandia.gov>
	 <4DC04EF0.4020909@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DC04EF0.4020909@sandia.gov>
Sender: linux-kernel-owner@vger.kernel.org
To: Jim Schutt <jaschut@sandia.gov>
Cc: linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-05-03 at 12:52 -0600, Jim Schutt wrote:
> FWIW, I noticed that commit 99f3c722e23 in scsi-rc-fixes-2.6
> might want a Cc: stable@kernel.org, since the commit it's
> fixing, 86cbfb5607d4, had one.
> 
> I'm not sure how that all works, but I thought I'd mention it
> just in case.

Yes, good point; I'll add it ... destabilising the stable kernels
wouldn't be a very good idea.

James
