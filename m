From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] SRP transport: Move queuecommand() wait code to SCSI core
Date: Tue, 29 Nov 2016 11:22:42 -0500
Message-ID: <yq1k2bmp86l.fsf@sermon.lab.mkp.net>
References: <39d8cb23-0406-e8c3-6e3a-a467ebe41470@sandisk.com>
        <649cb037-3196-df4d-0d31-47f040ce44a2@sandisk.com>
        <0187d160-5985-32c4-95c0-466c4f09bdf9@mellanox.com>
        <BLUPR02MB16836EF63187DE03E7F1DD77818D0@BLUPR02MB1683.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BLUPR02MB16836EF63187DE03E7F1DD77818D0-Y8PPn9RqzNfZ9ihocuPUdanrV9Ap65cLvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
        (Bart Van Assche's message of "Tue, 29 Nov 2016 14:59:37 +0000")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-scsi@vger.kernel.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Bart" == Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> writes:

Bart> On 11/25/16 15:21, Max Gurtovoy wrote:
>> the arg is sdev.

Bart> Good catch.

Bart> Martin, do you want me to repost this patch or do you want me to
Bart> post a fix-up patch?

I fixed it up.

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
