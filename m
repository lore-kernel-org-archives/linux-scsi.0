From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 16/18] block/bsg: move queue creation into
 bsg_setup_queue
Date: Fri, 27 Jan 2017 18:48:12 +0000
Message-ID: <1485542872.4267.20.camel@sandisk.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
	<1485365126-23210-17-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1485365126-23210-17-git-send-email-hch@lst.de>
Content-Language: en-US
Content-ID: <79C6E0D3CD57EE4CB9DAD33733096BF9@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-01-25 at 18:25 +0100, Christoph Hellwig wrote:
> Simply the boilerplate code needed for bsg nodes a bit.

Did you perhaps mean "Simplify"? Anyway, nice work!

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
