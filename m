From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: SCSI Command scatter-gather number
Date: Tue, 30 Jul 2002 14:43:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020730144326.A26330@beaverton.ibm.com>
References: <F6A3AFC9BCD92E48B79C14E4AAAEA20F45A678@nonamea.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <F6A3AFC9BCD92E48B79C14E4AAAEA20F45A678@nonamea.ptu.promise.com>; from haofengk@ptu.promise.com on Tue, Jul 30, 2002 at 02:07:49PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Haofeng Kou <haofengk@ptu.promise.com>
Cc: linux-scsi@vger.kernel.org

On 2.4 the use_sg value should be limited to the smaller of MAX_SEGMENTS
or the scsi host sg_tablesize.

This is checked in the block interface during __make_request. I believe if
you got through the sg interface the limiting value is only sg_tablesize,
but Doug is the best one to answer that.

-Mike

Haofeng Kou [haofengk@ptu.promise.com] wrote:
> For the "struct scsi_cmnd", there is a member :
> 	unsigned short use_sg;
> Which gives the Number of pieces of the scatter-gather.
> 
> How to limit its value, how to set the max value for the "use_sg"?
> 
> 
> Thanks,
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michael Anderson
andmike@us.ibm.com

