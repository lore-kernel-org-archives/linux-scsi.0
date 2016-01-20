From: Andrew Donnellan <andrew.donnellan-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 03/13] irq_poll: fold irq_poll_sched_prep into
 irq_poll_sched
Date: Wed, 20 Jan 2016 18:15:15 +1100
Message-ID: <569F3403.10309@au1.ibm.com>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
 <1449521512-22921-4-git-send-email-hch@lst.de> <5682584A.5030708@sandisk.com>
 <20151230094253.GB12904@lst.de> <569F3106.7000205@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <569F3106.7000205-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 20/01/16 18:02, Andrew Donnellan wrote:
> I'm hitting an issue on a ppc64le box running linux-next, which
> according to git bisect is caused by this patch.

Whoops, that should be linuxppc*-dev*@lists.ozlabs.org in the Cc.


Andrew

-- 
Andrew Donnellan              Software Engineer, OzLabs
andrew.donnellan-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org  Australia Development Lab, Canberra
+61 2 6201 8874 (work)        IBM Australia Limited

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
