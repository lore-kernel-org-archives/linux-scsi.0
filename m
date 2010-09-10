From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 23/41] dm: implement REQ_FLUSH/FUA support for bio-based
 dm
Date: Sat, 11 Sep 2010 01:36:21 +0200
Message-ID: <4C8AC0F5.5080206@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org> <1283509796-1510-24-git-send-email-tj@kernel.org> <Pine.LNX.4.64.1009101410570.7839@hs20-bc2-1.build.redhat.com> <20100910184652.GA24470@redhat.com> <Pine.LNX.4.64.1009101456220.21834@hs20-bc2-1.build.redhat.com> <20100910192403.GA24582@redhat.com> <Pine.LNX.4.64.1009101554300.5286@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:54932 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841Ab0IJXf7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Sep 2010 19:35:59 -0400
In-Reply-To: <Pine.LNX.4.64.1009101554300.5286@hs20-bc2-1.build.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, agk@redhat.com, jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, hch@lst.de, konishi.ryusuke@lab.ntt.co.jp, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com, k-ueda@ct.jp.nec.com

On 09/10/2010 10:06 PM, Mikulas Patocka wrote:
> But I have my work rules that I learned: I use no git kernels and no 
> external patches (except Alasdair's patchset that I want to test). I only 
> use -rc or final kernels. I need a stable computer --- I don't want to 
> solve problems like "does it crash because I pulled something or does it 
> crash because I made a bug in my code?" So, put that into 2.6.37-rc1 and 
> I'll optimize flushes in dm for -rc2 or -rc3.

Alright, I'm sorry but this is as far as I would go for dm conversion
patches.  If you wanna split it further or do it your way, please feel
free to.  I think it would be beneficial to do things now but, hey,
you guys are maintaining dm part of the kernel, so it's up to you
guys.  But, I think it would be silly for everyone else to wait for
the rather special requirement for dm, so if we have to go forward
without dm updates, I suppose we will have to.  Jens, please feel free
to drop dm conversion patches.

Thanks.

-- 
tejun
