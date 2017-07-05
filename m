From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [lkp-robot] [scsi] 5c279bd9e4: blogbench.read_score -10.0% regression
Date: Thu, 6 Jul 2017 07:45:27 +0800
Message-ID: <CACVXFVNWpWb0f-tp2r82Juzq3QH2Prw_gzqVY9tySnAQsLg2Kg@mail.gmail.com>
References: <20170703025722.GG7070@yexl-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170703025722.GG7070@yexl-desktop>
Sender: linux-kernel-owner@vger.kernel.org
To: kernel test robot <xiaolong.ye@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <JBottomley@odin.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, LKP ML <lkp@01.org>
List-Id: linux-scsi@vger.kernel.org

Hi Xiaolong,

On Mon, Jul 3, 2017 at 10:57 AM, kernel test robot
<xiaolong.ye@intel.com> wrote:
>
> Greeting,
>
> FYI, we noticed a -10.0% regression of blogbench.read_score due to commit:

Looks like related with mq scheduler, could you test the following patch to see
if your issue can be fixed?

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/commit/?h=for-linus&id=32825c45ff8f4cce937ab85b030dc693ceb1aa0a


Thanks,
Ming Lei
