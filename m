From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: pd: remove bogus check for req->errors
Date: Tue, 18 Apr 2017 22:59:11 +0000
Message-ID: <1492556350.2689.23.camel@sandisk.com>
References: <20170418155229.5977-1-hch@bombadil.infradead.org>
         <20170418155229.5977-22-hch@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170418155229.5977-22-hch@bombadil.infradead.org>
Content-Language: en-US
Content-ID: <5C43188B80C9CD47B530D05CDB6DD0F9@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "hch@bombadil.infradead.org" <hch@bombadil.infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "roger.pau@citrix.com" <roger.pau@citrix.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jbacik@fb.com" <jbacik@fb.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-04-18 at 08:52 -0700, Christoph Hellwig wrote:
> The driver never sets req->errors

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>=
