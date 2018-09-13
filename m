From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH RFC] scsi: ufs: Disable blk-mq for now
Date: Thu, 13 Sep 2018 20:05:00 +0800
Message-ID: <20180913120459.GA4965@ming.t460p>
References: <20180913112848.7807-1-adrian.hunter@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180913112848.7807-1-adrian.hunter@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Bart Van Assche <Bart.VanAssche@wdc.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Evan Green <evgreen@chromium.org>, Vinayak Holikatti <vinholikatti@gmail.com>, Janek Kotas <jank@cadence.com>, Vivek Gautam <vivek.gautam@codeaurora.org>, Asutosh Das <asutoshd@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Sayali Lokhande <sayalil@codeaurora.org>, Li Wei <liwei213@huawei.com>, Bjorn Andersson <bjorn.andersson@linaro.org>, Jaegeuk Kim <jaegeuk@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 13, 2018 at 02:28:48PM +0300, Adrian Hunter wrote:
> blk-mq does not support runtime pm, so disable blk-mq support for now.

So could you describe a bit what the issue you are trying to fix?

This is host level runtime PM you are trying to address, and if blk-mq
runtime isn't enabled, I guess the host won't be runtime suspended at all
because some of its descendant are always active.

So seems we need to do nothing for preventing the host controller from
entering runtime suspend.

Thanks,
Ming
