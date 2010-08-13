From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 02/11] block: kill QUEUE_ORDERED_BY_TAG
Date: Fri, 13 Aug 2010 16:56:32 +0400
Message-ID: <4C654100.3060307@vlnb.net>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <1281616891-5691-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1281616891-5691-3-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>, Jeremy Fitzhardinge <jeremy@xensource.com>, Chris Wright <chrisw@sous-sol.org>
List-Id: linux-scsi@vger.kernel.org

Hello Tejun,

Tejun Heo, on 08/12/2010 04:41 PM wrote:
> Nobody is making meaningful use of ORDERED_BY_TAG now and queue
> draining for barrier requests will be removed soon which will render
> the advantage of tag ordering moot.

Have you seen Hannes Reinecke's and my measurements in 
http://marc.info/?l=linux-scsi&m=128110662528485&w=2 and 
http://marc.info/?l=linux-scsi&m=128111995217405&w=2 correspondingly?

If yes, what else evidences do you need to see that the tag ordering is 
a big performance win?

Vlad
