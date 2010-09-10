From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCHSET #upstream] block,
 fs: replace HARDBARRIER with  FLUSH/FUA, take#2
Date: Fri, 10 Sep 2010 12:19:15 +0200
Message-ID: <4C8A0623.7060404@fusionio.com>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
	<4C87B5E2.6070207@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4C87B5E2.6070207@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tejun Heo <teheo@suse.de>
Cc: "jack@suse.cz" <jack@suse.cz>, "snitzer@redhat.com" <snitzer@redhat.com>, "mst@redhat.com" <mst@redhat.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "konishi.ryusuke@lab.ntt.co.jp" <konishi.ryusuke@lab.ntt.co.jp>, "hch@lst.de" <hch@lst.de>, "k-ueda@ct.jp.nec.com" <k-ueda@ct.jp.nec.com>, "vst@vlnb.net" <vst@vlnb.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "mpatocka@redhat.com" <mpatocka@redhat.com>, "swhiteho@redhat.com" <swhiteho@redhat.com>, "chris.mason@oracle.com" <chris.mason@oracle.com>, "tytso@mit.edu" <tytso@mit.edu>
List-Id: linux-scsi@vger.kernel.org

On 2010-09-08 18:12, Tejun Heo wrote:
> Hello, Jens.
> 
> I added Mike's cleanup patch and Kiyoshi's Tested-by and updated
> flush-fua branch accordingly.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git flush-fua
> 
> I guess it's about ready.  Please consider pulling it into the block
> tree so that it can get linux-next exposure.  If you want the whole
> patch series resent, please let me know.

Thanks Tejun, I'm pulling it in now.


-- 
Jens Axboe
