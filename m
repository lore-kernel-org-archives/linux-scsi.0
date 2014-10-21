From: "Subhash Jadavani" <subhashj@codeaurora.org>
Subject: RE: [PATCH 1/1] ufs: scsi: fix sparse errors in ufshcd_system_suspend
Date: Tue, 21 Oct 2014 11:50:17 -0700
Message-ID: <000a01cfed5f$dbf36070$93da2150$@codeaurora.org>
References: <1412518207-27135-1-git-send-email-draviv@codeaurora.org> <000301cfe0ed$e5221200$af663600$@codeaurora.org> <20141011110629.GA9161@infradead.org> <20141021140556.GA11823@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <20141021140556.GA11823@infradead.org>
Content-Language: en-us
Sender: linux-arm-msm-owner@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: 'Dolev Raviv' <draviv@codeaurora.org>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com
List-Id: linux-scsi@vger.kernel.org

> Are you going to prepare a set of fixups for 3.18, or should I try to cram
them together?  I supect you'd do a much better job than I could.

Agreed. There are 3 patches already posted for sparse warning fixes but then
there were 5 new reports of sparse warning. So we (Dolev Raviv and myself)
would try to fix them soon and post all 8 patches as single patch series so
that it would be easy trace. In addition, there will be one more fix for the
issue reported by Akinobu Mita, will include it in the same in patch series.
We should be able to send you these fixes by early next week if not earlier.

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Christoph Hellwig
Sent: Tuesday, October 21, 2014 7:06 AM
To: Subhash Jadavani
Cc: 'Dolev Raviv'; James.Bottomley@HansenPartnership.com;
linux-scsi@vger.kernel.org; linux-arm-msm@vger.kernel.org;
santoshsy@gmail.com
Subject: Re: [PATCH 1/1] ufs: scsi: fix sparse errors in
ufshcd_system_suspend

On Sat, Oct 11, 2014 at 04:06:29AM -0700, Christoph Hellwig wrote:
> On Sun, Oct 05, 2014 at 03:44:16PM -0700, Subhash Jadavani wrote:
> > Looks good, Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
> 
> I'm getting a bit lost with all the UFS fixes, can you prepared a 
> series with all the fixups required for 3.18 for me please?

Are you going to prepare a set of fixups for 3.18, or should I try to cram
them together?  I supect you'd do a much better job than I could.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html
