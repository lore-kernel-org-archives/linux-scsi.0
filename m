From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [dm-devel] split scsi passthrough fields out of struct request
 V2
Date: Thu, 26 Jan 2017 21:01:47 +0000
Message-ID: <1485464486.2540.12.camel@sandisk.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
         <1485455329.2540.7.camel@sandisk.com>
         <e8f4b084-be66-d5b3-5785-13b80642040f@fb.com>
         <1485456745.2540.9.camel@sandisk.com>
         <db7f9165-19db-d1f2-a2fa-7546da57741b@fb.com>
         <20170126185924.GA25289@lst.de>
         <ee95c6dd-cdb4-7da5-2d4a-ec14034eac7a@fb.com>
         <71e22257-0592-fdd3-25e5-a78ceced2ab9@sandisk.com>
         <4054e944-b28d-1cd6-574f-6cd90e28c301@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <4054e944-b28d-1cd6-574f-6cd90e28c301@fb.com>
Content-Language: en-US
Content-ID: <A3E9453B472B7B4588CB92504A7DE61C@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-01-26 at 13:54 -0700, Jens Axboe wrote:
> Your call path has blk_get_request() in it, I don't have
> that in my tree. Is it passing in the right mask?

Hello Jens,

There is only one blk_get_request() call in drivers/md/dm-mpath.c
and it looks as follows:

 	clone =3D blk_get_request(bdev_get_queue(bdev),
			rq->cmd_flags | REQ_NOMERGE,
			GFP_ATOMIC);

Bart.=
