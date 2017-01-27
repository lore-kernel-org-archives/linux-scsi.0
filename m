From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: split scsi passthrough fields out of struct request
 V2
Date: Fri, 27 Jan 2017 17:03:31 +0000
Message-ID: <1485536585.4267.4.camel@sandisk.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
	<1485456745.2540.9.camel@sandisk.com>
	<db7f9165-19db-d1f2-a2fa-7546da57741b@fb.com>
	<20170126185924.GA25289@lst.de>
	<ee95c6dd-cdb4-7da5-2d4a-ec14034eac7a@fb.com>
	<71e22257-0592-fdd3-25e5-a78ceced2ab9@sandisk.com>
	<4054e944-b28d-1cd6-574f-6cd90e28c301@fb.com>
	<1485464486.2540.12.camel@sandisk.com>
	<6995c991-65a4-8dca-c36e-fb2eff277ca9@fb.com>
	<1485467235.2540.14.camel@sandisk.com>
	<e1d5f4e6-c63f-545d-710f-d4d10fa8d2e0@fb.com>
	<1485472465.2540.19.camel@sandisk.com>
	<e222c541-3239-104d-e0b0-40d19b012b66@fb.com>
	<1485474426.2540.25.camel@sandisk.com>
	<b98195e7-6e04-5a59-8b83-ce2e1c5c4e1a@fb.com>
	<1485477510.2540.27.camel@sandisk.com>
	<2d971693-b79d-c1b9-fb2a-f5dd04128c68@fb.com>
	<1485479738.2540.30.camel@sandisk.com>
	<ecca734c-7a9c-f060-9335-c2de089849c2@fb.com>
	<37ab009a-bc2d-d2ae-a875-269ab563a430@fb.com>
	<9cbf0ce5-ed79-0252-fd2d-34bebaafffa3@fb.com>
	<1485535925.4267.1.camel@sandisk.com>
	<2c696943-2a44-4f36-f0f8-0bebceb95a4a@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2c696943-2a44-4f36-f0f8-0bebceb95a4a@fb.com>
Content-Language: en-US
Content-ID: <CACC1F5A0BD21D429CF31B4081BFA143@sandisk.com>
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

On Fri, 2017-01-27 at 09:56 -0700, Jens Axboe wrote:
> I have no idea what this is, I haven't messed with life time or devices
> or queues at all in that branch.

The srp-test software passes with kernel v4.9. Something must have changed.
I'll see whether I can find some time to look further into this.

Bart.
