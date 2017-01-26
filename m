From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 02/18] md: cleanup bio op / flags handling in
 raid1_write_request
Date: Thu, 26 Jan 2017 23:18:53 +0000
Message-ID: <1485472714.2540.21.camel@sandisk.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
         <1485365126-23210-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1485365126-23210-3-git-send-email-hch@lst.de>
Content-Language: en-US
Content-ID: <02C464BCEA49C449B002154DE3011676@sandisk.com>
Sender: linux-raid-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-01-25 at 18:25 +0100, Christoph Hellwig wrote:
> No need for the local variables, the bio is still live and we can just
> assigned the bits we want directly.  Make me wonder why we can't assign
> all the bio flags to start with.

I assume that you ment "assign" in the patch description? Anyway:

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>=
