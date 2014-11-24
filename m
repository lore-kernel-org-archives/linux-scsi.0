From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v3 09/11] IB/srp: Use block layer tags
Date: Mon, 24 Nov 2014 16:43:27 +0100
Message-ID: <5473521F.2080409@acm.org>
References: <545240AE.6060009@acm.org> <545241C7.5010707@acm.org> <20141112104537.GA13223@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141112104537.GA13223-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 11/12/14 11:45, Christoph Hellwig wrote:
> FYI, I've updated this to use .use_blk_tags = 1 isntead of
> scsi_activate_tcq now that I've rebased the drivers-for-3.19 branch
> over the tcq rework.  Please verify that it's workign as intented.

[ just arrived home from traveling ]

Hello Christoph,

The SRP initiator passes the same tests as before. I have checked with 
ibdump and Wireshark that the SRP tags are still assigned properly. 
These tests have been run with and without blk-mq (use_blk_mq=Y versus 
N). The code I have tested is branch drivers-for-3.19 / commit 
18f87a67e6d681d1c6f8b3c47985f21b25959a77.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
