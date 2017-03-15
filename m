From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [scsi] scsi: ufs: don't check unsigned type for a negative value
Date: Wed, 15 Mar 2017 15:57:09 -0700
Message-ID: <ff45704c3fcc601bf67149bd69cfdc23@codeaurora.org>
References: <20170312102202.9889-1-tomas.winkler@intel.com>
 <cf0e9b50910b10166d23cb37e9f5b4b0@codeaurora.org>
 <1489598802.2387.25.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1489598802.2387.25.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2017-03-15 10:26, James Bottomley wrote:
> On Mon, 2017-03-13 at 17:19 -0700, Subhash Jadavani wrote:
>> On 2017-03-12 03:22, Tomas Winkler wrote:
>> > Fix compilation warning
>> >
>> > drivers/scsi/ufs/ufshcd.c:7645:13: warning: comparison of unsigned
>> > expression < 0 is always false [-Wtype-limits]
>> > if ((value < UFS_PM_LVL_0) || (value >= UFS_PM_LVL_MAX))
>> >
>> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>> > ---
>> >  drivers/scsi/ufs/ufshcd.c | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> > index 1359913bf840..e8c26e6e6237 100644
>> > --- a/drivers/scsi/ufs/ufshcd.c
>> > +++ b/drivers/scsi/ufs/ufshcd.c
>> > @@ -7642,7 +7642,7 @@ static inline ssize_t
>> > ufshcd_pm_lvl_store(struct
>> > device *dev,
>> >  	if (kstrtoul(buf, 0, &value))
>> >  		return -EINVAL;
>> >
>> > -	if ((value < UFS_PM_LVL_0) || (value >= UFS_PM_LVL_MAX))
>> > +	if (value >= UFS_PM_LVL_MAX)
>> >  		return -EINVAL;
>> >
>> >  	spin_lock_irqsave(hba->host->host_lock, flags);
>> 
>> LGTM.
>> Reviewed-by: Subhash Jadavani <subhashj@codaurora.org>
> 
> Mis-spelling someone else's email can be cut and paste; mis-spelling
> your own might be the early indications of an identity crisis.
> 
> We do cut and paste these tags, so getting your own name right for the
> purposes of git history is useful.
> 
> James

Oops, sorry for this. If you haven't already corrected this:
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>



-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
