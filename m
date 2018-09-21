From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH RFC] scsi: ufs: Disable blk-mq for now
Date: Thu, 20 Sep 2018 21:59:49 -0400
Message-ID: <yq1lg7vmwyy.fsf@oracle.com>
References: <20180913112848.7807-1-adrian.hunter@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180913112848.7807-1-adrian.hunter@intel.com> (Adrian Hunter's
        message of "Thu, 13 Sep 2018 14:28:48 +0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, Bart Van Assche <Bart.VanAssche@wdc.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Evan Green <evgreen@chromium.org>, Vinayak Holikatti <vinholikatti@gmail.com>, Janek Kotas <jank@cadence.com>, Vivek Gautam <vivek.gautam@codeaurora.org>, Asutosh Das <asutoshd@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Sayali Lokhande <sayalil@codeaurora.org>, Li Wei <liwei213@huawei.com>, Bjorn Andersson <bjorn.andersson@linaro.org>Jaegeuk Kim <ja>
List-Id: linux-scsi@vger.kernel.org


Adrian,

> blk-mq does not support runtime pm, so disable blk-mq support for now.

Applied to 4.19/scsi-fixes. Looking forward to getting this fixed up
properly in 4.20.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
