From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH 0/5]stop normal completion path entering a timeout req
Date: Thu, 21 Jun 2018 15:15:29 -0600
Message-ID: <20180621211529.GA27589@localhost.localdomain>
References: <1529500964-28429-1-git-send-email-jianchao.w.wang@oracle.com>
 <20180620181601.GA24145@localhost.localdomain>
 <e87f5946-bb21-942e-2dcc-b24cee1ad23c@oracle.com>
 <20180621081900.GA5183@lst.de>
 <84a5b54c318b130f47775747d37dc139c27ebda7.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <84a5b54c318b130f47775747d37dc139c27ebda7.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@lst.de" <hch@lst.de>, "jianchao.w.wang@oracle.com" <jianchao.w.wang@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "josef@toxicpanda.com" <josef@toxicpanda.com>, "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 21, 2018 at 06:21:09PM +0000, Bart Van Assche wrote:
> That's not how the SCSI core works.

How does it work? Jianchao is advocating for holes in software
to ignore reacting to hardware events and force unnecessary error
escalation. Putting holes in kernel software can't possibly be our
only recourse.
