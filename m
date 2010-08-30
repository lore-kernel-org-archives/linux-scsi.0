From: Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [RFC] training mpath to discern between SCSI errors
Date: Mon, 30 Aug 2010 16:07:48 +0400
Message-ID: <4C7B9F14.9080900@mvista.com>
References: <20100825155918.GB8509@redhat.com> <4C7B984E.4070802@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4C7B984E.4070802@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Tejun Heo <tj@kernel.org>, michaelc@cs.wisc.edu, James.Bottomley@suse.de, tytso@mit.edu, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, jack@suse.cz, linux-kernel@vger.kernel.org, swhiteho@redhat.com, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org, vst@vlnb.net, rwheeler@redhat.com, Christoph Hellwig <hch@lst.de>, chris.mason@oracle.com, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

Hello.

Hannes Reinecke wrote:

> Actually, I think we have two separate issues here:
> 1) The need of having more detailed I/O errors even in the fs layer. This
>    we've already discussed at the LSF, consensus here is to allow other
>    errors than just 'EIO'.
>    Instead of Mike's approach I would rather use existing error codes here;
>    this will make the transition somewhat easier.
>    Initially I would propose to return 'ENOLINK' for a transport failure,
>    'EIO' for a non-retryable failure on the target, and 'ENODEV' for a
>    retryable failure on the target.

    Are you sure it's not vice versa: EIO for retryable and ENODEV for 
non-retryable failures. ENODEV looks more like permanent condition to me.

WBR, Sergei
