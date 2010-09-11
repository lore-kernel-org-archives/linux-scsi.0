From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 23/41] dm: implement REQ_FLUSH/FUA support for bio-based
 dm
Date: Sat, 11 Sep 2010 08:19:33 -0400
Message-ID: <4C8B73D5.8000600@redhat.com>
References: <1283509796-1510-1-git-send-email-tj@kernel.org> <1283509796-1510-24-git-send-email-tj@kernel.org> <Pine.LNX.4.64.1009101410570.7839@hs20-bc2-1.build.redhat.com> <20100910184652.GA24470@redhat.com> <Pine.LNX.4.64.1009101456220.21834@hs20-bc2-1.build.redhat.com> <20100910192403.GA24582@redhat.com> <Pine.LNX.4.64.1009101554300.5286@hs20-bc2-1.build.redhat.com> <4C8AC0F5.5080206@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C8AC0F5.5080206@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>, agk@redhat.com, jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, hch@lst.de, konishi.ryusuke@lab.ntt.co.jp, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, vst@vlnb.net, jack@suse.cz, hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com, k-ueda@ct.jp.nec.com
List-Id: linux-scsi@vger.kernel.org

  On 09/10/2010 07:36 PM, Tejun Heo wrote:
> On 09/10/2010 10:06 PM, Mikulas Patocka wrote:
>> But I have my work rules that I learned: I use no git kernels and no
>> external patches (except Alasdair's patchset that I want to test). I only
>> use -rc or final kernels. I need a stable computer --- I don't want to
>> solve problems like "does it crash because I pulled something or does it
>> crash because I made a bug in my code?" So, put that into 2.6.37-rc1 and
>> I'll optimize flushes in dm for -rc2 or -rc3.
> Alright, I'm sorry but this is as far as I would go for dm conversion
> patches.  If you wanna split it further or do it your way, please feel
> free to.  I think it would be beneficial to do things now but, hey,
> you guys are maintaining dm part of the kernel, so it's up to you
> guys.  But, I think it would be silly for everyone else to wait for
> the rather special requirement for dm, so if we have to go forward
> without dm updates, I suppose we will have to.  Jens, please feel free
> to drop dm conversion patches.
>
> Thanks.
>

I think that we certainly want to continue to fix the whole path - including dm 
- so we do not end up with the fragmented set of works here/doesn't work there 
situation we had for several years. If Mikulas has better patches, he should 
post them for review.

Thanks!

Ric
