From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 10/13] IB/srp: use the new CQ API
Date: Sun, 13 Dec 2015 12:26:52 +0200
Message-ID: <566D47EC.3000000@dev.mellanox.co.il>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
 <1449521512-22921-11-git-send-email-hch@lst.de>
 <5669C7AA.4080206@sandisk.com> <20151211142220.GB20201@lst.de>
 <566B0EE5.8080602@redhat.com> <20151212080833.GA32638@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151212080833.GA32638-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


> Allright.  How do you want to proceed?  The current rdma-cq branch
> has all kinds of dependencies, but I've also prepared a new rdma-cq.2
> branch that could go straight on top of your current queue:
>
> http://git.infradead.org/users/hch/rdma.git/shortlog/refs/heads/rdma-cq.2
>
> If you're ready to start the 4.5 tree I can send those out as a patch
> series.

Will this get on top of iser-remote-inv? Or should I resend atop of this?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
