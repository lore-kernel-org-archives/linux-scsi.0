From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [LFS/MM TOPIC][LFS/MM ATTEND]: - Storage Stack and Driver
 Testing methodology.
Date: Wed, 11 Jan 2017 01:24:47 -0800
Message-ID: <20170111092447.GA13600@infradead.org>
References: <CO2PR04MB218427BF42159B20FB26F74186670@CO2PR04MB2184.namprd04.prod.outlook.com>
 <CO2PR04MB2184DB653C04FB620B41435486670@CO2PR04MB2184.namprd04.prod.outlook.com>
 <20170111091945.GD6286@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170111091945.GD6286@linux-x5ow.site>
Sender: linux-ide-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 11, 2017 at 10:19:45AM +0100, Johannes Thumshirn wrote:
> Well, something I was thinking about but didn't find enough time to actually
> implement is making a xfstestes like test suite written using sg3_utils for
> SCSI.

Ronnie's libiscsi testsuite can use SG_IO for a new years now:

https://github.com/sahlberg/libiscsi/tree/master/test-tool

and has been very useful to find bus in various protocol
implementations.

> This idea could very well be extented to NVMe

Chaitanya suite is doing something similar for NVMe, although the
coverage is still much more limited so far.
